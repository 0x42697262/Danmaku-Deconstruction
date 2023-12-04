extends Node2D

@export var difficulty: int = 0




func _ready():
	$timer.start()

func _on_timer_timeout():
	if difficulty >= 500:
		$timer.stop()
	
	difficulty += 1
