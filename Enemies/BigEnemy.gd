extends KinematicBody2D

onready var player = get_parent().get_node("Hero")
export var speed = 175
export var dash_speed = 500
var velocity = Vector2()
var d_velocity = Vector2()
var states = ["dash", "AOE", "shoot"]
var state = "AOE"
var waiting = false
var dashing = false
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	#print(distance_to_object(player))
	#if the player is in line of sight
	if(is_in_line_of_sight(player) && distance_to_object(player) <= 400):
		
		if player.position.x > position.x:
			velocity.x += speed
		if player.position.x < position.x:
			velocity.x -= speed
		if player.position.y > position.y:
			velocity.y += speed
		if player.position.y < position.y:
			velocity.y -= speed
	else:
		#if can't see player, don't move
		velocity.x = 0
		velocity.y = 0

func _physics_process(delta):
	if(state == "dash" && distance_to_object(player) <= 200 && !waiting):
		d_velocity = (player.get_position()-self.get_position()).normalized() * dash_speed
		waiting = true
		waitDash(3)
	elif(state == "AOE" && distance_to_object(player) <= 100 && !waiting):
		waiting = true
		waitAOE(2)
	elif(!waiting):
		#normalizes the velocity vector, and then sets it to the declared speed
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

func dash():
	dashing = true

func AOE():
	showSplo()
	get_tree().create_timer(0.5).connect("timeout", self, "hideSplo")
	for i in get_node("Area2D").get_overlapping_bodies():
		if(i.get_name() == "Hero"):
			print("sploded")
	pass

func showSplo():
	get_node("splosion").visible = true

func hideSplo():
	get_node("splosion").visible = false
	waiting = false

func shoot():
	pass

func distance_to_object(thing):
	if thing != null: 
		#return sqrt(abs((int(self.get_position().x - thing.get_position().x)^2) + (int(self.get_position().y - thing.get_position().y)^2)))
		return self.get_global_transform().get_origin().distance_to(thing.get_global_transform().get_origin())

func waitDash(time):
	get_tree().create_timer(time).connect("timeout", self, "dash")

func waitAOE(time):
	get_tree().create_timer(time).connect("timeout", self, "AOE")

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
