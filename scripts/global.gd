# https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

extends Node

var cutscene_index = 0

var player_is_respawning = false
var player_respawn_count = 0

var player_is_underwater = false
var _player_has_drill = true
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
	player_is_respawning = true
	player_respawn_count += 1
	tree.change_scene_to_file("res://submarine_scene.tscn")

func transition_scene(path):
	tree.create_timer(2).connect("timeout", func():
		tree.change_scene_to_file(path))
