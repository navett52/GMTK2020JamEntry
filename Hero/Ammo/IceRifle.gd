extends Node2D


# How long the shotgun blast should live
var life = 2


func _ready():
	# Kill the shotgun after a certain amount of time
	get_tree().create_timer(life).connect("timeout", self, "dead")


func _process(delta):
	# If all the children projectiles die before the shotgun, kill it
	if (get_child_count() == 0):
		queue_free()


# Passing the direction down to the projectiles
func initialize(direction):
	for child in get_children():
		if (child.has_method("initialize")):
			child.initialize(direction)


# Runs when the ammo is out of life
func dead():
	queue_free()
