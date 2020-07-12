extends AudioStreamPlayer2D


func _ready():
	var resolution = Vector2( ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height") )
	global_position = Vector2(resolution.x / 2, resolution.y / 2)
