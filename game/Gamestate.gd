extends Node

var level_complete_screen = preload("res://scenes/level_complete/level_complete.tscn")

var player_lives=3
var player_score = 0

var current_scene
var current_scene_path
var level_index = 0;
var levels = StringArray()

func _ready():
	#Logger.set_default_output_level(Logger.VERBOSE)
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
	current_scene_path = "res://scenes/world/fantasy_world/level_1-1.tscn"
	init_level_queue()

	
func goto_scene(scene):
	current_scene_path = scene
	current_scene.queue_free()
	var s = load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	
func next_level():
	if level_index < levels.size():
		level_index +=1
	goto_scene(levels[level_index])
	
func reload_current_scene():
	current_scene.queue_free()
	var s = load(current_scene_path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)

func init_level_queue():
	Logger.verbose("filling level queue")
	levels.push_back("res://scenes/world/fantasy_world/level_1-1.tscn")

func get_level_complete_scene():
	return level_complete_screen.instance()
	