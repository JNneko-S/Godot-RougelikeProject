extends FiniteStateMachine

@onready var skeleton = $".."
@onready var playerDetectionZone = $"../PlayerDetector"
@onready var Timers = $"../Timers"


enum {
	state_idle,
	state_dead,
	state_chase,
	state_attack,
	state_wander,
	state_hurt
}

const StateNames : Dictionary = {
	state_idle: "idle",
	state_dead: "dead",
	state_chase: "chase", #chaseはプレイヤーを追いかける用
	state_attack: "attack",
	state_wander: "wander", #wanderはプレイヤーを捜索する用
	state_hurt: "hurt"
}

var RandomState : Array = [state_idle,state_wander]

func _init() -> void:
	_add_state(StateNames[state_idle])
	_add_state(StateNames[state_dead])
	_add_state(StateNames[state_chase])
	_add_state(StateNames[state_attack])
	_add_state(StateNames[state_wander])
	_add_state(StateNames[state_hurt])

func _ready() -> void:
	state = states[StateNames[state_idle]]

func _state_logic(_delta: float) -> void: #各状態ごとのロジック
	if state == states.chase:
		parent.chase()
		parent.move()
	
	if state == states.wander:
		parent._wander(_delta)
		

func _get_transition() -> int:
	match state:
		StateNames[state_idle]:
			Timers._start_wander_timer(randf_range(1.2,3.0))
			return states[_pickup_randomstate()]
			
		StateNames[state_wander]:
			if Timers._time_remained() == 0:
				Timers._start_wander_timer(randf_range(1.0,3.0))
				return states[_pickup_randomstate()]
				
		StateNames[state_hurt]:
			if not animation_player.is_playing():
				return states.wander
				
		StateNames[state_attack]:
			if not animation_player.is_playing():
				return states.idle
				
	return -1

func _pickup_randomstate() -> String:
	return StateNames[RandomState.pick_random()]

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.dead:
			animation_player.play("dead")
		states.chase:
			animation_player.play("chase")
		states.attack:
			animation_player.play("attack")
		states.wander:
			animation_player.play("chase")
		states.hurt:
			animation_player.play("hurt")

func seek_player():
	if playerDetectionZone.can_see_player():
		return states.chase
