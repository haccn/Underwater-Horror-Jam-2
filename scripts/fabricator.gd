extends Interactable

func get_is_enabled():
	return Global._player_items.is_empty() == false

func interact():
	Global._player_items.clear()
	Global.pickup(Pickup.TYPE_RAM)
