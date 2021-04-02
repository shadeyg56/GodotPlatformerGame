extends Area2D

onready var Player = $"../Player"
var velocity = Vector2()

func _ready():
	velocity = global_position.direction_to(Player.position) * 200
	look_at(Player.position)
	
func _physics_process(delta):
	
	global_position += velocity * delta



func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Stinger_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
