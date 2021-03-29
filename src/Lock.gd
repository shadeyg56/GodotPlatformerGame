extends StaticBody2D

onready var area = $Area2D/CollisionShape2D
onready var collision = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_got_key():
	area.set_deferred("disabled", false)
	collision.set_deferred("disabled", true)
	print("here")


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		queue_free()
