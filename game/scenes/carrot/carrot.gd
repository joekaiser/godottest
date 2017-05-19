extends Node2D

export var special = false
var sfx
var owner
var taken=false;

var player_class = preload("res://scenes/super_bunny/super_bunny.gd")

func _ready():
	#todo: make sure the owner is a level_root
	if get_owner() != null:
		owner = get_owner()
		
		get_node("Area2D").connect("body_enter", self, "_collect_carrot")
		sfx = get_node("sfx")
		if special:
			get_node("AnimatedSprite").play("special")
	
func _collect_carrot(body):
	if body && body extends player_class:
		if taken:
			return
		taken = true
		if special:
			owner.score +=50
			owner.get_player().health +=1
			sfx.play("carrot_powerup")
		else:
			owner.score += 20
			sfx.play("collect_carrot")
		
		#remove the node
		get_node("anim").play("collect")
	
