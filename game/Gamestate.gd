extends Node

var player_lives=3
var player_score = 0

var current_scene
var current_scene_path

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
	current_scene_path = "res://scenes/world/fantasy_world/level_1-1.tscn"
	
func goto_scene(scene):
	current_scene_path = scene
	current_scene.queue_free()
	var s = load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	
func reload_current_scene():

	current_scene.queue_free()
	var s = load(current_scene_path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)