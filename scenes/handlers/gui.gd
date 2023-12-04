extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var game = preload("res://scenes/world/gameplay.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_packed(game)
