extends Area2D

@onready var player : CharacterBody2D = null

func _on_body_entered(_body : Node2D) -> void:
	if player is CharacterBody2D:
		player = _body

func _on_body_exited(_body: Node2D) -> void:
	if _body == player:
		player = null

func can_see_player():
	return player != null
