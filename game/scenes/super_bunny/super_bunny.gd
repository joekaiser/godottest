extends KinematicBody2D

export var limit_left=0
export var limit_right = 100000
export var limit_up = -100000
export var limit_down = 100000

const WALK_SPEED = 350
const GRAVITY = 2500;
const JUMP_FORCE = 800;
const TERMINAL_VELOCITY = 20
const MAX_JUMPS = 2

const IDLE_STATE=0
const WALKING_STATE=1
const DYING_STATE=2

onready var sprite = get_node("AnimatedSprite")
onready var sfx = get_node("sfx")
onready var anim = get_node("animation")
onready var rc_dl = get_node("raycast_downleft")
onready var rc_dr = get_node("raycast_downright")
onready var enemy = preload("res://scenes/enemies/enemy_root.gd")

var velocity = Vector2()
var jump_count=0
var airborn_time=0
var is_dead = false
var last_damage_at=0
var health setget set_health,get_health

var is_moving_left
var is_moving_right

var previous_state
var current_state
var next_state

var current_anim
var next_anim

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	current_state = IDLE_STATE
	health = 3
	
func do_idle_state(delta):
	velocity.x=0
	next_anim="idle"

func do_walking_state(delta):
	if !get_is_dead():
		next_anim="walk"
		
		if is_moving_left:
			velocity.x = -WALK_SPEED
			sprite.set_flip_h(true)
		elif is_moving_right:
			velocity.x = WALK_SPEED
			sprite.set_flip_h(false)

func do_dying_state(delta):
	if is_dead:
		return
	is_dead = true
	anim.stop_all()
	anim.play("death")
	sfx.play("player_death")	
	next_anim="dying"

func _input(event):
	if Input.is_action_pressed("ui_left"):
		is_moving_left = true
		is_moving_right = false
		next_state = WALKING_STATE
	elif Input.is_action_pressed("ui_right"):
		is_moving_left = false
		is_moving_right = true
		next_state = WALKING_STATE
	else:
		is_moving_left = false
		is_moving_right = false
		next_state = IDLE_STATE
		
	if event.is_action_pressed("ui_accept") and jump_count < MAX_JUMPS:
		jump()

func damage_enemies(delta):
	var enemy_target = null
	if rc_dl.is_colliding():
		enemy_target = rc_dl.get_collider()
	elif rc_dr.is_colliding():
		enemy_target = rc_dr.get_collider()
	if enemy_target && enemy_target extends enemy:
		enemy_target.hurt(self)

func _fixed_process(delta):
	previous_state = current_state
	current_state = next_state	
	
	if current_state == WALKING_STATE:
		do_walking_state(delta)
	elif current_state == DYING_STATE:
		do_dying_state(delta)
	else:
		do_idle_state(delta)
		
	damage_enemies(delta)
	
	if health == 0:
		next_state = DYING_STATE
	
	velocity.y += delta * GRAVITY
	
	var motion = velocity * delta
	if motion.y>TERMINAL_VELOCITY:
		motion.y=TERMINAL_VELOCITY
	
	motion = move(motion)
	
	var found_floor=false
	if is_colliding():
		var floor_velocity = Vector2()
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		
		if n == Vector2(0,-1):
			found_floor = true
			floor_velocity = get_collider_velocity()
			jump_count = 0
			
		if floor_velocity != Vector2():
			motion += floor_velocity * delta

		move(motion)
	
	if found_floor:
		airborn_time = 0
	else:
		airborn_time += delta;
		
	if airborn_time > .1: 
		next_anim = "falling"
		
	if current_anim != next_anim:
		current_anim = next_anim
		sprite.play(current_anim)
	
	constrain_pos()

func bounce(power):
	velocity.y=-JUMP_FORCE*power

func jump():
	velocity.y=-JUMP_FORCE
	jump_count += 1
	var i = randi()%3+1
	sfx.play("jump"+str(i))
	
func constrain_pos():
	var pos = get_pos()
	if pos.x < limit_left:
		pos.x = limit_left
		set_pos(pos)
	if pos.x > limit_right:
		pos.x = limit_right
		set_pos(pos)
	if pos.y < limit_up:
		pos.y = limit_up
		set_pos(pos)
	if pos.y > limit_down:
		pos.y = limit_down
		set_pos(pos)
	
		
func die():
	queue_free()
	Gamestate.reload_current_scene()
	
func get_is_dead():
	return is_dead
	
func hurt():
	if can_be_hurt():
		health -=1
		last_damage_at = OS.get_ticks_msec()
		sfx.play("player_hurt")
		anim.play("hurt")
	
func can_be_hurt():
	if is_dead:
		return false
	var ellapsed = OS.get_ticks_msec() - last_damage_at
	return  ellapsed > 1250
	
func get_health():
	return health

func set_health(value):
	health=value
	