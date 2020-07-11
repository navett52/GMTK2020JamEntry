extends Node2D


# Register the main node to the Global Script G so we can add children to it easily.
func _ready():
	G.main_node = self
