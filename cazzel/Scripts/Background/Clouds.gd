extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if not anim.is_playing():
		anim.play("Movement")
