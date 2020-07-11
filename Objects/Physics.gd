extends RigidBody2D
var rand=RandomNumberGenerator.new()
export var direction=0
func _ready():
	pass
func onTimeChanged():
	randomize()
	# Make a random vector
	var vel=Vector2(rand.randf_range(-100,100),rand.randf_range(-100,100))
	self.apply_impulse(self.position,vel*direction)
	#self.weight=rand.randi_range(-3,3)
	self.gravity_scale=rand.randf_range(-1,1)
	self.physics_material_override.bounce=rand.randf_range(0,12)
