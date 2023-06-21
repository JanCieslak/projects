
export default function WasmReload() {
    return {
      name: 'wasm-reload',
      enforce: 'post',
      handleHotUpdate({ file, server }) {
        if (file.endsWith('.wasm')) {
          server.ws.send({
            type: 'full-reload',          
            path: '*'
          });
        }
      },
    }
}