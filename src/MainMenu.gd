extends CanvasLayer

onready var tween = $Tween
var imgs = ["Dino", "Spider", "Bee", "Bat"]

func _ready():
	for node in get_children():
		if node.name in imgs:
			tween.interpolate_property(node, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func _on_StartButton_pressed():
	var scene = load("res://src/Level1.tscn")
	get_tree().change_scene_to(scene)
