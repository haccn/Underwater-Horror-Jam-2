extends CameraController

var accel = 5
var decel = 3
var speed = 4

var _velocity = Vector2.ZERO

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "forward", "back")
	_velocity += input * accel * delta
	_velocity = _velocity.limit_length(speed)
	
	_velocity = _velocity.lerp(Vector2.ZERO, decel * delta)
	
	velocity = transform.basis * $Camera3D.basis * Vector3(_velocity.x, 0, _velocity.y)

	move_and_slide()
