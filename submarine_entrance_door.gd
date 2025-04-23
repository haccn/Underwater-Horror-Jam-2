extends Interactable

func interact():
	$AudioStreamPlayer.playing = true
	Global.transition_scene("res://submarine_scene.tscn")
