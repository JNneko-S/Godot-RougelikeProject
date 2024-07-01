extends Enemy

@onready var ghoulscene : PackedScene = preload("res://Enemies/ghoul/ghoul.tscn")

@onready var Raycast : RayCast2D = get_node("RayCast2D")
@onready var hitbox : Area2D = get_node("Hitbox")
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var distance_to_player : float
const MIN_DISTANCE_TO_PLAYER : int = 100 #最小距離

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		elif distance_to_player > MIN_DISTANCE_TO_PLAYER:
			pass
		

func _spawn():
	var ghoul = ghoulscene.instantiate()

func _get_path_to_move_away_from_player() -> void:
	var dir : Vector2 = (global_position - player.position).normalized()
	navigation_agent.target_position = global_position + dir * 300


