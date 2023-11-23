# settings.gd

## Description

Settings Scene

This scene serves as a singleton to manage game settings such as volume levels
and key bindings. It provides a central point for accessing and modifying these
settings throughout the game.
The settings that have been provided are default values.

## Property Descriptions

### volume

```gdscript
@export var volume: float = 1
```

Volume settings

### keybinds

```gdscript
@export var keybinds: Dictionary
```

Key bindings settings

## Method Descriptions

### set\_keybinds

```gdscript
func set_keybinds()
```

Key Bindings Settings

This function is responsible for setting up key bindings for player movement.

Note that using physical keycode corresponds to the actual button position of the keyboard
regardless of the keyboard layout used.

@Tutorial: https://docs.godotengine.org/en/stable/classes/class_inputmap.html
@Tutorial(Tutorial 2): https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html
@Tutorial(Tutorial 3): https://docs.godotengine.org/en/stable/classes/class_inputeventwithmodifiers.html