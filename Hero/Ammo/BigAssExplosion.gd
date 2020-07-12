extends Node2D


# How long the shotgun blast should live
var life = 10


func _ready():
	# Kill the shotgun after a certain amount of time
	get_node("AudioStreamPlayer2D").connect("finished", self, "dead")


# Passing the direction down to the projectiles
func initialize(direction):
	for child in get_children():
		if (child.has_method("initialize")):
			child.initialize(direction)


# Runs when the ammo is out of life
func dead():
	queue_free()