extends KinematicBody2D

var velocity = Vector2()
export var speed = 200
export var gravity = 3000
export var jump_speed = -1000
onready var sprite = $AnimatedSprite
onready var camera = $Camera2D
var collision
var has_key = false
onready var screen_size = get_viewport_rect()

func input():
	velocity.x = 0
	if Input.is_action_pressed("a"):
		sprite.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("d"):
		sprite.flip_h = false
		velocity.x += 1
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	velocity.x += velocity.x * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	camera.limit_bottom = screen_size.end.y
	camera.limit_top = screen_size.position.y
	camera.limit_left = screen_size.position.x


func _physics_process(delta):
	if globals.spring:
		jump_speed = -1300
	else:
		jump_speed = -1000
	input()
	if velocity.length() > 0:
		sprite.animation = "walking"
	else:
		sprite.animation = "idle"
		#.frame = 0
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	check_collision()
	#camera.position.x = clamp(camera.position.x, 0, screen_size.x)
	
func check_collision():
	for i in get_slide_count():
		collision = get_slide_collision(i)
		if collision.collider.name == "Slime":
			get_tree().reload_current_scene()
	


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	camera.current = true


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	camera.current = false
