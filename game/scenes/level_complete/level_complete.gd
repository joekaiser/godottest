extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Gamestate.next_level()

