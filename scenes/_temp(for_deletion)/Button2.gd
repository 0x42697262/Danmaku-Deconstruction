extends Button


@onready var parent = get_node("/root/main")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var game_world = parent.get_node("game_world")
	var sc = preload("res://scenes/world/gameplay.tscn").instantiate()
	game_world.replace(sc)
