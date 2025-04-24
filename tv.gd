extends MeshInstance3D

const noise_video = preload("res://assets/submarine/tv/noise.ogv")

var capture: AudioEffectCapture
var playback: AudioStreamGeneratorPlayback

func _ready():
	var audio_stream_player = $AudioStreamPlayer3D
	
	if Global.cutscene_index == 0:
		audio_stream_player.volume_db = -18
	else:
		audio_stream_player.volume_db = -32
		$SubViewport/VideoStreamPlayer.stream = noise_video
		$SubViewport/VideoStreamPlayer.loop = true
		$SubViewport/VideoStreamPlayer.play()
	
	capture = AudioServer.get_bus_effect(AudioServer.get_bus_index("Tv"), 0)
	audio_stream_player.stream = AudioStreamGenerator.new()
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	fill_playback_buffer()

func _process(delta: float) -> void:
	fill_playback_buffer()

# Big thanks to https://forum.godotengine.org/t/positional-audio-from-2d-viewports-in-3d-space/105020/2
func fill_playback_buffer():
	var playback_available = playback.get_frames_available()
	var capture_available = capture.get_frames_available()
	# Fill the playback buffer until we run out of captured frames or playback frames
	while playback_available > capture_available:
		var buffer = capture.get_buffer(capture_available)
		playback.push_buffer(buffer)
		
		playback_available -= capture_available
		if playback_available <= 0:
			break
		capture_available = capture.get_frames_available()
		if capture_available <= 0:
			break
