extends Node

func rotate_vector(vector: Vector2, degrees: float) -> Vector2:
	var radians = deg_to_rad(degrees)
	var x = vector.x * cos(radians) - vector.y * sin(radians)
	var y = vector.x * sin(radians) + vector.y * cos(radians)
	return Vector2(x, y)
