extends Area2D

signal got_key
var key_obtained
export var color = "yellow"

func _ready():
	set_color()

func set_color():
	var img = load("res://assets/Items/key%s.png" % color.capitalize())
	$Sprite.texture = img
	key_obtained = load("res://assets/HUD/hud_key%s.png" % color.capitalize())
	
func _on_Key_body_entered(body):
	if body.name == "Player":
		body.has_key = true
		emit_signal("got_key")
		.get_node("../HUD/MarginContainer/VBoxContainer/HBoxContainer/Keys/%s" % name).texture = key_obtained
		queue_free()
