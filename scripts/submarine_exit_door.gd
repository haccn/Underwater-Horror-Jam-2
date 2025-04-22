extends Interactable

@onready var in_ship_pos = $InShipPos
@onready var out_ship_pos = $OutShipPos
@onready var player = $"/root/SubmarineScene/Player"

func interact():
	if player.is_underwater:
		player.global_position = in_ship_pos.global_position
		player.is_underwater = false
	else:
		player.global_position = out_ship_pos.global_position
		player.is_underwater = true
