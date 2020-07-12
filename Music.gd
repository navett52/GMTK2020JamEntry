extends AudioStreamPlayer2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_parent().get_node("Hero").global_position
