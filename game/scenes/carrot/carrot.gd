extends Node2D

export var special = false
var sfx
var owner
var taken=false;

func _ready():
	#todo: make sure the owner is a level_root
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
		owner.score +=10
		sfx.play("carrot_powerup")
	else:
		owner.score += 1
		sfx.play("collect_carrot")
	
	#remove the node
	get_node("anim").play("collect")
	
