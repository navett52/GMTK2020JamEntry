extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func hit():
	print("hit")

func _on_Enemy_area_entered(area):
	print("area")
	if area!=null and area.get_parent().has_method("hit"):
		area.get_parent().hit()

func _on_Timer_timeout():
	$CollisionShape2D.disabled=not $CollisionShape2D.disabled
