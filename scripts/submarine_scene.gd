extends Node

const hello_and_welcome = preload("res://assets/voice/hello_and_welcome.wav")
const nuclear_reactor_damaged = preload("res://assets/voice/nuclear_reactor_damaged.mp3")

@onready var robot = $Robot

func _ready():
	Global.player_is_underwater = false
	
	if Global.cutscene_index > 0:
		$DangerSiren/AudioStreamPlayer.play()
	
	if Global.cutscene_index == 0:
		Global.respawn()
		get_tree().create_timer(5).connect("timeout", func():
			robot.stream = hello_and_welcome
			robot.play())
	
	elif Global.cutscene_index == 1:
		$Player.global_transform = $LadderPlayerTransform.global_transform
		$Submarine/Ladder/AudioStreamPlayer.play()
		get_tree().create_timer(4).connect("timeout", func():
			robot.stream = nuclear_reactor_damaged
			robot.play()
			Global.cutscene_index += 1)
