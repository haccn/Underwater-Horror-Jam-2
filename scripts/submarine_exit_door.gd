extends Interactable

const Controllers = preload("res://scripts/controller_manager.gd").Controllers

@onready var in_ship_pos = $InShipPos
@onready var out_ship_pos = $OutShipPos
@onready var player = $"/root/SubmarineScene/Player"

func interact():
	if player.controller == Controllers.Land:
		player.global_position = out_ship_pos.global_position
		player.controller = Controllers.Underwater
		
	elif player.controller == Controllers.Underwater:
		player.global_position = in_ship_pos.global_position
		player.controller = Controllers.Land
