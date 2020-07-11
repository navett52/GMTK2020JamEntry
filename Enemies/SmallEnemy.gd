extends KinematicBody2D

onready var player = get_parent().get_node("Hero")
var speed = 175
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	#if the player is in line of sight
	if(is_in_line_of_sight(player)):
		#add the direction of the player to enemy velocity
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
	#normalizes the velocity vector, and then sets it to the declared speed
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)

#checks to see if our enemy has line of sight with the player
#Pulled this from the internet, not entirely sure how it works lol
func is_in_line_of_sight(thing):
	var space = get_world_2d().direct_space_state
	if thing != null:
		var line_of_sight_obstacle = space.intersect_ray(global_position, 
				thing.global_position, [self], collision_mask)
		
		if line_of_sight_obstacle.collider == thing:
			return true
		else:
			return false
