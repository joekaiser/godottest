extends Node2D

var sfx
var owner
var taken=false;

func _ready():
	#todo: make sure the owner is a level_root
	if get_owner() != null:
		owner = get_owner()
		
		get_node("Area2D").connect("body_enter", self, "_collect_star")
		sfx = get_node("sfx")
	
func _collect_star(body):
	if taken:
		return
	taken = true
	sfx.play("collect")

	get_node("anim").play("collect")
	
func trigger_complete():
	if owner.has_method("level_complete"):
		owner.level_complete()
	else:
		Logger.error("no level_complete on " + owner.get_name())
	
	
