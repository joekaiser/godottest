extends Node

export var score = 0;
var last_score=0;
var score_text

func _ready():
	set_fixed_process(true)
	score_text=get_node("gui").get_node("lbl_score")
	
func _fixed_process(delta):
	if last_score != score:
		score_text.set_text(str(score))
		last_score = score;