extends CameraController

class_name ControllerLand

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const speed = 2

func _physics_process(delta):
	player.velocity.y += -gravity * delta
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = player.transform.basis * Vector3(input.x, 0, input.y)
	player.velocity.x = movement_dir.x * speed
	player.velocity.z = movement_dir.z * speed

	player.move_and_slide()
