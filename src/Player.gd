extends KinematicBody2D

var velocity = Vector2()
export var speed = 200
export var gravity = 3000
export var jump_speed = -1000
var health = 100
onready var sprite = $AnimatedSprite
onready var camera = $Camera2D
var collision
var has_key = false
var on_ladder = false
var end_ladder = false
var lock_input = false
onready var screen_size = get_viewport_rect()
onready var tiles = $"../TileMap"
onready var set = tiles.tile_set

func input():
	velocity.x = 0
	if on_ladder:
		velocity.y = 0
	if Input.is_action_pressed("a"):
		sprite.flip_h = true
		velocity.x -= 1
		if $Sword.visible:
			$Sword.position.x = -11
			#$Sword/Sprite.flip_h = true
	if Input.is_action_pressed("d"):
		sprite.flip_h = false
		velocity.x += 1
		if $Sword.visible:
			if $Sword/Tween.is_active():
				$Sword/Tween.stop_all()
				$Sword.swing("right")
			$Sword.position.x = 11
			$Sword/Sprite.flip_h = false
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	if Input.is_action_pressed("s"):
		if on_ladder:
			velocity.y += 200
	if Input.is_action_pressed("w"):
		if on_ladder:
			velocity.y -= 200
	if Input.is_action_just_pressed("left_click"):
		$Sword.visible = true
		$Sword/CollisionPolygon2D.set_deferred("disabled", false)
		if !sprite.flip_h:
			$Sword.swing("right")
		else:
			$Sword.swing("left")
	velocity.x += velocity.x * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	camera.limit_bottom = screen_size.end.y
	camera.limit_top = screen_size.position.y
	camera.limit_left = screen_size.position.x


func _physics_process(delta):
	print(health)
	check_ladder()
	if globals.spring:
		jump_speed = -1300
	else:
		jump_speed = -1000
	if !lock_input:
		input()
	if velocity.length() > 0:
		sprite.animation = "walking"
	else:
		sprite.animation = "idle"
		#.frame = 0
	if !on_ladder:
		velocity.y += gravity * delta
	if end_ladder:
		velocity.y = 0
		velocity.y += 1 * 100
	velocity = move_and_slide(velocity, Vector2(0, -1))
	check_collision()
	#camera.position.x = clamp(camera.position.x, 0, screen_size.x)
	
func check_collision():
	for i in get_slide_count():
		collision = get_slide_collision(i)
		if collision.collider.name == "Slime":
			get_tree().reload_current_scene()
#		elif collision.collider is TileMap:
#			var tile = collision.collider.world_to_map(collision.collider.to_local(position))
#			#tile -= collision.normal
#			tile = collision.collider.get_cellv(tile)
#			if "Ladder" in collision.collider.tile_set.tile_get_name(tile):
#				on_ladder = true
#			else:
#				on_ladder = false
#		else:
#			on_ladder = false
			
func check_ladder():
	var tile = tiles.world_to_map(tiles.to_local(position))
	tile = tiles.get_cellv(tile)
	if tile != -1 and "Ladder" in set.tile_get_name(tile):
		on_ladder = true
	else:
		on_ladder = false
	
func launch():
	lock_input = true
	velocity.x = -500
	yield(get_tree().create_timer(0.5), "timeout")
	lock_input = false


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if end_ladder:
		globals.load_next_level()


func _on_player_hit(damage):
	health -= damage
	if health == 0:
		get_tree().reload_current_scene()
