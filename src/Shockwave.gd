extends Area2D

var direction
export var speed = 50


func _ready():
	pass
	
func _physics_process(delta):
	position += direction * speed * delta
	pass
