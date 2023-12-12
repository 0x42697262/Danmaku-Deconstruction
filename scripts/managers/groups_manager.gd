extends Node

## Current groups in the game:
## - players
## - servers
## - notes

@export var groups = ['players', 'servers', 'notes'] as Array

func _ready():
	Logger.console(3, ["[Group Manager] Ready."])


func get_group(group: String) -> Array:
	if group in groups:
		return get_tree().get_nodes_in_group(group)
	return []

func call_group(group: String, action: String):
	get_tree().call_group(group, action)
