extends Node

onready var Coin = preload("res://src/Coin.tscn")
onready var Spider = preload("res://src/Spider.tscn")
onready var Bat = preload("res://src/Bat.tscn")
onready var Bee = preload("res://src/Bee.tscn")
var Battery
var total_coins
var coins_grabbed = 0
var battery_level = 100
export var current_level = globals.current_level
var mob
export var use_cam = false
var end_ladder = false

signal ladder_unlocked

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$HUD/PauseMenu.visible = true

func _ready():
	spawn_coins()
	spawn_enemies()
	if $BatterySpawns:
		Battery = preload("res://src/Battery.tscn")
		spawn_batteries()
	if use_cam:
		$Player/Camera2D.current = true
	else:
		$Player/Camera2D.current = false
	for node in get_children():
		if "Key" in node.name:
			$HUD.get_node("MarginContainer/VBoxContainer/HBoxContainer/Keys/%s" % node.name).visible = true
		elif "EndLadder" in node.name:
			end_ladder = true

func spawn_coins():
	if $CoinSpawns:
		total_coins = $CoinSpawns.curve.get_point_count()
		var point = 0
		while point <= total_coins - 1:
			var pos = $CoinSpawns.curve.get_point_position(point)
			var coin = Coin.instance()
			add_child(coin)
			coin.position = pos 
			coin.connect("coin_grabbed", self, "on_coin_grabbed")
			coin.connect("coin_grabbed", $HUD, "on_coin_grabbed")
			point += 1
		
func spawn_batteries():
	var points = $BatterySpawns.curve.get_point_count()
	var point = 0
	while point <= points - 1:
		var pos = $BatterySpawns.curve.get_point_position(point)
		var battery = Battery.instance()
		add_child(battery)
		battery.position = pos
		battery.connect("battery_grabbed", self, "on_battery_grabbed")
		point += 1
		
func spawn_enemies():
	for node in get_children():
		if node is Path2D:
			if "Spider" in node.name:
				mob = Spider.instance()
				mob.path = node.get_node("PathFollow2D")
			elif "Bat" in node.name and node.name != "BatterySpawns":
				mob = Bat.instance()
				mob.get_node("Bat").path = node.get_node("PathFollow2D")
			elif "Bee" in node.name:
				mob = Bee.instance()
				mob.path = node.get_node("PathFollow2D")
			else:
				mob = null
			if mob != null:
				add_child(mob)
			

func on_coin_grabbed():
	coins_grabbed += 1
	if coins_grabbed == total_coins:
		if !end_ladder:
			globals.load_next_level()
		else:
			emit_signal("ladder_unlocked")
		
func on_battery_grabbed():
	battery_level = 100
	$Player/Thoughts.text = ""
	$HUD/MarginContainer/VBoxContainer/HBoxContainer2/BatteryProgressBar.texture_progress = load("res://assets/HUD/battery_green.png")

func _on_BatteryTimer_timeout():
	battery_level -= 10
	if battery_level == 0:
		var tween = $Player/Tween
		tween.interpolate_property($Player/Light2D, "energy", null, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	elif battery_level == 30:
		$HUD/MarginContainer/VBoxContainer/HBoxContainer2/BatteryProgressBar.texture_progress = load("res://assets/HUD/battery_red.png")
		$Player/Thoughts.text = "Low Battery!"
		$Player/Thoughts/Tween.interpolate_property($Player/Thoughts, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Player/Thoughts/Tween.start()
	elif battery_level == 50:
		$HUD/MarginContainer/VBoxContainer/HBoxContainer2/BatteryProgressBar.texture_progress = load("res://assets/HUD/battery_yellow.png")

func _on_Battery_tween_completed(object, key):
	get_tree().reload_current_scene()


func _on_Landed_body_entered(body):
	if body.name == "Player":
		if !globals.seen_flashlight:
			get_tree().paused = true
			$StartBox.visible = true
			$StartBox/ColorRect/CenterContainer/RichTextLabel/Tween.interpolate_property($StartBox/ColorRect/CenterContainer/RichTextLabel/, "percent_visible", null, 1, 10, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$StartBox/ColorRect/CenterContainer/RichTextLabel/Tween.start()
			globals.seen_flashlight = true


func _on_OkButton_pressed():
	$StartBox.visible = false
	get_tree().paused = false
