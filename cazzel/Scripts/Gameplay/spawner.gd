extends Node2D

@onready var dataMan: Node2D = $".."
@export var blocksLevel1 : Array[PackedScene]
@export var blocksLevel2 : Array[PackedScene]
@export var blocksLevel3 : Array[PackedScene]

var current_wave : Array[RigidBody2D]

const MAX_SPAWN_POS = 150
const MIN_SPAWN_POS = -150

var burst = 1 # The amount of spawned blocks every "wave"
var wave = 0

func _process(_delta: float) -> void:
	# Check if all blocks from the current wave are removed
	if current_wave.all(is_null):
		wave += 1  # Increase wave count
		
		# Every 3 waves, increase the burst size
		if wave % 3 == 0:
			burst += 1
		
		# Spawn a new wave
		spawn_wave()

func is_null(obj):
	# Helper function to check if an object is null
	return obj == null

func spawn_wave():
	# Spawns a new wave based on the current wave number
	if wave != 12:
		for i in range(burst):
			if wave < 5:
				# Spawn Level 1 blocks in early waves
				spawn(blocksLevel1[randi_range(0, blocksLevel1.size() - 1)])
			elif wave >= 5 and wave < 8:
				# Spawn Level 2 blocks in mid waves
				spawn(blocksLevel2[randi_range(0, blocksLevel2.size() - 1)])
			else:
				# Spawn mixed blocks from all levels in later waves
				var spawn_block = blocksLevel1 + blocksLevel2 + blocksLevel3
				spawn(spawn_block[randi_range(0, spawn_block.size() - 1)])
	else:
		# Spawn "mona_lisa" special block at wave 12
		spawn(preload("res://Prefabs/mona_lisa.tscn"))

func spawn(block : PackedScene) -> void:
	# Spawns an individual block at a random position
	if block != null:
		var new_block = block.instantiate()
		dataMan.add_child(new_block)  # Add to the scene
		current_wave.append(new_block)  # Track it in the current wave
		
		# Assign a random spawn position within defined limits
		new_block.position.y = self.position.y + randi_range(MIN_SPAWN_POS, MAX_SPAWN_POS)
		new_block.position.x = self.position.x + randi_range(MIN_SPAWN_POS, MAX_SPAWN_POS)
