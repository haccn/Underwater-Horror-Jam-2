extends Interactable

const pickup_sound = preload("res://assets/pickup.mp3")

func get_is_enabled():
	return Global.cutscene_index > 0

func interact():
	Global.player_has_drill = true
	
	var audio = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(audio)
	audio.stream = pickup_sound
	audio.play()
	audio.connect("finish", func(): audio.queue_free())
	
	get_parent().queue_free()
