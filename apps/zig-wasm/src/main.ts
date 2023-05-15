const textDecoder = new TextDecoder()
const textEncoder = new TextEncoder()

const qnan = 0x7ff8_0000

interface Ref {
    head: number
    kind: number
    id: number
}

type RefOrNumber = Ref | number

const isNumber = (refOrNumber: RefOrNumber): refOrNumber is number => typeof refOrNumber === 'number'

class ZigWasm {
    memory?: WebAssembly.Memory
    run?: () => void
    values: Array<any> = [NaN, undefined, null, true, false, globalThis]
    refKinds = new Map<string, number>([
        ['string', 0],
        ['boolean', 1],
        ['symbol', 2],
        ['undefined', 3],
        ['object', 4],
        ['function', 5],
    ])

    init = (object: WebAssembly.WebAssemblyInstantiatedSource) => {
        console.log(object.instance)
        const { memory, run } = object.instance.exports
        this.memory = memory as WebAssembly.Memory
        this.run = run as () => void
    }

    getMemoryBuffer = (): ArrayBuffer => this.memory!.buffer
    getMemoryView = (): DataView => new DataView(this.memory!.buffer)
    getMemoryBlock = (offset: number, len: number) => new Uint32Array(this.getMemoryBuffer(), offset, len)

    getKindId = (object: any): number => this.refKinds.get(typeof object)!

    getString = (ptr: number, len: number): string => textDecoder.decode(new Uint8Array(this.getMemoryBuffer(), ptr, len))
    getRefOrNumber = (ptr: number): RefOrNumber => {
        const view = this.getMemoryView()

        const num = view.getFloat64(ptr, true)
        if (!Number.isNaN(num)) {
            return num
        }

        const id = view.getUint32(ptr, true)
        return this.values[id]
    }
    createRefIfNeeded = (object: any): RefOrNumber => {
        if (typeof object === 'number' && !Number.isNaN(object)) {
            return object
        }
        const head = qnan
        const kind = this.getKindId(object)
        const id = this.values.push(object) - 1
        return { head, kind, id }
    }
    returnRefOrNumber = (out: number, ref: RefOrNumber) => {
        const view = this.getMemoryView()
        if (isNumber(ref)) {
            view.setFloat64(out, ref, true)
        } else {
            view.setUint32(out + 4, ref.head | ref.kind, true)
            view.setUint32(out, ref.id, true)
        }
    }

    importObject = (): WebAssembly.Imports => {
        return {
            env: {
                // TODO: Replace console log with get + call
                consoleLog: (ptr: number, len: number) => console.log(this.getString(ptr, len)),
                get: (out: number, id: number, memberName: number, memberNameLen: number) => {
                    const value = this.values[id]
                    const member = this.getString(memberName, memberNameLen)
                    const result = Reflect.get(value, member)
                    const refOrNumber = this.createRefIfNeeded(result)
                    this.returnRefOrNumber(out, refOrNumber)
                },
                call: (thisId: number, fnNamePtr: number, fnNameLen: number, argsPtr: number, argsLen: number) => {
                    const target = this.values[thisId]
                    const fn = Reflect.get(target, this.getString(fnNamePtr, fnNameLen))
                    const view = this.getMemoryView()
                    const args = []
                    for (let i = 0; i < argsLen; ++i) {
                        const ptr = argsPtr + i * 8
                        const ref = this.getRefOrNumber(ptr)
                        isNumber(ref) ? args.push(ref) : args.push(this.values[view.getUint32(ptr, true)])
                    }
                    Reflect.apply(fn, target, args)
                },
                createStringRef: (out: number, ptr: number, len: number) => {
                    const ref = this.createRefIfNeeded(this.getString(ptr, len))
                    this.returnRefOrNumber(out, ref)
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
