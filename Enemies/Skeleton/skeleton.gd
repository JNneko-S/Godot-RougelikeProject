extends Enemy

@export var WANDER_TARGET_RANGE : float = 4

@onready var finite_state_machine = $FiniteStateMachine

@onready var hitbox = $Hitbox
@onready var Timers = $Timers
@onready var sprite = $AnimatedSprite2D


var Player_in_area_PD : bool = false
var Player_in_area_AD : bool = false

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _wander(_delta) -> void:
	var direction = global_position.direction_to(Timers.target_position)
	velocity = velocity.move_toward(direction * 200, 200 * _delta)
	sprite.flip_h = velocity.x < 0
	
	if global_position.distance_to(Timers.target_position) == WANDER_TARGET_RANGE:
		Timers.start_wander_timer(randf_range(1,3))

func _on_player_detector_body_entered(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		Player_in_area_PD = true
		print("PD true")

func _on_player_detector_body_exited(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		Player_in_area_PD = false
		print("PD false")

func _on_attack_detector_body_entered(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		Player_in_area_AD = true
		print("AD true")

func _on_attack_detector_body_exited(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		Player_in_area_AD = false
		print("AD false")
