extends KinematicBody2D

const GRAVITY = 500
var velocity = Vector2()
var times = 1
var orig_pos

func _ready():
	orig_pos = position

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	move_and_slide(velocity)
	check_collision()
	
func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			visible = false
			if times < 3:
				visible = true
				velocity.y = 0
				position.x = $"../Player".position.x
				position.y = 200
				times += 1
			else:
				queue_free()
