extends CharacterBody3D

class_name ControllerManager

var _is_underwater
var is_underwater:
	get: return _is_underwater
	set(value):
		if value:
			_controller_instance = ControllerUnderwater.new()
			motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
			land_collision_shape.disabled = true
			underwater_collision_shape.disabled = false
		else:
			_controller_instance = ControllerLand.new()
			motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
			land_collision_shape.disabled = false
			underwater_collision_shape.disabled = true
		add_child(_controller_instance)
		
var _is_in_cutscene
var is_in_cutscene:
	get: return _is_in_cutscene
	set(value):
		_is_in_cutscene = value
		_controller_instance.is_enabled = !value

@onready var land_collision_shape = $LandShape
@onready var underwater_collision_shape = $UnderwaterShape

var _controller_instance = null

func _ready():
	is_underwater = false
	is_in_cutscene = false

func _physics_process(delta):
	if Global.player_is_underwater:
		pass
	else:
		pass
