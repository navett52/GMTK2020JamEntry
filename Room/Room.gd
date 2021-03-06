extends Node2D


enum room_type {
	PHYSICS,
	TIME,
#	SHAPE,
	NORMAL
}


# Public variables
export (Vector2) var room_size = Vector2(42, 42)
export (room_type) var type = room_type.NORMAL

# Private variables
var player
var room_count = 0
var enemy_count = 0
var rooms_completed = 0
var tile_map = TileMap
var default_tile = 0
var default_time_step
var timer = Timer
var rand = RandomNumberGenerator.new()
onready var audio

# Resources
var tile_set = load("res://Art/Tileset/Walls.tres")
var physics_object = load("res://Objects/Physics.tscn")

var song1 = load("res://Songs/S-Sound 2.wav")
var song2 = load("res://Songs/S-Sound3.wav")

var SmallEnemy = load("res://Enemies/SmallEnemy.tscn")
var BigEnemy = load("res://Enemies/BigEnemy.tscn")

var House = load("res://Room/Structures/House.tscn")

var menu = load("res://Menu.tscn")


func _ready():
	player = G.hero
	# Randomize the seed
	rand.randomize()
	# Make sure to grab the default time step to not lose it
	default_time_step = Engine.time_scale
	audio = get_parent().get_node("AudioStreamPlayer2D")
	# Generate the first room
	generate_room()
	room_count = 0


func _process(delta):
	# If all enemies in the room have been defeated, we'll need to trigger loading a new room
	if (enemy_count <= 0 or Input.is_action_just_pressed("reload_room")):
		type = rand.randi_range(0, room_type.size() - 1)
		Engine.time_scale = default_time_step
		match(type):
			room_type.PHYSICS:
				print("Physics")
				generate_physics_room()
			room_type.TIME:
				print("Time")
				generate_time_room()
#			room_type.SHAPE:
#				print("Shape")
#				generate_shape_room()
			room_type.NORMAL:
				print("Normal")
				generate_room()


func get_enemy_count():
	for child in get_parent().get_children():
		if child.has_method("freeze"):
			enemy_count += 1
			child.connect("died", self, "update_enemy_count")
	print(enemy_count)


func update_enemy_count():
	enemy_count -= 1
	print(enemy_count)


func generate_physics_room():
	# The code for adding the physics objects lies in the fill() method
	generate_room()


func generate_time_room():
	generate_room()
	timer = Timer.new()
	timer.wait_time = rand.randi_range(1, 5)
	timer.autostart = true
	timer.connect("timeout", self, "time_behavior")
	add_child(timer)


#func generate_shape_room():
#	generate_room()


func time_behavior():
	Engine.time_scale = rand.randf_range(0.0, 3.0)
	timer.wait_time = rand.randi_range(1, 5)


# High level method to generate the room
func generate_room():
	if room_count >= 9:
		get_tree().change_scene_to(menu)
	reset()
	room_size = Vector2(rand.randi_range(30, 45), rand.randi_range(30, 45))
	tile_map = TileMap.new()
	tile_map.tile_set = tile_set
	tile_map.cell_size = Vector2(16, 16)
	add_child(tile_map)
	outline()
	fill(5, 5)
	tile_map.update_bitmask_region()
	get_enemy_count()
	if (rand.randf() < .5):
		audio.stream = song1
		audio.playing = true
	else:
		audio.stream = song2
		audio.playing = true
	player.global_position = Vector2(200, 200)
	room_count += 1


# Outline the room with tiles so the player is constrained
func outline():
	# Make the left side
	for i in range(room_size.y):
		tile_map.set_cell(0, i, default_tile)
		# Check to see if we should make an outcropping
#		if (randf() < .3):
#			generate_outcrop(Vector2(0, i), rand.randi_range(1, 5))
	
	# Make right side
	for i in range(room_size.y):
		tile_map.set_cell(room_size.x, i, default_tile)
#		if (randf() < .3):
#			generate_outcrop(Vector2(room_size.x, i), rand.randi_range(1, 5))
	
	# Make top
	for i in range(room_size.x):
		tile_map.set_cell(i, 0, default_tile)
#		if (randf() < .3):
#			generate_outcrop(Vector2(i, 0), rand.randi_range(1, 5))
	
	# Make bottom
	for i in range(room_size.x):
		tile_map.set_cell(i, room_size.y - 1, default_tile)
#		if (randf() < .3):
#			generate_outcrop(Vector2(i, room_size.y -1), rand.randi_range(1, 5))


# Fill the room with exciting things like obstacles and enemies
# Need to add enemies to this loop, as well as some collision checking
func fill(x_step, y_step):
	# Filling the ground with ground tiles
	for x in range(1, room_size.x):
		for y in range(1, room_size.y):
			tile_map.set_cell(x, y, default_tile)
	
	# Spawning enemies
	for x in range(2, room_size.x - 2):
		for y in range(2, room_size.y - 2):
			if (randf() < .003):
				var small = SmallEnemy.instance()
				small.global_position = Vector2(x * tile_map.cell_size.x, y * tile_map.cell_size.y)
				get_parent().add_child(small)
			
			if (randf() < .0015):
				var house = House.instance()
				house.global_position = Vector2(x * tile_map.cell_size.x, y * tile_map.cell_size.y)
				get_parent().add_child(house)
			
			if (randf() < .002):
				var big = BigEnemy.instance()
				big.global_position = Vector2(x * tile_map.cell_size.x, y * tile_map.cell_size.y)
				get_parent().add_child(big)
			
			if (type == room_type.PHYSICS):
				if (randf() < .005):
					var object = physics_object.instance()
					object.global_position = Vector2(x * tile_map.cell_size.x, y * tile_map.cell_size.y)
					add_child(object)

			y += y_step
		x += x_step


# Generate an outcrop from the wall
func generate_outcrop(center:Vector2, radius:int):
	# Right now the outcrops are just circles for convenience
	# They actually look pretty good
	generate_circle(center, radius, default_tile)


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


func check_collision(object):
	var used_cells = tile_map.get_used_cells()
	var object_cells = object.get_used_cells()
	var used
	var pos
	for i in used_cells.size():
		used = used_cells[i]
		for j in object_cells.size():
			pos = object_cells[j]
			if (pos == used):
				return true
	return false


# Clear the room of everything so we can generate a new one
func reset():
	# We clear the room by looping through all children and deleting them
	for child in get_children():
		child.queue_free()
