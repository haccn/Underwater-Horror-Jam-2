extends CharacterBody3D

class_name ControllerCockpit

const mouse_sensitivity = 0.0005
const shake_fade = 4
var shake_strength = 0

const accel = 2
const decel = 2
const speed = 5

const rotate_accel = 0.1
const rotate_decel = 0.1
const rotate_speed = 0.05

@onready var camera_container = $CameraContainer
@onready var camera = $CameraContainer/Camera3D
@onready var actual_camera = $CameraContainer/Camera3D/Camera3D
@onready var objective_pos = $"/root/CockpitScene/ObjectivePosition"
@onready var radar_viewport = $RadarViewport
@onready var objective_dot = $RadarViewport/ObjectiveDot
@onready var engine_noise = $/root/CockpitScene/EngineNoise2

var _velocity = Vector2.ZERO
var _rotate_velocity = 0
var _is_broken = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	if _is_broken == false:
		_rotate_velocity += Input.get_axis("left", "right") * rotate_accel * delta
		_rotate_velocity = clampf(_rotate_velocity, -rotate_speed, rotate_speed)
	_rotate_velocity = lerpf(_rotate_velocity, 0, rotate_decel * delta)
	rotate_y(-deg_to_rad(_rotate_velocity))
	
	if _is_broken == false:
		var forward = Input.get_action_raw_strength("forward")
		_velocity += Vector2(0, -forward) * accel * delta
		_velocity = _velocity.limit_length(speed)
		if forward != 0:
			engine_noise.volume_db = lerpf(engine_noise.volume_db, -14, 4 * delta)
		else:
			engine_noise.volume_db = lerpf(engine_noise.volume_db, -20, 4 * delta)
	_velocity = _velocity.lerp(Vector2.ZERO, decel * delta)
	velocity = transform.basis * Vector3(_velocity.x, 0, _velocity.y)
	move_and_slide()
	
	if _is_broken == false:
		var offset_to_objective = to_local(objective_pos.global_position)
		offset_to_objective = Vector2(offset_to_objective.x, offset_to_objective.z)
		objective_dot.position = offset_to_objective + objective_dot.get_viewport_rect().size / 2
		if offset_to_objective.length() <= 10:
			Global.cutscene_index += 1
			_is_broken = true
			$DangerSiren/AnimationPlayer.play("Flash")
			$DangerSiren.visible = true
			$DangerSiren/AudioStreamPlayer.play()
			$"/root/CockpitScene/ObjectivePosition/AudioStreamPlayer".stop()
			$"/root/CockpitScene/Creaking".play()
			get_tree().create_timer(4).connect("timeout", func():
				$"/root/CockpitScene/Explosion".play()
				$"/root/CockpitScene/EngineNoise".stop()
				engine_noise.stop()
				$CanvasLayer.visible = true
				shake_strength = 0.75)
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		actual_camera.position = Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength))
	
func _input(event):
	if event is InputEventMouseMotion:
		camera_container.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_container.rotation.y = clampf(camera_container.rotation.y, -deg_to_rad(10), deg_to_rad(10))
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(10), deg_to_rad(10))

	elif event is InputEventKey:
		if InputMap.event_is_action(event, "interact"):
			if Global.cutscene_index > 0:
				get_tree().change_scene_to_file("res://submarine_scene.tscn")
