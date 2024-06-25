extends FiniteStateMachine

func _init() -> void: #特定のクラスのインスタンスが生成される際に自動的に呼び出される
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void: #ノードの初回更新時に呼ばれる
	set_state(states.move)

func _state_logic(_delta: float) -> void: #各状態ごとのロジック
	if state == states.move:
		parent.chase()
		parent.move()

func _get_transition() -> int: #状態遷移を決定するロジック
	match state:
		states.idle:
			if parent.distance_to_player > parent.MAX_DISTANCE_TO_PLAYER or parent.distance_to_player < parent.MIN_DISTANCE_TO_PLAYER:
				return states.move #状態がidleで、プレイヤーとの距離が近すぎたり遠すぎたりする場合は、状態を移動に変更する。
		states.move:
			if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER and parent.distance_to_player > parent.MIN_DISTANCE_TO_PLAYER:
				return states.idle #状態がmoveで、プレイヤーとの距離が最大距離と最小距離の間にある場合、状態をアイドルに変更する。
		states.hurt:
			if not animation_player.is_playing():
				return states.move #状態がfurtで、アニメーションが終わったら状態をmoveに戻す
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("walk")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
