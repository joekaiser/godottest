extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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
	set_process(true)
	set_fixed_process(true)
	sprite = get_node("AnimatedSprite")
	sprite.play("idle")
	sfx = get_node("sfx")
	
func play_animation(name):
	sprite.set_animation(name);
	
func _input(event):
	if event.is_action_pressed("ui_accept") and jump_count < MAX_JUMPS:
		jump()

func _process(delta):
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")

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
		move(motion)
		
		if(n == Vector2(0,-1)):
			found_floor = true
			jump_count = 0
	
	if found_floor:
		airborn_time = 0
	else:
		airborn_time += delta;
		
	if airborn_time > .1: ##not falling
		play_animation("falling")


func jump():
	velocity.y=-JUMP_FORCE
	jump_count += 1
	var i = randi()%3+1
	sfx.play("jump"+str(i))