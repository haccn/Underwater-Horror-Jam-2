# https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

extends Node

var cutscene_index = 0

var player_has_drill = false
var player_is_underwater = false

@onready var tree = get_tree()
@onready var root = get_tree().root

func respawn():
	tree.current_scene.get_node("Player/AnimationPlayer").play("Print")
	tree.current_scene.get_node("BioPrinter/AnimationPlayer").play("Print", -1, 0.5)
	tree.current_scene.get_node("BioPrinter/Effect").emitting = true
