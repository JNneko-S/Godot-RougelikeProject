extends Node2D

var arrow = load("res://Arts/ui (new)/crosshair_3.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
