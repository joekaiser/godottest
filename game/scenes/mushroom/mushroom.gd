extends StaticBody2D

export var power = 1.8
var sfx 
var detector
var player_class = preload("res://scenes/super_bunny/super_bunny.gd")

func _ready():
	set_fixed_process(true)
	sfx = get_node("sfx")
	detector = get_node("RayCast2D")
	
func _fixed_process(delta):
	if detector.is_colliding():
		#print(detector.get_collider().get_name())
		var collider = detector.get_collider()
		if collider extends player_class:
			collider.bounce(power)
			sfx.play("launch")
