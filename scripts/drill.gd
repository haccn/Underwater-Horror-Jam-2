extends Interactable

func get_is_enabled():
	return true
	#return Global.cutscene_index > 0

func interact():
	Global.player_has_drill == true
	$"../AudioStreamPlayer".playing = true
	$"../AudioStreamPlayer".connect("finished", func():
		get_parent().queue_free())
