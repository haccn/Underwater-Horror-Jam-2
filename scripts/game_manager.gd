# https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

extends Node

const hello_and_welcome = preload("res://assets/voice/hello_and_welcome.wav")

var cutscene_index = 0

@onready var tree = get_tree()
@onready var root = get_tree().root

func _ready():
	respawn()
	
	if cutscene_index == 0:
		var timer = tree.create_timer(5)
		timer.connect("timeout", func():
			var robot = tree.current_scene.get_node("Robot")
			robot.stream = hello_and_welcome
			robot.playing = true
			cutscene_index += 1)

func respawn():
	tree.current_scene.get_node("Player/AnimationPlayer").play("Print")
	tree.current_scene.get_node("BioPrinter/AnimationPlayer").play("Print", -1, 0.5)
	tree.current_scene.get_node("BioPrinter/Effect").emitting = true
