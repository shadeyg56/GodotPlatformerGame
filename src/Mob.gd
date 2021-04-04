extends Area2D

var path
var pathidx
var speed = 1
var prevX = 0
onready var sprite = $AnimatedSprite
onready var collision = $Collision
onready var tween = $Tween
var dead = false
var move = true
var spawn
export var state = "moving"
var curve
var stinger


func _ready():
	pathidx = 0
	if "Bat" in name:
		spawn = path.get_parent().get_node("Position2D")
		position = spawn.position
		$"../Detection/CollisionShape2D".position = position
		if state == "moving":
			$HangTimer.start()
			state = "hanging"
	if "Bee" in name:
		stinger = load("res://src/Stinger.tscn")
	
func _process(delta):
	if not dead:
		#if state == hanging:
		if position.x > prevX:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		prevX = position.x
		if path != null:
			path.set_offset(pathidx)
			if state == "moving":
				position = path.position
				pathidx += speed
			elif state == "return to path":
				tween.interpolate_property(self, "position", position, path.get_parent().curve.get_point_position(0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
				tween.start()
			elif state == "return to hang":
				tween.interpolate_property(self, "position", position, spawn.position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
				tween.start()
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
	tween.interpolate_property(self, "position", position, path.get_parent().curve.get_point_position(0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func _on_Detection_body_entered(body):
	if body.name == "Player":
		if "Bat" in name:
			sprite.animation = "default"
			sprite.play()
			state = "return to path"
			pathidx = 0
			tween.stop_all()
		elif "Bee" in name:
			var new_stinger = stinger.instance()
			new_stinger.global_position = $StingerSpawn.global_position
			get_parent().add_child(new_stinger)
			$StingTimer.start()


func _on_Tween_tween_completed(object, key):
	if position == path.get_parent().curve.get_point_position(0):
		state = "moving"
	elif position == spawn.position:
		state = "hanging"
		sprite.animation = "hang"


func _on_Detection_body_exited(body):
	if body.name == "Player":
		if "Bat" in name:
			tween.stop_all()
			state = "return to hang"
		elif "Bee" in name:
			$StingTimer.stop()


func _on_StingTimer_timeout():
	var new_stinger = stinger.instance()
	new_stinger.global_position = $StingerSpawn.global_position
	get_parent().add_child(new_stinger)
	
