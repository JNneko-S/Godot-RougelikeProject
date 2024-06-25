extends FiniteStateMachine

func _init() -> void:
	_add_state("attack")
	_add_state("dead")
	_add_state("hurt")
	_add_state("move")

func _ready() -> void:
	set_state(states.move)

func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()

func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.move
		states.move:
			if parent.player_in_area:
				return states.attack
		states.attack:
			if not animation_player.is_playing():
				return states.move
	return -1

func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.attack:
			animation_player.play("attack")
		states.dead:
			animation_player.play("dead")
