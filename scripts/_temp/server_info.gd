extends HBoxContainer

signal join_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	var join_button = get_node("Join")
	if join_button:
		join_button.connect("pressed", Callable(self, "_on_join_pressed"))
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_join_pressed():
	emit_signal("join_pressed")
	pass # Replace with function body.
