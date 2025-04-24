extends Node3D

@onready var ray = $RayCast3D
@onready var anim_player = $BloodUrchin/AnimationPlayer

var camera: Camera3D = null
var is_affixed = false

func _physics_process(delta: float) -> void:
	if camera == null:
		var player = ray.get_collider() as Player
		if player != null:
			camera = player.get_node("Camera3D")
			anim_player.play("Suck")
			$AudioStreamPlayer.play()
			get_tree().create_timer(3).connect("timeout", func():
				Global.respawn())
	else:
		if is_affixed == false:
			reparent(camera)
			is_affixed = true
		position = position.lerp(Vector3(0, 0, -0.2), 10 * delta)
		rotation_degrees = rotation_degrees.lerp(Vector3(-90, 0, 0), 10 * delta)
