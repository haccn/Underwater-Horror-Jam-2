extends Interactable

const dont_forget_drill = preload("res://assets/voice/dont_forget_drill.wav")

@onready var in_ship_pos = $InShipPos
@onready var out_ship_pos = $OutShipPos
@onready var player = $"/root/SubmarineScene/Player"
@onready var robot = $"/root/SubmarineScene/Robot"

func get_is_enabled():
	return Global.cutscene_index > 0

func interact():
	if Global.player_has_drill == false:
		if robot.playing == false:
			robot.stream = dont_forget_drill
			robot.playing = true
		return
	
	if player.is_underwater:
		player.global_position = in_ship_pos.global_position
		player.is_underwater = false
	else:
		player.global_position = out_ship_pos.global_position
		player.is_underwater = true
