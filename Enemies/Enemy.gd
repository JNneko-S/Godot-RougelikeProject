@icon("res://Arts/enemies/goblin/goblin_idle_anim_f0.png")

extends Character
class_name Enemy

var intermediate_room : Room

@onready var hitbox_collisions : Hitbox = get_node("Hitbox")
@onready var Path_timer : Timer = get_node("PathTimer")
@onready var player : CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var Navi_agent : NavigationAgent2D = get_node("NavigationAgent2D")

func _ready() -> void:
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	intermediate_room = get_parent()

func chase() -> void:
	if not Navi_agent.is_target_reached():
		var vector_to_next_point : Vector2 = Navi_agent.get_next_path_position() - global_position
		move_direction = vector_to_next_point.normalized()
		if vector_to_next_point.x > 0 and Animated_Sprite.flip_h:
			Animated_Sprite.flip_h = false
			hitbox_collisions.scale.x = 1
		elif vector_to_next_point.x < 0 and not Animated_Sprite.flip_h:
			Animated_Sprite.flip_h = true
			hitbox_collisions.scale.x = -1

func _get_path_to_player() -> void:
	Navi_agent.target_position = player.global_position

func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		Path_timer.stop()
		move_direction = Vector2.ZERO
