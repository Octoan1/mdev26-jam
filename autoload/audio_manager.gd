extends Node
const TEST_AUDIO = preload("uid://bcabmuhk50dcp")

var volume: float = 0.5
var bg_music: AudioStreamPlayer

func _ready() -> void:
	bg_music = AudioStreamPlayer.new()
	bg_music.stream = TEST_AUDIO
	bg_music.autoplay = true
	bg_music.volume_linear = volume
	
	add_child(bg_music)

func update_volume() -> void:
	bg_music.volume_linear = volume
