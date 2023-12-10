extends Control

@onready var AudioName = $HBoxContainer/AudioName as Label
@onready var AudioNum =$HBoxContainer/AudioNum as Label
@onready var MasterSlider = $HBoxContainer/MasterSlider as HSlider

@export_enum("Master","Music","Sfx") var bus_name :String

var bus_index : int=0

func _ready():
	MasterSlider.value_changed.connect(on_value_changed) 
	get_bus_name_by_index()
	set_name_label_text()
	set_slider_value()
	
func set_name_label_text() -> void:
	AudioName.text = str(bus_name) + " Volume"
	
func set_num_label_text() -> void:
	AudioNum.text = str(MasterSlider.value * 100) + "%"
	
func get_bus_name_by_index()-> void:
	bus_index= AudioServer.get_bus_index(bus_name)
	bus_index += 1
	
func set_slider_value() -> void:
	MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db (bus_index))
	set_num_label_text()

	
	
func on_value_changed(value : float) ->void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_num_label_text()
	


