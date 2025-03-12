extends Node2D

@export var type = "Line" # Line, V, Omega
const SPEED = 3

@onready var audio: AudioStreamPlayer2D = $"../Audio2"

func _process(delta: float) -> void:
	self.scale = lerp(self.scale, Vector2(3,3), delta * SPEED)
	self.rotation = lerp(self.rotation, 0.0, delta * SPEED)

func destroy():
	if audio != null:
		audio.play()
	
	self.scale = Vector2(5,5)
	self.rotation = deg_to_rad(randi_range(-70, 70))
