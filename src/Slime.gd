extends KinematicBody2D

var move = false
var velocity = Vector2()
var collision
var gravity = 500
var jump_speed = -400
var prevX = 0
onready var Player = $"../../Player"
onready var sprite = $AnimatedSprite

func _ready():
	pass

func _physics_process(delta):
	if is_on_floor():
		velocity.x = 0
	else:
		if velocity.x > 1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	if move:
		
		#velocity = Player.position - position
		if is_on_floor():
			velocity = global_position.direction_to(Player.global_position) * 100
			velocity.y = jump_speed
			move = false
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2(0, -1))
	check_player_collision()
	
	
		
func check_player_collision():
	for i in get_slide_count():
		collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			get_tree().reload_current_scene()

	
	

func _on_Detection_body_entered(body):
	if body.name == "Player":
		$MoveTimer.wait_time = 1
		$MoveTimer.start()


func _on_MoveTimer_timeout():
	$MoveTimer.wait_time = 3
	move = true


func _on_Detection_body_exited(body):
	if body.name == "Player":
		$MoveTimer.stop()
		


func _on_AnimatedSprite_animation_finished():
	move = true
	if is_on_floor():
		sprite.frame = 0
	
