extends Node

class_name Interactable

@export var requires_button_hold = false
@export var button_hold_seconds = 3

func get_is_enabled():
	return true

func interact():
	print("Interacted!")
