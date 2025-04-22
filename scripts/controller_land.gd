extends CameraController

class_name ControllerLand

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const speed = 2
const time_between_steps_s = 0.5
const footstep_metal_1 = preload("res://assets/footsteps/footstep_metal_1.wav")
const footstep_metal_2 = preload("res://assets/footsteps/footstep_metal_2.wav")
const footstep_metal_3 = preload("res://assets/footsteps/footstep_metal_3.wav")

@onready var footstep_audio = $"../Footstep"

var _time_since_step = 0

func _physics_process(delta):
	if is_enabled == false:
		return
		
	player.velocity.y += -gravity * delta
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = player.transform.basis * Vector3(input.x, 0, input.y)
	player.velocity.x = movement_dir.x * speed
	player.velocity.z = movement_dir.z * speed

	player.move_and_slide()
	
	if player.velocity.length_squared() > 0:
		if _time_since_step >= time_between_steps_s:
			var footstep_index = randi_range(0, 2)
			if footstep_index == 0:
				footstep_audio.stream = footstep_metal_1
			elif footstep_index == 1:
				footstep_audio.stream = footstep_metal_2
			else:
				footstep_audio.stream = footstep_metal_3
			footstep_audio.pitch_scale = randf_range(1, 1.5)
			footstep_audio.playing = true
			_time_since_step = 0
		else:
			_time_since_step += delta
