extends Node

@onready var death_menu: Control = $CanvasLayer/DeathMenu

@onready var xp_text: Label = $CanvasLayer/XP_text
@onready var death_xp_text: Label = $CanvasLayer/DeathMenu/XP_text
@onready var hp_text: Label = $CanvasLayer/HP_text

@export var transition : AnimationPlayer

var xp = 0
var hp = 100

func _ready() -> void:
	transition.play("RESET")
	
	transition.play("Open")
	if death_menu != null:
		death_menu.visible = false

func remove_enemies(type : String):
	for child in get_children():
		# Checking if the child has the enemy.gd script
		if child != null and child.has_method("destroy") and child.type == type:
			child.destroy()
			await get_tree().create_timer(0.05).timeout

func add_xp(my_xp):
	if death_menu.visible == true:
		return
	
	xp += my_xp
	xp_text.text = str(xp) + "\nXP"
	death_xp_text.text = str(xp)

func damage(dmg):
	if death_menu.visible == true:
		return
	
	hp = max(0, hp - dmg)
	hp_text.text = str(hp) + " HP"
	
	if hp <= 0 and death_menu != null:
		death_menu.visible = true
