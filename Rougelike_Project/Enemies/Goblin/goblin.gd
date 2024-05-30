extends Enemy #Characterから継承されている

const MAX_DISTANCE_TO_PLAYER : int = 300 #ゴブリンが動かない最大距離
const MIN_DISTANCE_TO_PLAYER : int = 60 #最小距離

var distance_to_player : float

@onready var hitbox : Area2D = get_node("Hitbox")
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _on_path_timer_timeout() -> void:
	if is_instance_valid(player): #プレイヤーが有効なインスタンスかどうかをチェック
		distance_to_player = (player.position - global_position).length() 
		#lengthは位置ベクトルの差を求めて2点間の距離を求める。つまり、プレイヤーの位置とグローバル位置の距離を図っている。
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		#距離が最大距離定数より大きい場合、プレイヤーまでの経路を取得する。
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
			#最小距離定数よりも近い場合、 プレイヤーから離れる経路を取得する。
	else:
		Path_timer.stop()
		move_direction = Vector2.ZERO

func _get_path_to_move_away_from_player() -> void:
	var dir : Vector2 = (global_position - player.position).normalized()
	#dirはプレイヤーまでの方向の逆数
	navigation_agent.target_position = global_position + dir * 100
	#プレイヤーから100ピクセル離れた位置でパスを更新する。
