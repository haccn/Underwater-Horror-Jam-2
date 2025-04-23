extends Interactable

const dont_forget_drill = preload("res://assets/voice/dont_forget_drill.wav")

@onready var robot = $"/root/SubmarineScene/Robot"

func get_is_enabled():
	return Global.cutscene_index > 0

func interact():
	if Global.player_has_drill == false:
		if robot.playing == false:
			robot.stream = dont_forget_drill
			robot.playing = true
		return
	
	Global.player_is_underwater = true
	get_tree().change_scene_to_file("res://main_scene.tscn")
