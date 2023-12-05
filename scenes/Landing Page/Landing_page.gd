class_name Landing_Page
extends Control

@onready var PlayButton = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/PlayButton as Button
@onready var OptionsButton = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/OptionsButton as Button
@onready var ExitButton = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ExitButton as Button
@onready var Tutorial = $MarginContainer/Tutorial as Button
@onready var OptionMenu = $OptionMenu as Options_Menu
@onready var TutorialMenu = $TutorialMenu as TutorialsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var next = preload("res://scenes/multiplayer_lobby.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	Logger.console(0, ["Game Started"])
	handle_connecting_signal()


func on_play_press() -> void:
	get_tree().change_scene_to_packed(next)

func on_option_press() -> void:
	margin_container.visible = false
	OptionMenu.set_process(true)
	OptionMenu.visible = true
	
func on_exit_press() -> void:
	get_tree().quit()
	
func on_tutorial_press() -> void:
	margin_container.visible = false
	TutorialMenu.set_process(true)
	TutorialMenu.visible = true	
	
func on_exit_options_menu ()-> void:
	margin_container.visible = true
	OptionMenu.visible= false 
	
func on_exit_tutorial () -> void:
	margin_container.visible = true
	TutorialMenu.visible= false	
	
func handle_connecting_signal()->void:
	Logger.console(0, [self, "connecting signals..."])
	
	PlayButton.button_down.connect(on_play_press)
	OptionsButton.button_down.connect (on_option_press)
	ExitButton.button_down.connect(on_exit_press)
	OptionMenu.exit_options_menu.connect(on_exit_options_menu)
	Tutorial.button_down.connect(on_tutorial_press)
	TutorialMenu.exit_tutorial.connect(on_exit_tutorial)
	
	Logger.console(0, [self, "connecting signals... done!"])

	
