extends Control


func _ready():
	# James, change thiss part sa spawning.
	var player = preload("res://scenes/entities/player.tscn").instantiate()
	var area = size
	add_child(player)
	var children = get_children()
	
	# DON'T CHANGE THIS PART
	for child in children:
		if child.has_signal("gameover"):
			child.gameover.connect(_on_gameover_signal)

func _on_gameover_signal(player):
	player.queue_free()
