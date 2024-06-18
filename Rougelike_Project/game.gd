extends Node2D

@onready var musicplayer = get_node("AudioStreamPlayer")
@onready var Player : AnimationPlayer = get_node("Player/AnimationPlayer")

var arrow = load("res://Arts/ui (new)/crosshair_3.png")
#マウスカーソルの画像をロード

func _init() -> void:
	randomize() #部屋をランダム生成している

func _ready():
	Input.set_custom_mouse_cursor(arrow)

func playing_music() -> void:
	if Player.is_play("dead"):
		musicplayer.stop
