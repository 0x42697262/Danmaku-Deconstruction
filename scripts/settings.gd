## Settings Scene
##
## This scene serves as a singleton to manage game settings such as volume levels
## and key bindings. It provides a central point for accessing and modifying these
## settings throughout the game.
## The settings that have been provided are default values.
extends Node2D

## Volume settings
@export var volume: float = 1.0
## Key bindings settings
@export var keybinds: Dictionary = {
	"move_dash"     : KEY_Z,
	"move_left"     : KEY_LEFT,
	"move_right"    : KEY_RIGHT,
	"move_focus"    : KEY_SHIFT,
	"move_skill"    : KEY_SPACE,
  }


## Key Bindings Settings
##
## This function is responsible for setting up key bindings for player movement.
##
## Note that using physical keycode corresponds to the actual button position of the keyboard
## regardless of the keyboard layout used.
##
## @Tutorial: https://docs.godotengine.org/en/stable/classes/class_inputmap.html
## @Tutorial(Tutorial 2): https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html
## @Tutorial(Tutorial 3): https://docs.godotengine.org/en/stable/classes/class_inputeventwithmodifiers.html
func set_keybinds():
	for key in keybinds:
		var ev: InputEventKey = InputEventKey.new()
		ev.physical_keycode = keybinds[key]
		InputMap.add_action(key)
		InputMap.action_add_event(key, ev)
	# add shift to the dash movement
	var ev: InputEventKey = InputEventKey.new()
	ev.physical_keycode = keybinds["move_dash"]
	ev.shift_pressed = true
	InputMap.action_add_event("move_dash", ev)


## Settings singleton 
##
## Loads the settings into the game.
func _ready():
	set_keybinds()
