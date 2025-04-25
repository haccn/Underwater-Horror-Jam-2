extends Interactable

func get_is_enabled():
	return Global._player_items.back() == Pickup.TYPE_RAM

func interact():
	Global._player_items.clear()
	Global.player_holding_changed.emit()
	$"../MeshInstance3D".visible = true
	$/root/SubmarineScene/AnimationPlayer.play("EndGame")
