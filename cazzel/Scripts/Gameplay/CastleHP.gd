extends Area2D

@onready var dataMan: Node2D = $".."

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("destroy"):
		dataMan.damage(body.damage)
		body.destroy()
