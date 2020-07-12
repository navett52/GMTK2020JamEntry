extends Node2D


var rand=RandomNumberGenerator.new()


func _ready():
	G.main_node=self


func onTimeChange():
	randomize()
	Engine.time_scale=rand.randf_range(0.0,3.0)
	$Time.wait_time=rand.randi_range(1,4)
