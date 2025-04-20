extends CharacterBody3D

class_name ControllerManager

enum Controllers {
	None,
	Land,
	Underwater,
}

var _controller = Controllers.None
var _controller_instance: Controller = null
var controller:
	get: return _controller
	set(value):
		if _controller_instance != null:
			_controller_instance.queue_free()
		_controller = value
		match value:
			Controllers.None:
				_controller_instance = null
			Controllers.Land:
				_controller_instance = ControllerLand.new()
				add_child(_controller_instance)
			Controllers.Underwater:
				_controller_instance = ControllerUnderwater.new()
				add_child(_controller_instance)

func _ready():
	controller = Controllers.Land
	
func _physics_process(delta):
	if _controller_instance != null:
		_controller_instance._physics_process(delta)
