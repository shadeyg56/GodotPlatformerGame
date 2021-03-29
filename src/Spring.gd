extends Area2D

onready var sprite = $Sprite
onready var spring_up = sprite.texture
var spring_down = preload("res://assets/platformerGraphicsDeluxe_Updated/Items/springboardDown.png")
onready var globals = $"/root/globals"

func _ready():
	pass # Replace with function body.
	

func _process(delta):
	if globals.spring:
		if Input.is_action_just_pressed("jump"):
			sprite.texture = spring_down
	else:
		sprite.texture = spring_up


func _on_Spring_body_entered(body):
	if body.name == "Player":
		globals.spring = true


func _on_Spring_body_exited(body):
	if body.name == "Player":
		globals.spring = false
