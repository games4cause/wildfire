extends Node

var current_scene: Node = null
var startup_scene := preload("res://scenes/startup.tscn") # Preload the scene at compile time

func _ready():
	# Load the preloaded startup scene on boot
	goto_scene(startup_scene)


func goto_scene(scene: PackedScene):
	if current_scene:
		current_scene.queue_free()
	var new_scene = scene.instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
