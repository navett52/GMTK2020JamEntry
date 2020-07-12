extends Node2D


# How long the shotgun blast should live
var life = .5


func _ready():
	get_node("AudioStreamPlayer2D").connect("finished", self, "kill_gun")
	# Kill the shotgun after a certain amount of time
	get_tree().create_timer(life).connect("timeout", self, "kill_bullets")


# Passing the direction down to the projectiles
func initialize(direction):
	for child in get_children():
		if (child.has_method("initialize")):
			child.initialize(direction)


func kill_gun():
	queue_free()


# Runs when the ammo is out of life
func kill_bullets():
	for child in get_children():
		if child.name != "AudioStreamPlayer2D":
			queue_free()
