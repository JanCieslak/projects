const textDecoder = new TextDecoder()
// const textEncoder = new TextEncoder()

const qnan = 0x7ff8_0000

type Value = { head: number; kind: number; id: number } | number

const isNumber = (value: Value): value is number => typeof value === 'number'

type StartFnType = (stringPtr: number, stringLen: number) => void
type UpdateFnType = (timestamp: number) => void
type AllocFnType = (len: number) => number

export class ZigWasm {
    shouldFinish = false
    memory?: WebAssembly.Memory
    start?: StartFnType
    update?: UpdateFnType
    alloc?: AllocFnType
    exports?: WebAssembly.Exports
    values: Array<any> = [NaN, undefined, null, true, false, globalThis, document]
    ValueTypes = new Map<string, number>([
        ['string', 0],
        ['boolean', 1],
        ['symbol', 2],
        ['undefined', 3],
        ['object', 4],
        ['function', 5],
    ])

    init = (object: WebAssembly.WebAssemblyInstantiatedSource) => {
        const { memory, start, update, alloc, ...rest } = object.instance.exports
        this.exports = rest
        this.memory = memory as WebAssembly.Memory
        this.start = start as StartFnType
        this.update = update as UpdateFnType
        this.alloc = alloc as AllocFnType
    }

    getMemoryBuffer = (): ArrayBuffer => this.memory!.buffer
    getMemoryView = (): DataView => new DataView(this.memory!.buffer)
    getMemoryBlock = (offset: number, len: number) => new Uint32Array(this.getMemoryBuffer(), offset, len)

    getKindId = (object: any): number => this.ValueTypes.get(typeof object)!

    getString = (ptr: number, len: number): string => textDecoder.decode(new Uint8Array(this.getMemoryBuffer(), ptr, len))
    getValue = (ptr: number): Value => {
        const view = this.getMemoryView()

        const num = view.getFloat64(ptr, true)
        if (!Number.isNaN(num)) {
            return num
        }

        const id = view.getUint32(ptr, true)
        return this.values[id]
    }
    createValueIfNeeded = (object: any): Value => {
        if (typeof object === 'number' && !Number.isNaN(object)) {
            return object
        }
        const head = qnan
        const kind = this.getKindId(object)
        // TODO: Use already existing value if exists
        
        const id = this.values.push(object) - 1
        return { head, kind, id }
    }
    returnValue = (out: number, value: Value) => {
        const view = this.getMemoryView()
        if (isNumber(value)) {
            view.setFloat64(out, value, true)
        } else {
            view.setUint32(out + 4, value.head | value.kind, true)
            view.setUint32(out, value.id, true)
        }
    }

    importObject = (): WebAssembly.Imports => {
        return {
            env: {
                noLoop: () => { this.shouldFinish = true },
                consoleLog: (ptr: number, len: number) => console.log(this.getString(ptr, len)),
                get: (out: number, id: number, memberName: number, memberNameLen: number) => {
                    const valueRef = this.values[id]
                    const member = this.getString(memberName, memberNameLen)
                    const result = Reflect.get(valueRef, member)
                    const value = this.createValueIfNeeded(result)
                    this.returnValue(out, value)
                },
                getNumber: (out: number, id: number, memberName: number, memberNameLen: number) => {
                    const valueRef = this.values[id]
                    const member = this.getString(memberName, memberNameLen)
                    const result = Reflect.get(valueRef, member)
                    const value = this.createValueIfNeeded(result)
                    this.returnValue(out, value)
                },
                set: (id: number, memberName: number, memberNameLen: number, valuePtr: number) => {
                    const valueRef = this.values[id]
                    const value = this.getValue(valuePtr)
                    Reflect.set(valueRef, this.getString(memberName, memberNameLen), value)
                },
                construct: (out: number, classId: number, argsPtr: number, argsLen: number) => {
                    const view = this.getMemoryView()
                    const args = []
                    for (let i = 0; i < argsLen; ++i) {
                        const ptr = argsPtr + i * 8
                        const value = this.getValue(ptr)
                        isNumber(value) ? args.push(value) : args.push(this.values[view.getUint32(ptr, true)])
                    }
                    const className = this.values[classId]
                    const result = Reflect.construct(className, args)
                    const value = this.createValueIfNeeded(result)
                    this.returnValue(out, value)
                },
                call: (out: number, thisId: number, fnNamePtr: number, fnNameLen: number, argsPtr: number, argsLen: number) => {
                    const target = this.values[thisId]
                    const fn = Reflect.get(target, this.getString(fnNamePtr, fnNameLen))
                    const view = this.getMemoryView()
                    const args = []
                    for (let i = 0; i < argsLen; ++i) {
                        const ptr = argsPtr + i * 8
                        const value = this.getValue(ptr)
                        isNumber(value) ? args.push(value) : args.push(this.values[view.getUint32(ptr, true)])
                    }
                    // console.log(args, this.values)
                    const result = Reflect.apply(fn, target, args)
                    const value = this.createValueIfNeeded(result)
                    this.returnValue(out, value)
                },
                createSliceValue: (out: number, id: number, ptr: number, len: number) => {
                    // TODO: Receive type e.g. "Uint8ClampedArray" or "Uint8Array" to create slice of exact type
                    const slice = Reflect.construct(this.values[id], [this.getMemoryBuffer(), ptr, len])
                    const value = this.createValueIfNeeded(slice)
                    this.returnValue(out, value)
                },
                // right now supports one function
                createFunctionValue: (out: number, functionNamePointer: number, functionNameLen: number, arg: number) => {
                    const fnName = this.getString(functionNamePointer, functionNameLen)
                    const fn = Reflect.get(this.exports!, fnName) as (arg: number) => void
                    fn(arg)
                },
                createStringValue: (out: number, ptr: number, len: number) => {
                    const value = this.createValueIfNeeded(this.getString(ptr, len))
                    this.returnValue(out, value)
                },
            },
        }
    }
}