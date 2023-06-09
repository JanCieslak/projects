import { build } from 'vite';

/** @type {import('vite').UserConfig} */
export default {
    root: './',
    assetsInclude: ['**/*.wasm'],
    publicDir: './zig',
    build: {
        target: ''
    }
}