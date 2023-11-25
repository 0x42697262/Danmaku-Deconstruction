## Game Manager
##
## This script should handle everything which should be loaded first in the game.
## 
## Currently handles:
## - GUI
##
## Should handle:
## - Scene Transitions
## - Gameplay
## - Entities
## - Networking Multiplayer
## - Audio
## - Modules
##
## Autoloads should be added in the /scripts/autoloads directory then add the
## script on the project settings autoload
## 
## The /scripts directory should be independent of any scenes. Scripts for the
## scenes should be placed on the same directory as the scene itself.
## 
## Play Area: 800px x 598px

extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	set_scene_position()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Sets the position of scenes in game_world to center
func set_scene_position():
	var window_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var window_size: Vector2 = Vector2(window_width, window_height)

	$game_world.set_position(window_size/2)
