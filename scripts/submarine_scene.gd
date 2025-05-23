extends Node

const hello_and_welcome = preload("res://assets/voice/hello_and_welcome.wav")
const nuclear_reactor_damaged = preload("res://assets/voice/nuclear_reactor_damaged.mp3")
const back_so_soon = preload("res://assets/voice/back_so_soon.wav")

@onready var robot = $Robot

func _ready():
	# Gameplay stuff
	
	Global.player_is_underwater = false
	
	if Global.cutscene_index == 0 or Global.player_is_respawning:
		$BioPrinter/AnimationPlayer.play("Print", -1, 0.5)
		$BioPrinter/Effect.emitting = true
		$BioPrinter/AudioStreamPlayer.play()
		$Player/AnimationPlayer.play("Print")
	else:
		$Player.global_transform = $DoorPlayerTransform.global_transform
	
	# Cutscene specific stuff
	
	if Global.cutscene_index > 0:
		$DangerSiren/AudioStreamPlayer.play()
	if Global.cutscene_index > 1:
		$Drill.queue_free()
		
	if Global.cutscene_index == 0:
		get_tree().create_timer(5).connect("timeout", func():
			print("hello")
			robot.stream = hello_and_welcome
			robot.play())
	elif Global.cutscene_index == 1:
		$Player.global_transform = $LadderPlayerTransform.global_transform
		$Submarine/Ladder/AudioStreamPlayer.play()
		$Submarine/EngineSound.stop()
		get_tree().create_timer(4).connect("timeout", func():
			robot.stream = nuclear_reactor_damaged
			robot.play()
			Global.cutscene_index += 1)
	
	if Global.player_is_respawning and Global.player_respawn_count == 1:
		get_tree().create_timer(3).connect("timeout", func():
			robot.stream = back_so_soon
			robot.play())
	
	Global.player_is_respawning = false
