extends Interactable

@onready var player = $"/root/SubmarineScene/Player"

func interact():
	get_tree().change_scene_to_file("res://cockpit_scene.tscn")
