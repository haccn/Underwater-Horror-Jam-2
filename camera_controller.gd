extends CharacterBody3D

class_name CameraController

var mouse_sensitivity = 0.002

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		if event is InputEventKey:
			if event.keycode == KEY_ESCAPE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		elif event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
			$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
