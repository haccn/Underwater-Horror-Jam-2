extends CharacterBody3D

class_name ControllerManager

var _is_underwater
var is_underwater:
	get: return _is_underwater
	set(value):
		if value:
			_controller_instance = ControllerUnderwater.new()
		else:
			_controller_instance = ControllerLand.new()
		add_child(_controller_instance)
		
var _is_in_cutscene
var is_in_cutscene:
	get: return _is_in_cutscene
	set(value):
		_is_in_cutscene = value
		_controller_instance.is_enabled = !value

var _controller_instance = null

func _ready():
	is_underwater = false
	is_in_cutscene = false
