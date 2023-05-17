const textDecoder = new TextDecoder()
const textEncoder = new TextEncoder()

const qnan = 0x7ff8_0000

type Value = { head: number; kind: number; id: number } | number

const isNumber = (value: Value): value is number => typeof value === 'number'

class ZigWasm {
    memory?: WebAssembly.Memory
    run?: () => void
    values: Array<any> = [NaN, undefined, null, true, false, globalThis]
    ValueTypes = new Map<string, number>([
        ['string', 0],
        ['boolean', 1],
        ['symbol', 2],
        ['undefined', 3],
        ['object', 4],
        ['function', 5],
    ])

    init = (object: WebAssembly.WebAssemblyInstantiatedSource) => {
        const { memory, run } = object.instance.exports
        this.memory = memory as WebAssembly.Memory
        this.run = run as () => void
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
                consoleLog: (ptr: number, len: number) => console.log(this.getString(ptr, len)),
                get: (out: number, id: number, memberName: number, memberNameLen: number) => {
                    const valueRef = this.values[id]
                    const member = this.getString(memberName, memberNameLen)
                    const result = Reflect.get(valueRef, member)
                    const value = this.createValueIfNeeded(result)
                    this.returnValue(out, value)
                },
                call: (thisId: number, fnNamePtr: number, fnNameLen: number, argsPtr: number, argsLen: number) => {
                    const target = this.values[thisId]
                    const fn = Reflect.get(target, this.getString(fnNamePtr, fnNameLen))
                    const view = this.getMemoryView()
                    const args = []
                    for (let i = 0; i < argsLen; ++i) {
                        const ptr = argsPtr + i * 8
                        const value = this.getValue(ptr)
                        isNumber(value) ? args.push(value) : args.push(this.values[view.getUint32(ptr, true)])
                    }
                    Reflect.apply(fn, target, args)
                },
                createStringValue: (out: number, ptr: number, len: number) => {
                    const value = this.createValueIfNeeded(this.getString(ptr, len))
                    this.returnValue(out, value)
                },
            },
        }
    }
}

const zigWasm = new ZigWasm()

WebAssembly.instantiateStreaming(fetch('/zig-out/lib/zig.wasm'), zigWasm.importObject())
    .then((obj) => zigWasm.init(obj))
    .then(() => {
        if (zigWasm.run) {
            zigWasm.run()
        }
    })
