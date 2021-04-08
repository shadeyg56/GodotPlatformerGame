extends Area2D

onready var Player = $"../../Player"

func _ready():
	get_parent().move = null
	get_parent().ball_shot = false


func _on_Goo_body_entered(body):
	if body.name == "Player":
		body.speed /= 1.5


func _on_DespawnTimer_timeout():
	Player.speed = 200
	queue_free()


func _on_Goo_body_exited(body):
	if body.name == "Player":
		body.speed = 200
