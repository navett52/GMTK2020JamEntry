extends KinematicBody2D

<<<<<<< HEAD
var w=true
=======
>>>>>>> 7797a7560574177d6bed7953c416f09eaafd9f80
# Exported variables
export (int) var speed = 250
export (int) var health = 10

# Private variables
var direction = Vector2()
var velocity = Vector2()
var damage_taken = false
var gun = Node
func _ready():
	# Grab a reference to the gun
	gun = get_node("Gun1")


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
		damage_taken = true
		get_tree().create_timer(1).connect("timeout", self, "make_vulnerable")
		print(health)
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
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	velocity = direction.normalized() * speed
func _input(event):
	if event.is_action("dash_down"):
		move_and_slide(Vector2(0,5000),Vector2.UP)
	if event.is_action("dash_left"):
		move_and_slide(Vector2(-5000,0),Vector2.UP)
	if event.is_action("dash_right"):
		move_and_slide(Vector2(5000,0),Vector2.UP)
	if event.is_action_pressed("switch_weapon"):
		print(w)
		if w:
			$Gun1.enabled=true
			$Gun2.enabled=false
			w=false
		else:
			$Gun1.enabled=false
			$Gun2.enabled=true
			w=true
func hit():
	health-=10
	if health<=0:
		pass #GameOver
	print(health)
func heal():
	if self.health >= 100:
		pass
	else:
		self.health+=10
	print(health)
