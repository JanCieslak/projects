type Value = {
    head: number;
    kind: number;
    id: number;
} | number;
type StartFnType = (stringPtr: number, stringLen: number) => void;
type UpdateFnType = (timestamp: number) => void;
type AllocFnType = (len: number) => number;
export declare class ZigWasm {
    shouldFinish: boolean;
    memory?: WebAssembly.Memory;
    start?: StartFnType;
    update?: UpdateFnType;
    alloc?: AllocFnType;
    exports?: WebAssembly.Exports;
    values: Array<any>;
    ValueTypes: Map<string, number>;
    init: (object: WebAssembly.WebAssemblyInstantiatedSource) => void;
    getMemoryBuffer: () => ArrayBuffer;
    getMemoryView: () => DataView;
    getMemoryBlock: (offset: number, len: number) => Uint32Array;
    getKindId: (object: any) => number;
    getString: (ptr: number, len: number) => string;
    getValue: (ptr: number) => Value;
    createValueIfNeeded: (object: any) => Value;
    returnValue: (out: number, value: Value) => void;
    importObject: () => WebAssembly.Imports;
}
export {};
