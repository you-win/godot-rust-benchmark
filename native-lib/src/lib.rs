mod bench;

use gdnative::prelude::*;

fn init(handle: InitHandle) {
    handle.add_class::<bench::MyBench>();
	handle.add_class::<bench::MyBenchNode2D>();
}

godot_init!(init);
