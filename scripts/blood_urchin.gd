extends Node3D

@onready var ray = $RayCast3D
@onready var anim_tree = $AnimationTree

var camera: Camera3D = null

func _physics_process(delta: float) -> void:
	if camera == null:
		var player = ray.get_collider() as Player
		if player != null:
			camera = player.get_node("Camera3D")
			anim_tree.set("parameters/Suck/blend_amount", 1)
			$AudioStreamPlayer.play()
			get_tree().create_timer(3).connect("timeout", func():
				Global.respawn())
	else:
		position = camera.global_basis * Vector3(0, 0, 0.5)
		rotation = camera.rotation
