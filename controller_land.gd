extends CameraController

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5

func _physics_process(delta):
	velocity.y += -gravity * delta
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()
