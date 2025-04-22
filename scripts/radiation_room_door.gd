extends Interactable

@onready var in_pos = $"../InPos"
@onready var out_pos = $"../OutPos"
@onready var player = $"/root/SubmarineScene/Player"

var _is_in = false

func interact():
	if _is_in:
		player.global_position = out_pos.global_position
		_is_in = false
	else:
		player.global_position = in_pos.global_position
		_is_in = true
