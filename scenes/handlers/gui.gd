extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

## Replace GUI
##
## replaces all gui with a new gui
func replace_gui(node: Node):
	remove_all_children()
	add_child(node)

## Remove all children
func remove_all_children():
	for existing_child in get_children():
		existing_child.queue_free()
