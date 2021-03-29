extends Area2D

var path
var pathidx
var speed = 1
var prevX = 0
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
var dead = false
var move = true

func _ready():
	pathidx = randi() % 10000
	pathidx = 0
	if "Bat" in name:
		move = false
	
func _process(delta):
	if not dead:
		if position.x > prevX:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		prevX = position.x
		if path != null:
			path.set_offset(pathidx)
			position = path.position
			if move:
				pathidx += speed
	#else:
		#var velocity = Vector2(0, 1)
		#position += velocity * speed

func _on_Mob_body_entered(body):
	if body.name == 'Player':
		#if body.position.y+10 < position.y:
			#collision.disabled = true
			#dead = true
			#sprite.animation = "death"
			
		#else:
		get_tree().reload_current_scene()


func _on_HangTimer_timeout():
	sprite.animation = "default"
	sprite.play()
	move = true
	path.get_parent().curve.remove_point(0)
	
