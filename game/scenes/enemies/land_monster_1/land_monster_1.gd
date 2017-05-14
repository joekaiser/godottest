extends RigidBody2D

const STATE_WALKING = 0
const STATE_DYING = 1
const WALK_SPEED = 75

var state = STATE_WALKING
var direction = -1
var anim = ""
var isActive = false
var player_class = preload("res://scenes/super_bunny/super_bunny.gd")
onready var sprite = get_node("sprite")
onready var enabler = get_node("enabler")
onready var rc_left = get_node("raycast_left")
onready var rc_right = get_node("raycast_right")

func _ready():
	enabler.connect("enter_screen",self,"on_enabler_enter")
	enabler.connect("exit_screen",self,"on_enabler_exit")
	
func on_enabler_enter(): 
	isActive = true

func on_enabler_exit(): 
	isActive = false


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var new_anim = anim

	if  state == STATE_DYING:
		new_anim = "dying"
	elif state == STATE_WALKING:
		new_anim = "walk"
		
		var wall_side = 0.0
		
		for i in range(s.get_contact_count()):
			var cc = s.get_contact_collider_object(i)
			var dp = s.get_contact_local_normal(i)
			
			if cc:
				
				if (cc extends player_class):
					cc.hurt()
			#		set_mode(MODE_RIGID)
			#		state = STATE_DYING
			#		#lv = s.get_contact_local_normal(i)*400
			#		s.set_angular_velocity(sign(dp.x)*33.0)
			#		set_friction(1)
			#		cc.disable()
			#		get_node("sound").play("hit")
			#		break
			
			if dp.x > 0.9:
				wall_side = 1.0
			elif dp.x < -0.9:
				wall_side = -1.0
		
		if wall_side != 0 and wall_side != direction:
			direction = -direction
			sprite.set_flip_h(direction==-1)
		if direction < 0 and not rc_left.is_colliding() and rc_right.is_colliding():
			direction = -direction
			sprite.set_flip_h(true)
		elif direction > 0 and not rc_right.is_colliding() and rc_left.is_colliding():
			direction = -direction
			sprite.set_flip_h(true)
		
		lv.x = direction*WALK_SPEED
	
	if anim != new_anim:
		anim = new_anim
		sprite.play(anim)
	lv.x=direction*WALK_SPEED

	s.set_linear_velocity(lv)



