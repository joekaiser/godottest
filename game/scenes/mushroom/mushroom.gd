extends StaticBody2D

export var power = 1.8
var sfx 
onready var rc_l = get_node("raycast_left")
onready var rc_r = get_node("raycast_right")


func _ready():
	set_fixed_process(true)
	sfx = get_node("sfx")
	
func _fixed_process(delta):
	var target = null
	if rc_l.is_colliding():
		target = rc_l.get_collider()
	elif rc_r.is_colliding():
		target = rc_r.get_collider()
	
	if target && target.has_method("bounce"):
			target.bounce(power)
			sfx.play("launch")
