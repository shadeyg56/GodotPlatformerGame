extends KinematicBody2D

var velocity = Vector2()
var colliding
export var speed = 200

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	check_collision()
	velocity = Vector2()
	velocity.x = -speed
	if !colliding:
		rotation_degrees -= 90
	velocity = velocity.rotated(deg2rad(rotation_degrees))
	move_and_slide(velocity)
	
func check_collision():
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider().name != "Player":
		colliding = true
	else:
		colliding = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			get_tree().reload_current_scene()
		
