extends AudioStreamPlayer2D


# Sounds
var sound1 = load("res://Hero/Ammo/Sounds/S_shotgun_1.wav")
var sound2 = load("res://Hero/Ammo/Sounds/S_shotgun_2.wav")

var rand = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	if (randf() < 0.5):
		stream = sound1
	else:
		stream = sound2
