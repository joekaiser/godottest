extends Node

#config
export(NodePath) var player_class
export var death_at_Y = 100000

#state
var score = 0 setget set_score,get_score
var last_score = 0
var last_health = 0
var last_timer=0
var time_warning_given = false

#nodes
var player
onready var timer = get_node("Timer")
onready var time_text = get_node("gui").get_node("lbl_time")
onready var score_text = get_node("gui").get_node("lbl_score")
onready var health_text = get_node("gui").get_node("lbl_health")
onready var sfx = get_node("sfx_global")
onready var anim = get_node("AnimationPlayer")

func _ready():
	set_fixed_process(true)
	player = get_node(player_class)
	timer.connect("timeout",self,"on_timer_done")
	
func _fixed_process(delta):
	pass_time()
	print_helath()	
	print_score()
	do_player_bounds_check()
		
func print_helath():
	if last_health != player.get_health():
		last_health = player.get_health()
		health_text.set_text(str(last_health))	
	
func print_score():
	if last_score != score:
		score_text.set_text(str(score))
		last_score = score;
	
func pass_time():
	if timer:
		if last_timer!=timer.get_time_left():
			last_timer = timer.get_time_left()
			var timerInt = int(last_timer)
			if timerInt  <20 and !time_warning_given:
				anim.play("time_low")
				sfx.play("time_low")
				time_warning_given=true
			time_text.set_text(str(timerInt))
	
func do_player_bounds_check():
	if player.get_pos().y > death_at_Y:
		player.kill()
		
func level_complete():
  	self.add_child(Gamestate.get_level_complete_scene())

func on_timer_done():
	Logger.info("timer finished. implement gui")
	player.kill()
	
func get_score():
	return score

func set_score(value):
	score=value	
	
func get_player():
	return player