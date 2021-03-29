extends Path2D

onready var coin = preload("res://coin.tscn")

func _ready():
	var points = curve.get_point_count()
	var point = 1
	while point <= points:
		var pos = curve.get_point_position(point)
		var new_coin = coin.instance()
		add_child(new_coin)
		new_coin.position = pos
		point += 1
