extends CameraController

class_name ControllerUnderwater

const accel = 5
const decel = 3
const speed = 3

var _velocity = Vector2.ZERO

func _physics_process(delta):
	if is_enabled == false:
		return
		
	var input = Input.get_vector("left", "right", "forward", "back")
	_velocity += input * accel * delta
	_velocity = _velocity.limit_length(speed)
	
	_velocity = _velocity.lerp(Vector2.ZERO, decel * delta)
	
	player.velocity = player.transform.basis * camera.basis * Vector3(_velocity.x, 0, _velocity.y)

	player.move_and_slide()
