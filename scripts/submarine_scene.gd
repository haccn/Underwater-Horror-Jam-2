extends Node

const hello_and_welcome = preload("res://assets/voice/hello_and_welcome.wav")
const nuclear_reactor_damaged = preload("res://assets/voice/nuclear_reactor_damaged.mp3")

@onready var robot = $Robot

func _ready():
	# Gameplay stuff
	
	Global.player_is_underwater = false
	
	if Global.cutscene_index == 0 or Global.player_is_respawning:
		$Player/AnimationPlayer.play("Print")
		$BioPrinter/AnimationPlayer.play("Print", -1, 0.5)
		$BioPrinter/Effect.emitting = true
	else:
		$Player.global_transform = $DoorPlayerTransform.global_transform
	
	# Cutscene specific stuff
	
	if Global.cutscene_index > 0:
		$DangerSiren/AudioStreamPlayer.play()
		
	if Global.cutscene_index == 0:
		create_timer(5, func():
			robot.stream = hello_and_welcome
			robot.play())
	elif Global.cutscene_index == 1:
		$Player.global_transform = $LadderPlayerTransform.global_transform
		$Submarine/Ladder/AudioStreamPlayer.play()
		$Submarine/EngineSound.stop()
		create_timer(4, func():
			robot.stream = nuclear_reactor_damaged
			robot.play()
			Global.cutscene_index += 1)

func create_timer(wait_time, callable):
	var timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", func():
		callable.invoke()
		timer.queue_free())
	return timer
