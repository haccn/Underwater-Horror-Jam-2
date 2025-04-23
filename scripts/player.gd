extends CharacterBody3D

const mouse_sensitivity = 0.002

const underwater_accel = 5
const underwater_decel = 3
const underwater_speed = 3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const land_speed = 2
const time_between_steps_s = 0.5
const footstep_metal_1 = preload("res://assets/footsteps/footstep_metal_1.wav")
const footstep_metal_2 = preload("res://assets/footsteps/footstep_metal_2.wav")
const footstep_metal_3 = preload("res://assets/footsteps/footstep_metal_3.wav")

@onready var camera = $Camera3D
@onready var hands_camera = $Hands/SubViewport/Camera3D
@onready var ray = $Camera3D/RayCast3D
@onready var interactable_hand = $Camera3D/CanvasLayer/Hand
@onready var flashlight = $Camera3D/Flashlight

@onready var land_collision_shape = $LandShape
@onready var underwater_collision_shape = $UnderwaterShape
@onready var footstep_audio = $Footstep

var is_in_cutscene = false

var _interactable: Interactable = null
var _time_since_step = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var window = get_window()
	$Hands/SubViewport.size = window.size
	window.connect("size_changed", func():
		$Hands/SubViewport.size = window.size)

func _input(event):
	if is_in_cutscene:
		return
	
	# Interact with any interactable
	if InputMap.event_is_action(event, "interact"):
		if _interactable != null and _interactable.get_is_enabled() and \
			event.is_pressed() and event.is_echo() == false:
				_interactable.interact()
				
	# Toggle flashlight
	elif InputMap.event_is_action(event, "flashlight"):
		if event.is_pressed() and event.is_echo() == false:
			flashlight.visible = !flashlight.visible
	
	# Move camera
	elif event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.y = clampf(camera.rotation.y, -deg_to_rad(70), deg_to_rad(70))

func _process(delta):
	hands_camera.global_transform = camera.global_transform
	
	if is_in_cutscene:
		return
	
	# Check for interactables
	_interactable = ray.get_collider() as Interactable
	if _interactable != null and _interactable.get_is_enabled():
		interactable_hand.set_visible(true)
	else:
		interactable_hand.set_visible(false)	

func _physics_process(delta):
	if is_in_cutscene:
		return
	
	# Movement
	if Global.player_is_underwater:
		motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		land_collision_shape.disabled = true
		underwater_collision_shape.disabled = false
		physics_process_underwater(delta)
	else:
		motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		land_collision_shape.disabled = false
		underwater_collision_shape.disabled = true
		physics_process_land(delta)

# Underwater movement
func physics_process_underwater(delta):
	var input = Input.get_vector("left", "right", "forward", "back")
	var up_down = Input.get_axis("down", "up")
	var movement_dir = transform.basis * Vector3(input.x, up_down, input.y)
	velocity += movement_dir * underwater_accel * delta
	velocity = velocity.limit_length(underwater_speed)
	
	velocity = velocity.lerp(Vector3.ZERO, underwater_decel * delta)
	
	move_and_slide()

# Land movement
func physics_process_land(delta):
	velocity.y += -gravity * delta
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * land_speed
	velocity.z = movement_dir.z * land_speed

	move_and_slide()
	
	if velocity.length_squared() > 0:
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
