extends CameraController

class_name ControllerUnderwater

const accel = 5
const decel = 3
const speed = 3

var _velocity = Vector3.ZERO

func _physics_process(delta):
	if is_enabled == false:
		return

	var input = Input.get_vector("left", "right", "forward", "back")
	var up_down = Input.get_axis("down", "up")
	_velocity += Vector3(input.x, up_down, input.y) * accel * delta
	_velocity = _velocity.limit_length(speed)
	
	_velocity = _velocity.lerp(Vector3.ZERO, decel * delta)
	
	player.velocity = player.transform.basis * _velocity

	player.move_and_slide()
