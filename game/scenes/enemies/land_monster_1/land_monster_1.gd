extends RigidBody2D

const STATE_WALKING = 0
const STATE_DYING = 1
const WALK_SPEED = 85

var state = STATE_WALKING
var direction = -1
var anim = ""
var isActive = false
var player_class = preload("res://scenes/super_bunny/super_bunny.gd")
onready var sprite = get_node("sprite")
onready var enabler = get_node("enabler")
onready var rc_left = get_node("raycast_left")
onready var rc_right = get_node("raycast_right")
onready var rc_back =get_node("raycast_back")

func _ready():
	enabler.connect("enter_screen",self,"on_enabler_enter")
	enabler.connect("exit_screen",self,"on_enabler_exit")
	
func on_enabler_enter(): 
	isActive = true

func on_enabler_exit(): 
	#isActive = false
	pass
	
func die():
	print ('death')
	queue_free()

func _integrate_forces(s):
	if !isActive:
		return
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
		if rc_back.is_colliding() && rc_back.get_collider() extends player_class:
			rc_back.get_collider().hurt()
		#if direction < 0 and not rc_left.is_colliding() and rc_right.is_colliding():
			#direction = -direction
			#sprite.set_flip_h(direction==-1)
		#elif direction > 0 and not rc_right.is_colliding() and rc_left.is_colliding():
			#direction = -direction
			#sprite.set_flip_h(direction==-1)
		
		lv.x = direction*WALK_SPEED
	
	if anim != new_anim:
		anim = new_anim
		sprite.play(anim)
	lv.x=direction*WALK_SPEED

	s.set_linear_velocity(lv)
	if get_pos().y>2500:
		die()




