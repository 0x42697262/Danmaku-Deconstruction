extends Area2D

signal gameover(player)
signal touched(body_rid)

@export_category("Properties")
@export var health_points: int  = 3
@export var is_alive: bool      = true

var texture_red: Texture    = preload("res://assets/Characters/red_character.png")
var texture_orange: Texture = preload("res://assets/Characters/orange_character.png")
var texture_green: Texture  = preload("res://assets/Characters/green_character.png")
var texture_dead: Texture  = preload("res://assets/Characters/gray_character.png")


func _ready():
	$sprite.texture = texture_green
	hide_mouse(true)
	
		
func _input(event):
	# Getting the movement of the mouse so the sprite can follow its position.
	if event is InputEventMouseMotion and is_alive == true:
		position = event.position
		
func _process(delta):
	position.x = clamp(position.x, 0, 1152)
	position.y = clamp(position.y, 0, 648)

func hide_mouse(value: bool):
	if value == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)




func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	health_points -= 1
	touched.emit(body_rid)
	match health_points:
		1:
			$sprite.texture = texture_red
		2:
			$sprite.texture = texture_orange
		0:
			gameover.emit(self)
	# game over
	if health_points <= 0:
		is_alive = false
		hide_mouse(false)
		print('dead')
