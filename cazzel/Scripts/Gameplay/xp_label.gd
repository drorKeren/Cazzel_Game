extends Node

@onready var audio: AudioStreamPlayer2D = $Audio

func _ready() -> void:
	audio.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
