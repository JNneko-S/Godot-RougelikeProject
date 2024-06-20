extends Room

@onready var BG_player : AudioStreamPlayer = get_tree().current_scene.get_node("AudioStreamPlayer")
@onready var Boss_player : AudioStreamPlayer = get_node("BossAudioPlayer")
@onready var Boss_Positions_contrainer = get_node("BossPositions")

const BOSS_SCENES : Dictionary = {
	"SlimeBoss" : preload("res://Enemies/BOSS/Slime/slime_boss.tscn")
}

func _ready() -> void:
	## ここに super() でオーバーライドされる前の処理ができる
	#super()を使う場合は num_enemies += Boss_Positions...
	num_enemies = Boss_Positions_contrainer.get_child_count() 

func _on_player_detector_body_entered(body):
	BG_player.stop()
	Boss_player.playing = true

func stoped_music():
	if num_enemies == 0:
		Boss_player.playing = false
		BG_player.playing = true

func _spawn_enemies() -> void:
	for boss_positions in Boss_Positions_contrainer.get_children():
		var enemy: CharacterBody2D
		
		enemy = BOSS_SCENES["SlimeBoss"].instantiate()
		num_enemies = 15
		
		enemy.position = boss_positions.position #また、敵の位置は子ノードの位置に準ずる
		self.call_deferred("add_child", enemy)
		
		#この三行は敵が出てきた時に出る爆発のエフェクト --ここから
		var spawn_exprosion : AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_exprosion.position = boss_positions.position
		call_deferred("add_child", spawn_exprosion)
