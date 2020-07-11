extends Node2D


var life = .5


func _ready():
	get_tree().create_timer(life).connect("timeout", self, "dead")


func _process(delta):
	if (get_child_count() == 0):
		queue_free()


func _initialize(direction):
	for child in get_children():
		child._initialize(direction)


func dead():
	queue_free()
