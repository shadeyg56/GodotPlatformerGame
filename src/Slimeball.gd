extends KinematicBody2D

onready var Player = $"../../Player"
const gravity = 800
const height = -500
var velocity = Vector2()
onready var Goo = preload("res://src/SlimeGoo.tscn")

func _ready():
	velocity.x = (global_position.direction_to(Player.global_position)).x * global_position.distance_to(Player.global_position)
	velocity.y = height
	
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)
	check_collision()
	
func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var new_goo = Goo.instance()
			new_goo.position = position
			get_parent().add_child(new_goo)
			queue_free()
