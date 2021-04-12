extends Area2D


onready var tween = $Tween
var degrees


func _ready():
	pass

func swing(direction):
	if direction == "right":
		degrees = 170
	elif direction == "left":
		degrees = -170
	tween.interpolate_property(self, "rotation_degrees", abs(rotation_degrees), degrees, abs((degrees - rotation_degrees)/340.0), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	$CollisionPolygon2D.set_deferred("disabled", true)
	visible = false
	rotation_degrees = 0


func _on_Sword_body_entered(body):
	if "health" in body:
		print(body.name)
