extends Node

const hello_and_welcome = preload("res://assets/voice/hello_and_welcome.wav")
const nuclear_reactor_damaged = preload("res://assets/voice/nuclear_reactor_damaged.mp3")

@onready var robot = $Robot

func _ready():
	Global.player_is_underwater = false
	
	if Global.cutscene_index > 0:
		$DangerSiren/AudioStreamPlayer.playing = true
	
	if Global.cutscene_index == 0:
		Global.respawn()
		get_tree().create_timer(5).connect("timeout", func():
			robot.stream = hello_and_welcome
			robot.playing = true)
	
	elif Global.cutscene_index == 1:
		$Player.global_transform = $LadderPlayerTransform.global_transform
		$Submarine/Ladder/AudioStreamPlayer.playing = true
		get_tree().create_timer(4).connect("timeout", func():
			robot.stream = nuclear_reactor_damaged
			robot.playing = true
			Global.cutscene_index += 1)
