extends FiniteStateMachine

func _init():
	_add_state("dead")
	_add_state("hurt")
	_add_state("idle")
	_add_state("move")
	_add_state("summon")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta : float) -> void:
	if state == states.move:
		pass ##逃げる処理

func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.move
		states.idle:
			if not animation_player.is_playing():
				return states.summon
		states.move:
			if not animation_player.is_playing():
				return states.idle
		states.summon:
			if not animation_player.is_playing():
				return states.idle
	return -1


func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.hurt:
			animation_player.play("hurt")
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.summon:
			animation_player.play("summon")
		states.dead:
			animation_player.play("dead")
