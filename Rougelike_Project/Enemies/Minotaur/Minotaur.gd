extends Enemy

@onready var hitbox : Area2D = get_node("Hitbox")
@onready var collision : CollisionShape2D = get_node("Area2D/CollisionShape2D")
@onready var nav_agent : NavigationAgent2D = get_node("NavigationAgent2D")

@export var player_in_area : bool = false

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _on_area_2d_body_entered(player : Node2D) -> void:
	if player is CharacterBody2D:
		player_in_area = true

func _on_area_2d_body_exited(player : Node2D) -> void:
	if player is CharacterBody2D:
		player_in_area = false
