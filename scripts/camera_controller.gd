extends Controller

class_name CameraController

const mouse_sensitivity = 0.002
@export var y_range = NAN
@export var x_range = 70

@onready var camera = $"../Camera3D"
@onready var ray = $"../Camera3D/RayCast3D"
@onready var hand = $"../Camera3D/CanvasLayer/Hand"

var _interactable: Interactable = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if is_enabled == false:
		return
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		if event is InputEventKey:
			if event.keycode == KEY_ESCAPE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		# Interact with any interactable
		if _interactable != null and _interactable.is_enabled and \
			event.is_pressed() and event.is_echo() == false and \
			InputMap.event_is_action(event, "interact"):
			_interactable.interact()
		
		elif event is InputEventMouseMotion:
			player.rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			if y_range != NAN:
				camera.rotation.y = clampf(camera.rotation.y, -deg_to_rad(y_range), deg_to_rad(y_range))
			if x_range != NAN:
				camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(x_range), deg_to_rad(x_range))

			# Check for interactables
			_interactable = ray.get_collider() as Interactable
			if _interactable != null and _interactable.is_enabled:
				hand.set_visible(true)
			else:
				hand.set_visible(false)
