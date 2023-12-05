extends Node2D

@export var player_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in game_manager.Players:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		
		current_player.global_position = Vector2(randf_range(190,220), 0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
