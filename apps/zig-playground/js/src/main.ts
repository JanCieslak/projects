import { ZigWasm } from 'js'

const textEncoder = new TextEncoder()
const zigWasm = new ZigWasm()

let oldTimestamp = 0;

function updateWrapper(timestamp: number) {
    if (zigWasm.update) {
        zigWasm.update((timestamp - oldTimestamp) / 1000)
    }
    oldTimestamp = timestamp;
    const id = requestAnimationFrame(updateWrapper)

    if (zigWasm.shouldFinish) {
        cancelAnimationFrame(id)
        return
    }
}

WebAssembly.instantiateStreaming(fetch('./resources/zig.wasm'), zigWasm.importObject())
    .then((obj) => zigWasm.init(obj))
    .then(() => {
        if (zigWasm.start && zigWasm.update && zigWasm.alloc) {
            const textBytes = textEncoder.encode('#testing-canvas')
            const ptr = zigWasm.alloc(textBytes.length)
            const buffer = new Uint8Array(zigWasm.getMemoryBuffer(), ptr, textBytes.byteLength)
            buffer.set(textBytes)
            zigWasm.start(ptr, textBytes.length)
            requestAnimationFrame(updateWrapper)
        }
    })
