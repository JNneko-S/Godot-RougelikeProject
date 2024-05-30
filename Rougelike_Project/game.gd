extends Node2D

var arrow = load("res://Arts/ui (new)/crosshair_3.png")
#マウスカーソルの画像をロード

func _init() -> void:
	randomize() #部屋をランダム生成している

func _ready():
	Input.set_custom_mouse_cursor(arrow)
