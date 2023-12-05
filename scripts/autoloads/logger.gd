## Debug Logger, maybe
##
## Use this when you want to print to console.
## To not potentially slow down the game, only use this on non-looping
## functions.

extends Node

## Log Level
##
## Logs messages if higher than this level.
## To disable logging, set the LOG_LEVEL to a high number like 999
const LOG_LEVEL: int = 0

## Console printing
func console(level: int, message: Array):
	if level >= LOG_LEVEL:
		var time_passed: int = Time.get_ticks_msec()
		print(":: (", time_passed, " ms) ", " ".join(message))
