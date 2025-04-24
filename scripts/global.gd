# https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

extends Node

var cutscene_index = 0

var player_is_underwater = false
var _player_has_drill = false
var player_has_drill:
	get: return _player_has_drill
	set(value):
		_player_has_drill = value
		player_holding_changed.emit()
var _player_holding = Pickup.TYPE_NONE
var player_holding:
	get: return _player_holding
	set(value):
		_player_holding = value
		player_holding_changed.emit()

signal player_holding_changed

@onready var tree = get_tree()
@onready var root = get_tree().root

func respawn():
	tree.current_scene.get_node("Player/AnimationPlayer").play("Print")
	tree.current_scene.get_node("BioPrinter/AnimationPlayer").play("Print", -1, 0.5)
	tree.current_scene.get_node("BioPrinter/Effect").emitting = true

func transition_scene(path):
	tree.create_timer(2).connect("timeout", func():
		tree.change_scene_to_file(path))
