extends Node

export var current_level = 1
var levels = {1: "Level1.tscn", 2: "Level2.tscn", 3: "Level3.tscn"}
var level
var spring = false
var seen_flashlight = false

func _ready():
	pass


func load_next_level():
	current_level += 1
	level = levels[current_level]
	level = load("res://src/%s" % level)
	get_tree().change_scene_to(level)
