extends Area2D

onready var tween = $Tween
onready var sprite = $AnimatedSprite
var start_position

func _ready():
	start_position = position

func _physics_process(delta):
	pass

func _on_Detection_body_entered(body):
	if body.name == "Player":
		if !tween.is_active():
			if position != start_position + Vector2(0, -100):
				tween.interpolate_property(self, "position", null, position + Vector2(0, -100), 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.start()
				sprite.play()

func _on_Detection_body_exited(body):
	if body.name == "Player":
		if !tween.is_active():
			if position != start_position:
				tween.interpolate_property(self, "position", null, position + Vector2(0, 100), 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.start()
				sprite.play()


func _on_Snake_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()


func _on_Tween_tween_completed(object, key):
	sprite.stop()
