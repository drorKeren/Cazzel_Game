extends Node

@export var scene = "res://Scenes/castle.tscn"
@export var transition : AnimationPlayer

func _on_pressed() -> void:
	transition.play_backwards("Open")
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file(scene)
