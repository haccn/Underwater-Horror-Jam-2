extends Interactable

func get_is_enabled():
	return Global.cutscene_index == 0
	
func interact():
	$"/root/SubmarineScene/Player".is_in_cutscene = true
	$"../AudioStreamPlayer".playing = true
	Global.transition_scene("res://cockpit_scene.tscn")
