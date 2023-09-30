# Welcome

TODO: ...

## Projects

### Golang + WASM

- Include wasm_exec.js only if golang wasm is used
- keep wasm files organized
- prepare a scripts that would build wasm and put it in the right folder (with replace)
  - not os based (no powershell, bash, etc.)

### Zig + WASM

Zig + WASM based on Golang approach of interacting with website through WASM

- Pass multiple arguments into wasm programs (generic solution - any number of args of any type)
- Start making physics engine with CanvasRenderer
- General code refactor (TODOs, Shader, GLRenderer, etc.)
  - WebGL module
    - Shaders
      - Shader error logging
      - MVP
      - Shader for drawing circles (filled, outlined)
      - Shader for drawing box (outlined) ??? - can it be combined with the prev one ?
      - More options for uniform binding
    - Renderer
      - Config as init parameter
      - Defining memory layout / attributes and their type / etc.
      - asssert on add (prevent overflowing)
      - Drawing
      - Box (filled - x, y, w, h, outlined - x, y, w, h, thicc)
      - Circle (filled - x, y, r, outlined - x, y, r, thicc)
      - Line - x1, y1, x2, y2, thicc
  - Make WebGLRenderer and CanvasRenderer interchangeable - same interface
  - Argument passing
    - Passing any type of argument from js to zig (possible ? / easy ?)
      - Calling zig from js at runtime (possible ? / easy ?) - e.g. for dynamic shader reload / shader editor
- Make it a library and split library code from rendering implementation, etc.

NICE TO HAVE:

- Better conosle.log

#### Development

Run **npm run dev** to run the frontend server and from **run-on-change** run **go run main.go ../zig-wasm/zig/src zig build** to run **zig build** on any change
