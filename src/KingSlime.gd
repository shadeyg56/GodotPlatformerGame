extends KinematicBody2D

var move
var velocity = Vector2()
var collision
var gravity = 500
var jump_speed = -400
var health = 300
var prevX = 0
onready var Player = $"../Player"
onready var sprite = $Sprite
onready var Shockwave = preload("res://src/Shockwave.tscn")
onready var Slimeball = preload("res://src/Slimeball.tscn")
onready var Slimerain = preload("res://src/SlimeRain.tscn")
var chance
var in_air = false
var attacked = false
var can_hit = true

signal player_hit

func _ready():
	$"../HUD/BossHealth".visible = true

func _physics_process(delta):
	print(health)
	if is_on_floor():
		velocity.x = 0
	else:
		if velocity.x > 1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	if move == "moving":
		if is_on_floor():
			velocity = global_position.direction_to(Player.global_position) * 100
			velocity.y = jump_speed
			move = null
	elif move == "shock":
		if is_on_floor():
			velocity.y = jump_speed * 1.5
			if in_air:
				var shock_right = Shockwave.instance()
				var shock_left = Shockwave.instance()
				shock_left.direction = Vector2.LEFT
				shock_right.direction = Vector2.RIGHT
				shock_right.global_position = $ShockRight.position
				shock_left.global_position = $ShockLeft.position
				add_child(shock_left)
				add_child(shock_right)
				velocity.y = 0
				move = null
				in_air = false
			else:
				in_air = true
	elif move == "ball":
		if is_on_floor():
			if !attacked:
				var ball = Slimeball.instance()
				ball.global_position = $BallSpawn.position
				add_child(ball)
				attacked = true
	elif move == "rain":
		if is_on_floor():
			var rain = Slimerain.instance()
			rain.position.x = Player.position.x
			rain.position.y = 200
			get_parent().add_child(rain)
			move = null
	
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2(0, -1))
	if $MoveTimer.is_stopped() and !move:
		$MoveTimer.start()
	check_player_collision()
	
		
func check_player_collision():
	for i in get_slide_count():
		collision = get_slide_collision(i)
		if collision:
			if collision.collider.name == "Player":
				if can_hit:
					var damage = 10
					emit_signal("player_hit", damage)
					velocity.y = jump_speed
					Player.launch()
					can_hit = false
					yield(get_tree().create_timer(1), "timeout")
					can_hit = true
			


func _on_MoveTimer_timeout():
	attacked = false
	chance = randi() % 4 + 1
	if chance == 1:
		move = "moving"
	elif chance == 2:
		move = "rain"
	elif chance == 3:
		move = "ball"
	else:
		move = "shock"
	$MoveTimer.stop()
