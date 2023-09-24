const textDecoder = new TextDecoder();
// const textEncoder = new TextEncoder()
const qnan = 2146959360;
const isNumber = (value) => typeof value === 'number';
export class ZigWasm {
    constructor() {
        this.shouldFinish = false;
        this.values = [NaN, undefined, null, true, false, globalThis, document];
        this.ValueTypes = new Map([
            ['string', 0],
            ['boolean', 1],
            ['symbol', 2],
            ['undefined', 3],
            ['object', 4],
            ['function', 5],
        ]);
        this.init = (object) => {
            const { memory, start, update, alloc, ...rest } = object.instance.exports;
            this.exports = rest;
            this.memory = memory;
            this.start = start;
            this.update = update;
            this.alloc = alloc;
        };
        this.getMemoryBuffer = () => this.memory.buffer;
        this.getMemoryView = () => new DataView(this.memory.buffer);
        this.getMemoryBlock = (offset, len) => new Uint32Array(this.getMemoryBuffer(), offset, len);
        this.getKindId = (object) => this.ValueTypes.get(typeof object);
        this.getString = (ptr, len) => textDecoder.decode(new Uint8Array(this.getMemoryBuffer(), ptr, len));
        this.getValue = (ptr) => {
            const view = this.getMemoryView();
            const num = view.getFloat64(ptr, true);
            if (!Number.isNaN(num)) {
                return num;
            }
            const id = view.getUint32(ptr, true);
            return this.values[id];
        };
        this.createValueIfNeeded = (object) => {
            if (typeof object === 'number' && !Number.isNaN(object)) {
                return object;
            }
            const head = qnan;
            const kind = this.getKindId(object);
            // TODO: Use already existing value if exists
            const id = this.values.push(object) - 1;
            return { head, kind, id };
        };
        this.returnValue = (out, value) => {
            const view = this.getMemoryView();
            if (isNumber(value)) {
                view.setFloat64(out, value, true);
            }
            else {
                view.setUint32(out + 4, value.head | value.kind, true);
                view.setUint32(out, value.id, true);
            }
        };
        this.importObject = () => {
            return {
                env: {
                    noLoop: () => { this.shouldFinish = true; },
                    consoleLog: (ptr, len) => console.log(this.getString(ptr, len)),
                    get: (out, id, memberName, memberNameLen) => {
                        const valueRef = this.values[id];
                        const member = this.getString(memberName, memberNameLen);
                        const result = Reflect.get(valueRef, member);
                        const value = this.createValueIfNeeded(result);
                        this.returnValue(out, value);
                    },
                    getNumber: (out, id, memberName, memberNameLen) => {
                        const valueRef = this.values[id];
                        const member = this.getString(memberName, memberNameLen);
                        const result = Reflect.get(valueRef, member);
                        const value = this.createValueIfNeeded(result);
                        this.returnValue(out, value);
                    },
                    set: (id, memberName, memberNameLen, valuePtr) => {
                        const valueRef = this.values[id];
                        const value = this.getValue(valuePtr);
                        Reflect.set(valueRef, this.getString(memberName, memberNameLen), value);
                    },
                    construct: (out, classId, argsPtr, argsLen) => {
                        const view = this.getMemoryView();
                        const args = [];
                        for (let i = 0; i < argsLen; ++i) {
                            const ptr = argsPtr + i * 8;
                            const value = this.getValue(ptr);
                            isNumber(value) ? args.push(value) : args.push(this.values[view.getUint32(ptr, true)]);
                        }
                        const className = this.values[classId];
                        const result = Reflect.construct(className, args);
                        const value = this.createValueIfNeeded(result);
                        this.returnValue(out, value);
                    },
                    call: (out, thisId, fnNamePtr, fnNameLen, argsPtr, argsLen) => {
                        const target = this.values[thisId];
                        const fn = Reflect.get(target, this.getString(fnNamePtr, fnNameLen));
                        const view = this.getMemoryView();
                        const args = [];
                        for (let i = 0; i < argsLen; ++i) {
                            const ptr = argsPtr + i * 8;
                            const value = this.getValue(ptr);
                            isNumber(value) ? args.push(value) : args.push(this.values[view.getUint32(ptr, true)]);
                        }
                        // console.log(args, this.values)
                        const result = Reflect.apply(fn, target, args);
                        const value = this.createValueIfNeeded(result);
                        this.returnValue(out, value);
                    },
                    createSliceValue: (out, id, ptr, len) => {
                        // TODO: Receive type e.g. "Uint8ClampedArray" or "Uint8Array" to create slice of exact type
                        const slice = Reflect.construct(this.values[id], [this.getMemoryBuffer(), ptr, len]);
                        const value = this.createValueIfNeeded(slice);
                        this.returnValue(out, value);
                    },
                    // right now supports one function
                    createFunctionValue: (out, functionNamePointer, functionNameLen, arg) => {
                        const fnName = this.getString(functionNamePointer, functionNameLen);
                        const fn = Reflect.get(this.exports, fnName);
                        fn(arg);
                    },
                    createStringValue: (out, ptr, len) => {
                        const value = this.createValueIfNeeded(this.getString(ptr, len));
                        this.returnValue(out, value);
                    },
                },
            };
        };
    }
}
