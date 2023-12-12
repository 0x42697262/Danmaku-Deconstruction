extends Node


var mercury = preload("res://assets/Characters/mercury.png") as Texture
var venus   = preload("res://assets/Characters/venus.png") as Texture
var earth   = preload("res://assets/Characters/earth.png") as Texture
var mars    = preload("res://assets/Characters/mars.png") as Texture
var jupiter = preload("res://assets/Characters/jupiter.png") as Texture
var saturn  = preload("res://assets/Characters/saturn.png") as Texture
var uranus  = preload("res://assets/Characters/uranus.png") as Texture
var neptune = preload("res://assets/Characters/neptune.png") as Texture

func get_planet(planet_idx: int) -> Texture:
	match planet_idx:
		1:
			return mercury
		2:
			return venus
		3:
			return earth
		4:
			return mars
		5:
			return jupiter
		6:
			return saturn
		7:
			return uranus
		8:
			return neptune
	return
