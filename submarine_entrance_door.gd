extends Interactable

func interact():
	Global.player_is_underwater = false
	get_tree().change_scene_to_file("res://submarine_scene.tscn")
