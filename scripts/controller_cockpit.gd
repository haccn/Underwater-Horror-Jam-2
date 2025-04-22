extends Controller

class_name ControllerCockpit

const mouse_sensitivity = 0.0005

const accel = 3
const decel = 2
const speed = 5

const rotate_accel = 0.5
const rotate_decel = 0.5
const rotate_speed = 0.1

@onready var camera_container = $"../CameraContainer"
@onready var camera = $"../CameraContainer/Camera3D"
@onready var objective_pos = $"/root/CockpitScene/ObjectivePosition"
@onready var radar_viewport = $"../RadarViewport"
@onready var objective_dot = $"../RadarViewport/ObjectiveDot"

var _velocity = Vector2.ZERO
var _rotate_velocity = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	if is_enabled:
		_rotate_velocity += Input.get_axis("left", "right") * rotate_accel * delta
		_rotate_velocity = clampf(_rotate_velocity, -rotate_speed, rotate_speed)
	_rotate_velocity = lerpf(_rotate_velocity, 0, rotate_decel * delta)
	player.rotate_y(-deg_to_rad(_rotate_velocity))
	
	if is_enabled:
		_velocity += Vector2(0, -Input.get_action_raw_strength("forward")) * accel * delta
		_velocity = _velocity.limit_length(speed)
	_velocity = _velocity.lerp(Vector2.ZERO, decel * delta)
	player.velocity = player.transform.basis * Vector3(_velocity.x, 0, _velocity.y)
	player.move_and_slide()
	
	if is_enabled:
		var offset_to_objective = player.to_local(objective_pos.global_position)
		offset_to_objective = Vector2(offset_to_objective.x, offset_to_objective.z)
		objective_dot.position = offset_to_objective + objective_dot.get_viewport_rect().size / 2
		if offset_to_objective.length() <= 10:
			GameManager.cutscene_index += 1
			is_enabled = false
			$"../DangerSiren/AnimationPlayer".play("Flash")
			$"../DangerSiren".visible = true
			$"../DangerSiren/AudioStreamPlayer".playing = true
			$"/root/CockpitScene/ObjectivePosition/AudioStreamPlayer".playing = false
			$"/root/CockpitScene/EngineNoise".playing = false
			$"../CanvasLayer".visible = true
	
func _input(event):
	if event is InputEventMouseMotion:
		camera_container.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_container.rotation.y = clampf(camera_container.rotation.y, -deg_to_rad(10), deg_to_rad(10))
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(10), deg_to_rad(10))

	elif event is InputEventKey:
		if InputMap.event_is_action(event, "interact"):
			get_tree().change_scene_to_file("res://submarine_scene.tscn")
