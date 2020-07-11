extends Node2D


export (Vector2) var room_size = Vector2(42, 42)

var enemy_count = 0
var rooms_completed = 0
var tile_set = load("res://Art/Tileset/Tileset_Placeholder.tres")
var tile_map = TileMap
var house = load("res://Room/Structures/House.tscn")


func _ready():
	# Randomize the seed
	randomize()
	# Generate the first room
	generate_room()


func _process(delta):
	# Debug option to generate a new room
	if (Input.is_action_just_pressed("reload_room")):
		generate_room()
	
	# If all enemies in the room have been defeated, we'll need to trigger loading a new room
	if (enemy_count <= 0):
		# Commented out for now since the enemy count is always 0
		# generate_room()
		pass


# High level method to generate the room
func generate_room():
	reset()
	tile_map = TileMap.new()
	tile_map.tile_set = tile_set
	tile_map.cell_size = Vector2(32, 32)
	add_child(tile_map)
	outline()
	fill(5, 5)


# Outline the room with tiles so the player is constrained
func outline():
	# Make the left side
	for i in range(room_size.y):
		tile_map.set_cell(0, i, 0)
		# Check to see if we should make an outcropping
		if (randf() < .3):
			generate_outcrop(Vector2(0, i), randi() % 5)
	
	# Make right side
	for i in range(room_size.y):
		tile_map.set_cell(room_size.x, i, 0)
		if (randf() < .3):
			generate_outcrop(Vector2(room_size.x, i), randi() % 5)
	
	# Make top
	for i in range(room_size.x):
		tile_map.set_cell(i, 0, 0)
		if (randf() < .3):
			generate_outcrop(Vector2(i, 0), randi() % 5)
	
	# Make bottom
	for i in range(room_size.x):
		tile_map.set_cell(i, room_size.y - 1, 0)
		if (randf() < .3):
			generate_outcrop(Vector2(i, room_size.y -1), randi() % 5)


# Fill the room with exciting things like obstacles and enemies
# Need to add enemies to this loop, as well as some collision checking
func fill(x_step, y_step):
		for x in range(room_size.x):
			for y in range(room_size.y):
				if (randf() < .005):
					print("Generating obstacle")
					var obstacle = house.instance()
					obstacle.global_position = Vector2(x * 32, y * 32)
					add_child(obstacle)
				y += y_step
				pass
			x += x_step


# Generate an outcrop from the wall
func generate_outcrop(center:Vector2, radius:int):
	# Right now the outcrops are just circles for convenience
	# They actually look pretty good
	generate_circle(center, radius, 0)
	pass


# Method I found online to generate a circle
func generate_circle(center_position, radius, tile_id = 0):
	# The right half of the circle:
	for x in range(center_position.x, center_position.x + radius):
		# The bottom right half of the circle:
		for y in range(center_position.y, center_position.y + radius):
			var relative_vector = Vector2(x, y) - center_position;
			if (relative_vector.length() < radius):
				tile_map.set_cell(x, y, tile_id);
		# The top right half of the circle
		for y in range(center_position.y - radius, center_position.y):
			var relative_vector = center_position - Vector2(x, y);
			if (relative_vector.length() < radius):
				tile_map.set_cell(x, y, tile_id);
	# The left half of the circle
	for x in range(center_position.x - radius, center_position.x):
		# The bottom left half of the circle:
		for y in range(center_position.y, center_position.y + radius):
			var relative_vector = Vector2(x, y) - center_position;
			if (relative_vector.length() < radius):
				tile_map.set_cell(x, y, tile_id);
		# The top left half of the circle
		for y in range(center_position.y - radius, center_position.y):
			var relative_vector = center_position - Vector2(x, y);
			if (relative_vector.length() < radius):
				tile_map.set_cell(x, y, tile_id);


# Clear the room of everything so we can generate a new one
func reset():
	# We clear the room by looping through all children and deleting them
	for child in get_children():
		child.queue_free()
