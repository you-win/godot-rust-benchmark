extends Node2D

var loader := preload("res://addons/gdnative-runtime-loader/gdnative_runtime_loader.gd").new()

func _ready() -> void:
	loader.presetup()
	loader.setup()
	var my_bench = loader.create_class("native-lib", "MyBenchNode2D")
	add_child(my_bench)
