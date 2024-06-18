extends Room

@onready var BG_player : AudioStreamPlayer = get_tree().current_scene.get_node("AudioStreamPlayer")
@onready var Boss_player : AudioStreamPlayer = get_node("BossAudioPlayer")

func _on_player_detector_body_entered(body):
	#BG_player.stream_paused
	Boss_player.playing = true
