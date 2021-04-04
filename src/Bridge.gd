extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var degrees


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		for child in get_children():
			if "Bridge" in child.name:
				if child.name == "Bridge_Right":
					degrees = -90
				else:
					degrees = 90
				$Tween.interpolate_property(child.get_node("Sprite"), "rotation_degrees", null, degrees, 10, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		#$Tween.interpolate_property(self, "position", null, position + Vector2(22, 0), 10, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Tween.start()
		$BreakTimer.start()


func _on_BreakTimer_timeout():
	for child in get_children():
			if "Bridge" in child.name:
				child.get_node("CollisionShape2D").set_deferred("disabled", true)
