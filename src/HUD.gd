extends CanvasLayer

onready var CoinCount = $MarginContainer/VBoxContainer/HBoxContainer/Coins/CoinCount
onready var Player = $"../Player"
var coins = 0
var coin_image
var prev_health = 100

func _process(delta):
	$FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	$MarginContainer/VBoxContainer/Battery/BatteryProgressBar.value = get_parent().battery_level

func _ready():
	pass # Replace with function body.
	
func on_coin_grabbed():
	coins += 1
	coin_image = load("res://assets/HUD/hud_%s.png" % coins)
	CoinCount.texture = coin_image


func _on_Continue_pressed():
	$PauseMenu.visible = false
	get_tree().paused = false


func _on_Quit_pressed():
	get_tree().change_scene("res://src/MainMenu.tscn")
	get_tree().paused = false
	
func _on_player_hit(damage):
	$MarginContainer/VBoxContainer/Health/HealthBar/Tween.interpolate_property($MarginContainer/VBoxContainer/Health/HealthBar, "value", null, Player.health, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MarginContainer/VBoxContainer/Health/HealthBar/Tween.start()

