extends FiniteStateMachine

var can_jump: bool = false

@onready var path_timer : Timer = parent.get_node("PathTimer")
@onready var jump_timer : Timer = parent.get_node("JumpTimer")

func _init():
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta : float) -> void:
	if state == states.jump:
		parent.chase()
		parent.move()

func _get_transition() -> int:
	match state:
		states.idle:
			if can_jump:
				return states.jump
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1

func _exit_state(state_exited : int) -> void:
	if state_exited == states.jump:
		can_jump = false
		path_timer.start()
		jump_timer.start()

func _on_jump_timer_timeout() -> void:
	can_jump = true
	