extends Interactable

func interact():
	$AudioStreamPlayer.play()
	Global.transition_scene("res://submarine_scene.tscn")
