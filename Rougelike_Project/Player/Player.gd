extends Character 

var SlashSE1 = preload("res://Music/SE/10_Battle_SFX/03_Claw_03.wav")
var throwSE1 = preload("res://Music/SE/10_Battle_SFX/51_Flee_02.wav")
var ChargeSE = preload("res://Music/SE/8_Atk_Magic_SFX/04_Fire_explosion_04_medium.wav")
var CycloneSE = preload("res://Music/SE/10_Battle_SFX/35_Miss_Evade_02.wav")

## ノードを取得して格納している変数
@onready var sword : Node2D = get_node("Sword")
@onready var sword_hitbox : Area2D = get_node("Sword/Node2D/SwordSprite/Hitbox")
@onready var SwordAnimation : AnimationPlayer = sword.get_node("SwordAnimation")
@onready var charge_particle : GPUParticles2D = get_node("Sword/Node2D/SwordSprite/ChargeParticles")
@onready var AudioPlayer : AudioStreamPlayer = get_node("AudioSEPlayer")

func _process(_delta : float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	# マウスカーソルが右画面に寄ったらスプライトが反転しない
	if mouse_direction.x > 0 and Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = false
	# マウスカーソルが左画面に寄ったらスプライトが反転する
	elif mouse_direction.x < 0 and not Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = true
		
	sword.rotation = mouse_direction.angle() #剣の回転はマウスカーソルの移動に準ずる
	sword_hitbox.knockback_direction = mouse_direction #剣の当たり判定も同じく
	if sword.scale.y == 1 and mouse_direction.x < 0: #マウス座標が0よりも下で剣の大きさが1
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0: #マウス座標が0よりも上で剣の大きさが-1
		sword.scale.y = 1
	
func get_input() -> void: #入力の受付
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis("UI_Left","UI_Right") #横移動の入力
	move_direction.y = Input.get_axis("UI_Up","UI_Back") #縦移動の入力

	if Input.is_action_just_pressed("UI_Attack") and not SwordAnimation.is_playing():
		SwordAnimation.play("charge") #攻撃の入力した後にアニメーション再生
		_play_sound(3)
		AudioPlayer.playing = true
	elif Input.is_action_just_released("UI_Attack"):
		if SwordAnimation.is_playing() and SwordAnimation.current_animation == "charge":
			SwordAnimation.play("attack")
			_play_sound(1)
			AudioPlayer.playing = true
		elif charge_particle.emitting:
			SwordAnimation.play("Cyclone_attack")
			_play_sound(4)
		
func is_busy() -> bool:
	if SwordAnimation.is_playing() or charge_particle.emitting:
		return true
	return false

func cancel_attack() -> void:
	SwordAnimation.play("RESET")

func _play_sound(se) -> void:
	AudioPlayer.stop()
	match  se:
		1:
			AudioPlayer.stream = SlashSE1
		2:
			AudioPlayer.stream = throwSE1
		3:
			AudioPlayer.stream = ChargeSE
		4:
			AudioPlayer.stream = CycloneSE
