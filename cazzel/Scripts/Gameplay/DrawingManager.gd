extends Node

# Hello There!
#
# This is the main interesting part of the project
# If you see some issues in the code, remember I made it in 24 hours
# For the Micro Jam 035

@onready var line: Line2D = $"../Line2D"
@onready var dataMan: Node2D = $".."

@onready var audio: AudioStreamPlayer2D = $"../Audio"

var points: Array[Vector2] = []
var is_drawing: bool = false

var remove_timer = 0.2
var remove_counter = 0.0
var did_remove = true

func _ready() -> void:
	remove_counter = remove_timer

func _process(delta: float) -> void:
	# Handles the automatic clearing of the drawn line after a delay
	if remove_counter > 0 and not is_drawing:
		remove_counter -= delta
	elif not did_remove:
		points.clear()
		line.clear_points()
		remove_counter = remove_timer
		did_remove = true

func _input(event):
	# Handles user input for drawing
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drawing()
			else:
				stop_drawing()
	
	elif event is InputEventMouseMotion and is_drawing:
		# Add new point to the drawing if mouse moves while drawing
		draw_point(event.position)

func start_drawing():
	# Start a new drawing sequence
	is_drawing = true
	did_remove = true
	points.clear()
	line.clear_points()

func draw_point(position: Vector2):
	# Adds a new point to the shape
	points.append(position)
	line.add_point(position)

func stop_drawing():
	# Stops drawing and processes the shape
	is_drawing = false
	did_remove = false
	
	if audio != null:
		# Plays a sound with slight pitch variation for effect
		audio.pitch_scale = randf_range(0.8, 1.2)
		audio.play()
	
	process_shape()

func process_shape():
	# Processes the drawn shape and identifies it
	if points.size() < 5:
		return  # Ignore small shapes
	
	var shape = recognize_shape()
	if shape != "Unknown":
		# Calls function to remove enemies if a shape is recognized
		dataMan.remove_enemies(shape)

func recognize_shape() -> String:
	# Determines which shape was drawn
	if is_crown_shape():
		return "Crown"
	
	if is_vertical_line():
		return "Line"
	
	if is_v_shape():
		return "V"
	
	if is_u_shape():
		return "Omega"
	
	return "Unknown"

func is_vertical_line() -> bool:
	# Determines if the drawn shape is a vertical line
	var min_x = points[0].x
	var max_x = points[0].x
	var min_y = points[0].y
	var max_y = points[0].y
	
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var width = max_x - min_x
	var height = max_y - min_y
	
	# A vertical line should be significantly taller than wide
	return width < height * 0.5

func is_u_shape() -> bool:
	# Determines if the drawn shape is a "U" (Omega) shape
	if points.size() < 5:
		return false
	
	var min_y = points[0].y
	var max_y = points[0].y
	var min_x = points[0].x
	var max_x = points[0].x
	
	for point in points:
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
	
	var width = max_x - min_x
	var height = max_y - min_y
	
	# Height must be at least half the width
	var mid_index = points.size() / 2
	var middle = points[mid_index]
	
	# Middle should be highest, sides lower
	return (middle.y < points.front().y and middle.y < points.back().y) and width > height * 1.2

func is_v_shape() -> bool:
	# Determines if the drawn shape is a "V" shape
	if points.size() < 5:
		return false
	
	var mid_index = points.size() / 2
	var middle = points[mid_index]
	var left = points.front()
	var right = points.back()
	
	# Middle should be noticeably lower than both sides
	var threshold = (left.y + right.y) * 0.6
	var left_slope_ok = middle.y > left.y * 0.85
	var right_slope_ok = middle.y > right.y * 0.85
	
	return middle.y > threshold and left_slope_ok and right_slope_ok

func is_crown_shape() -> bool:
	# Determines if the drawn shape is a "Crown" shape (with peaks)
	if points.size() < 5:
		return false
	
	var peak_count = 0
	var avg_y = 0.0
	
	# Calculate the average Y position of all points
	for p in points:
		avg_y += p.y
	avg_y /= points.size()
	
	# Detect peaks based on relative height
	for i in range(1, points.size() - 1):
		var prev = points[i - 1]
		var curr = points[i]
		var next = points[i + 1]
		
		# A peak is lower than both its neighbors and below average Y
		if curr.y < prev.y and curr.y < next.y and curr.y < avg_y * 1.0:
			peak_count += 1
	
	# Ensure crown has at least 2 peaks
	return peak_count >= 2
