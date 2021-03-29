extends Area2D

signal got_key

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Key_body_entered(body):
	if body.name == "Player":
		body.has_key = true
		emit_signal("got_key")
		queue_free()
