extends CanvasLayer

onready var CoinCount = $MarginContainer/VBoxContainer/HBoxContainer/Coins/CoinCount
var coins = 0
var coin_image

func _process(delta):
	$FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	$MarginContainer/VBoxContainer/HBoxContainer2/BatteryProgressBar.value = get_parent().battery_level
	
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
