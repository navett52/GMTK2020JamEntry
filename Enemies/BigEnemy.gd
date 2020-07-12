extends KinematicBody2D

onready var player = get_parent().get_node("Hero")
export var speed = 175
export var dash_speed = 500
export var health = 100

var bullet = preload("res://Enemies/enemyProjectile.tscn")
var normal_dir = Vector2(0, 1)

var velocity = Vector2()
var d_velocity = Vector2()
var states = ["dash", "AOE", "shoot"]
var state
var waiting = false
var dashing = false
var frozen = false
var timer = 0
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	select_state()

func _process(delta):
	# print(distance_to_object(player))
	# if the player is in line of sight
	if(is_in_line_of_sight(player)):
		if player.position.x > position.x:
			velocity.x += speed
		if player.position.x < position.x:
			velocity.x -= speed
		if player.position.y > position.y:
			velocity.y += speed
		if player.position.y < position.y:
			velocity.y -= speed
	else:
		# if can't see player, don't move
		velocity.x = 0
		velocity.y = 0

func _physics_process(delta):
	if(state == "dash" && distance_to_object(player) <= 200 && !waiting && is_in_line_of_sight(player)):
		d_velocity = (player.get_position()-self.get_position()).normalized() * dash_speed
		waiting = true
		waitDash(1)
	elif(state == "AOE" && distance_to_object(player) <= 100 && !waiting):
		waiting = true
		waitAOE(1)
	elif(state == "shoot" && distance_to_object(player) <= 300 && !waiting):
		waiting = true
		waitShoot(1)
	elif(!waiting):
		# normalizes the velocity vector, and then sets it to the declared speed
		velocity = velocity.normalized() * speed
		move_and_slide(velocity)
	elif(waiting && dashing):
		if(timer < 30):
			timer += 1
			move_and_slide(d_velocity)
		else:
			waiting = false
			dashing = false
			timer = 0

	for i in get_node("Area2D2").get_overlapping_bodies():
		if(i.get_name() == "Hero"):
			i.take_damage(15)

func dash():
	dashing = true

func AOE():
	showSplo()
	get_tree().create_timer(0.5).connect("timeout", self, "hideSplo")
	for i in get_node("Area2D").get_overlapping_bodies():
		if(i.get_name() == "Hero"):
			i.take_damage(10)

func showSplo():
	get_node("splosion").visible = true

func hideSplo():
	get_node("splosion").visible = false
	waiting = false

func shoot():
	if(!frozen):
		var clone = bullet.instance()
		self.get_parent().add_child(clone)
		clone.global_transform = self.global_transform
		var angle = get_aim_angle()
		if(45 <= angle && angle <= 135):
			clone.global_position.x -= 27
		elif(135 < angle && angle <= 180):
			clone.global_position.y -= 27
		elif(-180 < angle && angle < -135):
			clone.global_position.y -= 27
		elif(-135 <= angle && angle <= -45):
			clone.global_position.x += 27
		elif(-45 < angle && angle <= 0):
			clone.global_position.y += 27
		elif(0 < angle && angle < 45):
			clone.global_position.y += 27

		clone.initialize((player.get_position()-self.get_position()).normalized())
		waiting = false

func get_aim_angle():
	var b = (player.get_position()-self.get_position()).normalized()
	var a = normal_dir

	var dot = a.dot(b)
	var angle = rad2deg(acos(dot))
	if(self.get_position().x >= player.get_position().x):
		return angle
	else:
		return -angle

func distance_to_object(thing):
	if thing != null:
		# return sqrt(abs((int(self.get_position().x - thing.get_position().x)^2) + (int(self.get_position().y - thing.get_position().y)^2)))
		return (self.get_global_transform().get_origin().distance_to(thing.get_global_transform().get_origin()))

func waitDash(time):
	get_tree().create_timer(time).connect("timeout", self, "dash")

func waitAOE(time):
	get_tree().create_timer(time).connect("timeout", self, "AOE")

func waitShoot(time):
	get_tree().create_timer(time).connect("timeout", self, "shoot")

func select_state():
	state = states[randi()%3]
	print(state)
	get_tree().create_timer(5).connect("timeout", self, "select_state")

func take_damage(damage):
	health -= damage
	
	if(health <= 0):
		emit_signal("died")
		queue_free()

func freeze():
	waiting = true
	frozen = true
	get_tree().create_timer(4).connect("timeout", self, "unfreeze")

func unfreeze():
	waiting = false
	frozen = false

func dot():
	get_tree().create_timer(1).connect("timeout", self, "dot_dmg")
	get_tree().create_timer(2).connect("timeout", self, "dot_dmg")
	get_tree().create_timer(3).connect("timeout", self, "dot_dmg")

func dot_dmg():
	self.take_damage(20)

#checks to see if our enemy has line of sight with the player
#Pulled this from the internet, not entirely sure how it works lol
func is_in_line_of_sight(thing):
	var space = get_world_2d().direct_space_state
	if thing != null:
		var parent = self.get_parent()
		var nodes = parent.get_children()
		var exclusions = [self]

		for i in nodes:
			if i.has_method("is_in_line_of_sight"):
				exclusions.append(i)

		var line_of_sight_obstacle = space.intersect_ray(global_position,
				thing.global_position, exclusions, collision_mask)

		if line_of_sight_obstacle.collider == thing:
			return true
		else:
			return false
