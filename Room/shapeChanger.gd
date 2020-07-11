extends StaticBody2D
var rand=RandomNumberGenerator.new()
export var ranges=10
func _ready():
	set_process(true)
onready var poly=$CollisionPolygon2D.get_polygon()
func _on_Timer_timeout():
	var a=$CollisionPolygon2D.get_polygon()
	for i in range(a.size()):
		a[i]+=Vector2(rand.randf_range(-ranges,ranges),rand.randf_range(-ranges,ranges))
	$CollisionPolygon2D.polygon=a
	poly=a
	update()
func _draw():
	draw_polyline(poly,Color.red,3.0,false)
