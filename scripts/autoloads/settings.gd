extends Node2D

## Settings Scene
##
## This scene serves as a singleton to manage game settings such as volume levels
## and key bindings. It provides a central point for accessing and modifying these
## settings throughout the game.
## The settings that have been provided are default values.

## Volume settings
var volume: float = 1.0
## Key bindings settings
var keybinds: Dictionary = {
	"move_dash"     : KEY_J,
	"move_left"     : KEY_A,
	"move_right"    : KEY_D,
	"move_focus"    : KEY_SHIFT,
	"move_special"  : KEY_SPACE,
	"move_up"       : KEY_W,
	"move_down"     : KEY_S,
  }

## LAN Address
var address: String = "0.0.0.0"
## LAN Port
var port: int = 42069

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
	InputMap.load_from_project_settings() # resets the key binds
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
