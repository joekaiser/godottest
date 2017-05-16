extends Node

export(NodePath) var player_class
export var death_at_Y = 100000

var score setget set_score,get_score
var last_score=0
var last_health = 0
var player

onready var score_text = get_node("gui").get_node("lbl_score")
onready var health_text = get_node("gui").get_node("lbl_health")

func _ready():
	set_fixed_process(true)
	player = get_node(player_class)
	score=0
	
func _fixed_process(delta):
	
	if last_health != player.get_health():
		last_health = player.get_health()
		health_text.set_text(str(last_health))
		
	
	if last_score != score:
		score_text.set_text(str(score))
		last_score = score;
		
	if player.get_pos().y > death_at_Y:
		player.kill()
		
func level_complete():
	Logger.warn("using the default level_complete")
	Gamestate.reload_current_scene()
	
func get_score():
	return score

func set_score(value):
	score=value	
	
func get_player():
	return player