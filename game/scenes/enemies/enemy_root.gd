extends RigidBody2D

const STATE_WALKING = 0
const STATE_DYING = 1

export var WALK_SPEED = 85
export var point_value=10

var state = STATE_WALKING
var direction = -1
var anim = ""
var next_anim = ""
var player_class = preload("res://scenes/super_bunny/super_bunny.gd")
var health = 1
var current_velocity = Vector2()
var isDead = false
var isActive = false

func _ready():
	pass
	
func state_dying(s):
	pass
	
func state_walking(s):
	pass
	
func die():
	queue_free()
	
func hurt(attacker):
	if canBeHurt():
		health -=1
		if attacker.has_method("bounce"):
			attacker.bounce(.8)
		if health <=0:
			state=STATE_DYING

func canBeHurt():
	return state != STATE_DYING

func _integrate_forces(s):
	if !isActive:
		return

	current_velocity = s.get_linear_velocity()
	#next_anim = anim

	if  state == STATE_DYING:
		state_dying(s)
	elif state == STATE_WALKING:
		state_walking(s)
		
	if anim != next_anim:
		anim = next_anim
		animateSprite(anim)

	s.set_linear_velocity(current_velocity)

func damagePlayer(node):
	if node extends player_class:
		node.hurt()
		
func animateSprite(anim):
	pass
	

	
