extends Node

@export var player_health_points: Dictionary = {}

func add_player(id, new_player_name):
	player_health_points[id] = { name = new_player_name, hp = 30 }
	
func get_player_hp(player_name: int) -> int:
	return player_health_points[player_name].hp

func damage_player(for_who, damage: int = 10):
	assert(for_who in player_health_points)
	player_health_points[for_who].hp -= damage
	if player_health_points[for_who].hp <= 10:
		#player_health_points.erase(for_who)
		GameManager.gameover(for_who)
		

func heal_player(for_who, hp: int = 1):
	assert(for_who in player_health_points)
	player_health_points[for_who].hp += hp
