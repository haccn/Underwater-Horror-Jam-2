extends Controller

class_name CameraController

const mouse_sensitivity = 0.002

@onready var camera = $"../Camera3D"
@onready var ray = $"../Camera3D/RayCast3D"
@onready var hand = $"../Camera3D/CanvasLayer/Hand"

var _interactable: Interactable = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	# Check for interactables
	_interactable = ray.get_collider() as Interactable
	if _interactable != null and _interactable.get_is_enabled():
		hand.set_visible(true)
	else:
		hand.set_visible(false)	
		
func _input(event):
	if is_enabled == false:
		return
	
	# Interact with any interactable
	if InputMap.event_is_action(event, "interact"):
		if _interactable != null and _interactable.get_is_enabled() and \
			event.is_pressed() and event.is_echo() == false:
				_interactable.interact()
	
	elif event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.y = clampf(camera.rotation.y, -deg_to_rad(70), deg_to_rad(70))
