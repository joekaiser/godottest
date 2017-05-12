extends StaticBody2D

export var power = 1.8
var sfx 
var detector

func _ready():
	set_fixed_process(true)
	sfx = get_node("sfx")
	detector = get_node("RayCast2D")
	
func _fixed_process(delta):
	if detector.is_colliding():
		#print(detector.get_collider().get_name())
		var collider = detector.get_collider()
		collider.bounce(power)
		sfx.play("launch")
