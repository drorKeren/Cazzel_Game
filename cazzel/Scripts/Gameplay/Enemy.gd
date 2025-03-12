extends RigidBody2D

@export var type = "Line" # Line, V, Omega
@export var xp = 5
@export var damage = 10

const NEW_XP = preload("res://Prefabs/new_xp.tscn")

@onready var dataMan: Node2D = $".."

@export var MaxLinearVelX = 450.0
@export var MinLinearVelX = 400.0

@export var MaxLinearVelY = -130.0
@export var MinLinearVelY = -200.0

@export var destroy_timer = 6.0

func _ready() -> void:
	self.linear_velocity.x = randf_range(MinLinearVelX, MaxLinearVelX)
	self.linear_velocity.y = randf_range(MinLinearVelY, MaxLinearVelY)
	await get_tree().create_timer(destroy_timer).timeout
	queue_free()

func destroy():
	dataMan.add_xp(xp)
	
	var new_text = NEW_XP.instantiate()
	dataMan.add_child(new_text)
	
	new_text.position = self.position
	new_text.get_child(0).text = str(xp)
	new_text.rotation = deg_to_rad(randi_range(-30, 30))
	
	self.queue_free()
