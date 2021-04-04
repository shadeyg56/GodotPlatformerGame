extends Node

onready var Coin = preload("res://src/coin.tscn")
onready var Spider = preload("res://src/Spider.tscn")
onready var Bat = preload("res://src/Bat.tscn")
onready var Bee = preload("res://src/Bee.tscn")
var Battery
var total_coins = {1: 3, 2: 6, 3: 5}
var coins_grabbed = 0
var battery_level = 100
export var current_level = globals.current_level
var mob
export var use_cam = false

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
	if not get_node("Key"):
		$HUD/MarginContainer/VBoxContainer/HBoxContainer/Key.visible = false

func spawn_coins():
	var points = $CoinSpawns.curve.get_point_count()
	var point = 0
	while point <= points - 1:
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
	if coins_grabbed == total_coins[current_level]:
		globals.load_next_level()
		
func on_battery_grabbed():
	battery_level = 100

func _on_BatteryTimer_timeout():
	battery_level -= 10
	if battery_level == 0:
		var tween = $Player/Tween
		tween.interpolate_property($Player/Light2D, "energy", null, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()


func _on_Battery_tween_completed(object, key):
	get_tree().reload_current_scene()
