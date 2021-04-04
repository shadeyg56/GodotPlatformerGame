extends Area2D


onready var tween = $Tween


func _ready():
	tween.interpolate_property(self, "rotation_degrees", null, 170, .7, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
