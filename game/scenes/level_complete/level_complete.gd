extends CanvasLayer

onready var health_text = get_node("lbl_health")
onready var time_text = get_node("lbl_time")
onready var score_text = get_node("lbl_score")

var health
var time
var score

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)
	draw_ui()

func draw_ui():
	health_text.set_text(str(health) + " x 10")
	time_text.set_text(str(time) + " x 10")
	score_text.set_text(str(get_final_score()))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Gamestate.next_level()

func init(player_health, level_time, level_score):
	health = player_health
	time = int(level_time)
	score = level_score
	
func get_final_score():
	return (health*10) + (time * 10) + score
