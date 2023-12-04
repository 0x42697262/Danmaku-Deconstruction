extends Control


func _ready():
	# James, change thiss part sa spawning.
	var player = preload("res://scenes/entities/player.tscn").instantiate()
	var gameplay = get_node('hud/game_action_container/play_area_container')
	var area = gameplay.size
	player.position = Vector2(randi_range(0, area.x), area.y - 14)
	gameplay.add_child(player)
