extends Enemy #Characterから継承されている

const THROWABLE_KNIFE_SCENE : PackedScene = preload("res://Enemies/Goblin/ThrowableKnife.tscn")

const MAX_DISTANCE_TO_PLAYER : int = 150 #最大距離
const MIN_DISTANCE_TO_PLAYER : int = 30 #最小距離

var distance_to_player : float
var can_attack : bool = true

@export var projectile_speed : int = 150

@onready var AimRayCast : RayCast2D = get_node("AimRayCast")
@onready var ATTimer : Timer = get_node("AttackTimer")
@onready var hitbox : Area2D = get_node("Hitbox")
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var ThrowSE : AudioStreamPlayer = get_node("ThrowSE")

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
			AimRayCast.target_position = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.idle and not AimRayCast.is_colliding():
				#Goblinが壁に向かって攻撃する問題が発生
				can_attack = false
				_throw_knife()
				ThrowSE.play()
				ATTimer.start()
	else:
		Path_timer.stop()
		move_direction = Vector2.ZERO

func _get_path_to_move_away_from_player() -> void:
	var dir : Vector2 = (global_position - player.position).normalized()
	#dirはプレイヤーまでの方向の逆数
	navigation_agent.target_position = global_position + dir * 100
	#プレイヤーから100ピクセル離れた位置でパスを更新する。

func _throw_knife() -> void:
	var projectile : Area2D = THROWABLE_KNIFE_SCENE.instantiate()
	
	#ThrowableKnife.gd(7,1)参照してください。
	#初期位置を示すglobal_position、方向を示すプレイヤーへの正規化ベクトル、速度を示すprojectile_speedを規定している
	projectile.launch(global_position,(player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _on_attack_timer_timeout() -> void:
	can_attack = true
