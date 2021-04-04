extends Area2D

signal battery_grabbed

func _ready():
	pass # Replace with function body.


func _on_Battery_body_entered(body):
	emit_signal("battery_grabbed")
	queue_free()
