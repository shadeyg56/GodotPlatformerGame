extends Node

onready var Coin = preload("res://src/coin.tscn")
onready var Spider = preload("res://src/Spider.tscn")
onready var Bat = preload("res://src/Bat.tscn")
var total_coins = {1: 3, 2:6}
var coins_grabbed = 0
export var current_level = globals.current_level
var mob

func _ready():
	spawn_coins()
	spawn_enemies()

func spawn_coins():
	var points = $CoinSpawns.curve.get_point_count()
	print(points)
	var point = 0
	while point <= points - 1:
		var pos = $CoinSpawns.curve.get_point_position(point)
		var coin = Coin.instance()
		add_child(coin)
		coin.position = pos
		coin.connect("coin_grabbed", self, "on_coin_grabbed")
		point += 1
		
func spawn_enemies():
	var paths = []
	for node in get_children():
		if node is Path2D:
			if node.name != "CoinSpawns":
				paths.append(node)
	for path in paths:
		if "Spider" in path.name:
			mob = Spider.instance()
			mob.path = path.get_node("PathFollow2D")
		elif "Bat" in path.name:
			mob = Bat.instance()
			mob.get_node("Bat").path = path.get_node("PathFollow2D")
		else:
			mob = null
		if mob != null:
			
			add_child(mob)
			

func on_coin_grabbed():
	coins_grabbed += 1
	if coins_grabbed == total_coins[current_level]:
		globals.load_next_level()

