extends Node2D

export var special = false
var sfx
var owner
var taken=false;

func _ready():
	if get_owner() != null:
		owner = get_owner()
		get_node("Area2D").connect("body_enter", self, "_collect_carrot")
		sfx = get_node("sfx")
		if special:
			get_node("AnimatedSprite").play("special")
	
func _collect_carrot(body):
	if taken:
		return
	taken = true
	if special:
		sfx.play("carrot_powerup")
	else:
		sfx.play("collect_carrot")
	
	#remove the node
	get_node("anim").play("collect")
	
