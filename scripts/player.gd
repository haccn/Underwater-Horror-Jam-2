extends CharacterBody3D

const mouse_sensitivity = 0.002

const underwater_accel = 5
const underwater_decel = 3
const underwater_speed = 3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const land_speed = 2
const time_between_steps_s = 0.5
const footsteps_metal = [
	preload("res://assets/footsteps/footstep_metal_1.wav"),
	preload("res://assets/footsteps/footstep_metal_2.wav"),
	preload("res://assets/footsteps/footstep_metal_3.wav"),
]

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
var _interact_hold_time = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var window = get_window()
	$Hands/SubViewport.size = window.size
	window.connect("size_changed", func():
		$Hands/SubViewport.size = window.size)
	
	Global.connect("player_holding_changed", _on_player_holding_changed)
	
	update_holding_items()

func _input(event):
	if is_in_cutscene:
		return
	
	# Interact with interactable that doesn't requires button hold
	# See _process for otherwise
	if event.is_action_pressed("interact"):
		if _interactable != null and _interactable.get_is_enabled():
			if _interactable.requires_button_hold == false:
				_interactable.interact()
				
	# Toggle flashlight
	elif event.is_action_pressed("flashlight"):
		flashlight.visible = !flashlight.visible
		$FlashlightToggle.play()
	
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
		
	# Interact with interactable that requires button hold
	# See _input for otherwise
	if _interactable != null and _interactable.requires_button_hold and _interactable.get_is_enabled() \
		and Input.is_action_pressed("interact"):
		_interact_hold_time += delta
		if _interact_hold_time >= _interactable.button_hold_seconds:
			_interactable.interact()
			_interact_hold_time = 0

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
			footstep_audio.stream = footsteps_metal[randi_range(0, 2)]
			footstep_audio.pitch_scale = randf_range(1, 1.5)
			footstep_audio.play()
			_time_since_step = 0
		else:
			_time_since_step += delta

func _on_player_holding_changed():
	update_holding_items()

func update_holding_items():
	if Global.player_has_drill:
		$Camera3D/Drill.visible = true
	else:
		$Camera3D/Drill.visible = false

	if Global.player_holding != Pickup.TYPE_NONE:
		pass
	
