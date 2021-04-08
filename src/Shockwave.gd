extends Area2D

var direction
export var speed = 50


func _ready():
	$Tween.interpolate_property(self, "scale:x", null, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
func _physics_process(delta):
	position += direction * speed * delta
