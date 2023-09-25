import WasmReload from './wasmReload';

/** @type {import('vite').UserConfig} */
export default {
    root: './',
    build: {
        watch: {
            include: 'resources/**'
        }
    },
    plugins: [
        WasmReload(),
    ],
}