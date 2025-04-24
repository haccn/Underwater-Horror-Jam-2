extends Interactable

class_name Pickup

enum Type {
	None,
	Carbon,
	Iron,
	Lithium,
}
const TYPE_NONE = Type.None
const TYPE_CARBON = Type.Carbon
const TYPE_IRON = Type.Iron
const TYPE_LITHIUM = Type.Lithium

@export var type = Type.Carbon

func interact():
	Global.player_holding = type
	get_parent().queue_free()
