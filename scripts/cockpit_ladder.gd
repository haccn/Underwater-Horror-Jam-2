extends Interactable

@onready var player = $"/root/SubmarineScene/Player"

func get_is_enabled():
	return Global.cutscene_index == 0
	
func interact():
	get_tree().change_scene_to_file("res://cockpit_scene.tscn")
