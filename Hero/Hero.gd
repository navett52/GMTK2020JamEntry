extends KinematicBody2D

# Exported variables
export (int) var speed = 250
export (int) var health = 100

onready var health_label = $HUD/Health

# Private variables
var direction = Vector2()
var velocity = Vector2()
var damage_taken = false
var gun = Node
var sprite = AnimatedSprite
var anim = "walk-down"
var flip = false


func _ready():
	# Grab a reference to the gun
	gun = get_node("Gun")
	health_label.text = str(health)


func _process(delta):
	# Shoot the gun
	if (Input.is_action_just_pressed("shoot")):
		if (gun.has_method("shoot")):
			gun.shoot()
	
	# Activate ability
	if (Input.is_action_just_pressed("activate_passive")):
		print("Passive activated!")

func take_damage(damage):
	if(!damage_taken):
		health -= damage
		health_label.text = str(health)
		damage_taken = true
		get_tree().create_timer(1).connect("timeout", self, "make_vulnerable")
		if(health <= 0):
			get_tree().change_scene("res://Menu.tscn")

func make_vulnerable():
	damage_taken = false

# Simple movement code. Works pretty well, actually.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


# Get input and determine direction
func get_input():
	velocity = Vector2()
	direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		anim = "walk_left"
		$Sprite.flip_h = true
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		anim = "walk_left"
		$Sprite.flip_h = false
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		anim = "walk_down"
		$Sprite.flip_h = false
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		anim = "walk_up"
		$Sprite.flip_h = false
	if(direction.x == 0 && direction.y == 0):
		$Sprite.stop()
	else:
		$Sprite.play(anim)
	velocity = direction.normalized() * speed
