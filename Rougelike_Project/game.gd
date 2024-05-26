extends Node2D

var arrow = load("res://Arts/ui (new)/crosshair_3.png")

func _init() -> void:
	randomize()

func _ready():
	Input.set_custom_mouse_cursor(arrow)
