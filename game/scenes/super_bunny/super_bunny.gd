extends KinematicBody2D

export var limit_left=0
export var limit_right = 100000
export var limit_up = -100000
export var limit_down = 100000
export var die_at_Y=100000


const MAX_SPEED=10
const WALK_SPEED = 350
const GRAVITY = 2500;
const JUMP_FORCE = 800;
const TERMINAL_VELOCITY = 20
const MAX_JUMPS = 2

var velocity = Vector2()
var sprite
var sfx
var jump_count=0
var airborn_time=0

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	sprite = get_node("AnimatedSprite")
	sprite.play("idle")
	sfx = get_node("sfx")
	
func play_animation(name):
	sprite.set_animation(name);
	
func _input(event):
	if event.is_action_pressed("ui_accept") and jump_count < MAX_JUMPS:
		jump()

func _fixed_process(delta):
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var floor_velocity = Vector2()
	var found_floor=false
	velocity.y += delta * GRAVITY

	if move_left:
		velocity.x = -WALK_SPEED
		sprite.set_flip_h(true)
		play_animation("walk")
	elif move_right:
		velocity.x = WALK_SPEED
		sprite.set_flip_h(false)
		play_animation("walk")
	else:
		velocity.x = 0
		play_animation("idle")
	
	var motion = velocity * delta
	if(motion.y>TERMINAL_VELOCITY):
		motion.y=TERMINAL_VELOCITY
	
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)

		if(n == Vector2(0,-1)):
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
		play_animation("falling")
		
	
	constrain_pos()



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