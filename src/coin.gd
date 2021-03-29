extends Area2D

signal coin_grabbed

func _ready():
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("coin_grabbed")
		queue_free()
