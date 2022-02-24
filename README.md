# godot-rust-benchmark

gdscript vs. visual scripting vs. gdnative (rust)

Task: 6k DrawLine using `sin`/`cos` in a circle

Modified to also use [GDNative Runtime Loader](https://github.com/you-win/gdnative-runtime-loader) which allows for native libraries to be loaded at runtime (aka libaries can be added without needing to reexport the Godot project).

## Building
1. Run `cargo build --release` in the `native-lib` folder
2. Copy the resulting binary to `godot/native-lib/` and register the file in `godot/native-lib/libnative.tres`
3. For runtime loading, copy the resulting binary to `godot/plugins/native-lib/` and register the file in `godot/native-lib/config.ini`. See [the GDNative Runtime Loader readme](https://github.com/you-win/gdnative-runtime-loader#example) for an example.

## Results

### Computer specs
* CPU: AMD Ryzen 7 5800X
* GPU: NVIDIA GeForce RTX 3080
* RAM: 32gb of something i forgot

Results are calculated by just looking at the logs and guessing at what the average is.

| type | usecs | slowdown | 
|---|---|---|
| gdnative (rust) | ~400 usec | - |
| gdnative [runtime loaded](https://github.com/you-win/gdnative-runtime-loader) (rust) | ~400 usec | - |
| gdscript | ~3300 usec | 8x |
| visual script | ~5100 usec | 12x |

## Code

### GDScript

```gdscript
var startTime = OS.get_ticks_usec()
var start = Vector2(200,200)

var cntf = float(cnt)
var rad = 200
for n in range(cnt):
    var x = sin(n/cntf * 360.0)*rad
    var y = cos(n/cntf * 360.0)*rad
    draw_line(start, start+Vector2(x, y), Color(255, 0, 0), 1,false)

print("bench: " + String(OS.get_ticks_usec() - startTime))
```

### GDNative using godot-rust

```rust
let start_time = OS::godot_singleton().get_ticks_usec();

let cntf = self.cnt as f32;

for n in 0..self.cnt {
    let x = f32::sin(n as f32 / cntf * 360.0) * self.rad;
    let y = f32::cos(n as f32 / cntf * 360.0) * self.rad;
    let target = Vector2::new(x, y) + self.start;

    owner.draw_line(self.start, target, Color::rgb(0.0, 0.0, 1.0), 1.0, false)
}

godot_print!(
    "bench: {}",
    OS::godot_singleton().get_ticks_usec() - start_time
);
```

### Visual Script

![vsbench](VisScript.png)
