extends CanvasLayer


func _ready():
	var gun = get_parent().get_node("Gun")
	gun.icon = get_node("MarginContainer/TextureRect")
	gun.ammo_count_label = get_node("Label")
