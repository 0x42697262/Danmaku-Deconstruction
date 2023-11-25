extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Replace Scene
##
## replaces all scenes with another scene
func replace(node: Node):
	remove_all_children()
	add_child(node)

## Remove all children
func remove_all_children():
	for existing_child in get_children():
		existing_child.queue_free()
