extends "res://scenes/enemies/enemy_root.gd"

onready var sprite = get_node("sprite")
onready var enabler = get_node("enabler")
onready var rc_left = get_node("raycast_left")
onready var rc_right = get_node("raycast_right")
onready var rc_back =get_node("raycast_back")
onready var anim_player = get_node("anim")
onready var sfx = get_node("sfx")

func _ready():
	enabler.connect("enter_screen",self,"on_enabler_enter")
	#enabler.connect("exit_screen",self,"on_enabler_exit")	

func on_enabler_enter(): 
	isActive = true

func state_walking(s):
	next_anim = "walk"

	var wall_side = 0.0		
	for i in range(s.get_contact_count()):
		var cc = s.get_contact_collider_object(i)
		var dp = s.get_contact_local_normal(i)
		
		if cc:
			damagePlayer(cc)
		
		if dp.x > 0.9:
			wall_side = 1.0
		elif dp.x < -0.9:
			wall_side = -1.0
	
	if wall_side != 0 and wall_side != direction:
		direction = -direction
		sprite.set_flip_h(direction==-1)
	if rc_back.is_colliding():
		damagePlayer(rc_back.get_collider())
	if direction < 0 and not rc_left.is_colliding() and rc_right.is_colliding():
		direction = -direction
		sprite.set_flip_h(direction==-1)
	elif direction > 0 and not rc_right.is_colliding() and rc_left.is_colliding():
		direction = -direction
		sprite.set_flip_h(direction==-1)

	current_velocity.x=direction*WALK_SPEED
	
func state_dying(s):
	if !isDead:
		isDead = true
		sfx.play("general_hurt_2")
		anim_player.stop_all()
		anim_player.play("death")
		next_anim = "dying"
		current_velocity = Vector2()
	
func animateSprite(a):
	sprite.play(a)



