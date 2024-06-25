extends Enemy

@export var WANDER_TARGET_RANGE : float = 4

@onready var finite_state_machine = $FiniteStateMachine

@onready var hitbox = $Hitbox
@onready var wander_timer = $Timers/WanderTimer
@onready var Timers = $Timers

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _wander(_delta) -> void:
	finite_state_machine.seek_player()
	var direction = global_position.direction_to(Timers.target_position)
	velocity = velocity.move_toward(direction * max_speed, accerelation * _delta)
	
	if global_position.distance_to(Timers.target_position) == WANDER_TARGET_RANGE:
		wander_timer._start_wander_timer(randf_range(1,3))
