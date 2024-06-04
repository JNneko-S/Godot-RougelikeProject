extends Node2D

const SPAWN_EXPLOSION_SCENE : PackedScene = preload("res://Enemies/spawn_explosion.tscn")

const ENEMY_SCENES : Dictionary = {
	"FLYING_CREATURE" : preload("res://Enemies/Flying_creature.tscn"),
	"GOBLIN" : preload("res://Enemies/Goblin/goblin.tscn")
}

#敵の数
@export var num_enemies : int 

## ノードを格納している変数
@onready var tilemap : TileMap = get_node("TileMap2")
@onready var entrance : Node2D = get_node("Entrance")
@onready var door_container : Node2D = get_node("Doors")
@onready var enemy_positions_container : Node2D = get_node("EnemyPositions")
@onready var player_detector : Area2D = get_node("PlayerDetector")

func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count() 
	#親ノードのEnemyPositionsを取得し、その親の子ノードをカウントしている

func _on_enemy_killed() -> void: #キルカウント
	num_enemies -= 1 
	if num_enemies == 0:
		_open_doors() #敵の数が0になったらドアが開く

func _open_doors() -> void:
	for door in door_container.get_children():
		door.open() #親ノードのDoorsを参照して子ノードを取得

func _close_entrance() -> void: #出れないようにする処理
	for entry_position in entrance.get_children(): #entranceのすべての子ノードに対して反復処理をする
		print(tilemap.local_to_map(entry_position.position))
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position), 0, Vector2i(2,6)) #配置するタイルを指定する
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 2, Vector2i.ZERO) #どこに配置をするかを決める

func _spawn_enemies() -> void: #敵の出現の処理
	for enemy_position in enemy_positions_container.get_children(): #enemy_positions_containerのすべての子ノードに対して反復処理をする(数える)
		var enemy: CharacterBody2D
		if randi() % 2 == 0:
			enemy = ENEMY_SCENES.FLYING_CREATURE.instantiate()
		else:
			enemy = ENEMY_SCENES.GOBLIN.instantiate()
		enemy.position = enemy_position.position #また、敵の位置は子ノードの位置に準ずる
		call_deferred("add_child", enemy)
		
		#この三行は敵が出てきた時に出る爆発のエフェクト --ここから
		var spawn_exprosion : AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_exprosion.position = enemy_position.position
		call_deferred("add_child", spawn_exprosion)
		# --ここまで

#プレイヤーがPlayerDetectorという当たり判定に入った時の処理
func _on_PlayerDetector_body_entered(_body : CharacterBody2D) -> void:
	player_detector.queue_free() #まずplayer_detectorはきえる
	if num_enemies > 0: #敵の数が0より大きかったらドアを閉じて敵をスポーンさせる
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()
