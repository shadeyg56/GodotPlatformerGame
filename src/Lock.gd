extends StaticBody2D

onready var area = $Area2D/CollisionShape2D
onready var collision = $CollisionShape2D
export var color = "yellow"


func _ready():
	set_color()

func set_color():
	var img = load("res://assets/Items/lock_%s.png" % color)
	$Sprite.texture = img

func _on_got_key():
	area.set_deferred("disabled", false)
	collision.set_deferred("disabled", true)
	


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		queue_free()


func _on_Node_ladder_unlocked():
	queue_free()
