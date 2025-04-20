extends Node

enum Controllers {
	Land,
	Underwater,
}
var controller_land = load("res://controller_land.gd")
var controller_underwater = load("res://controller_underwater.gd")

var controller:
	set(value):
		match value:
			Controllers.Land:
				get_parent().set_script(controller_land)
			Controllers.Underwater:
				get_parent().set_script(controller_underwater)

func _ready():
	controller = Controllers.Underwater
