@icon("res://Arts/heroes/knight/weapon_sword_1.png")

extends Node2D
class_name Weapon

var SlashSE1 = preload("res://Music/SE/10_Battle_SFX/03_Claw_03.wav")
var throwSE1 = preload("res://Music/SE/10_Battle_SFX/51_Flee_02.wav")
var ChargeSE = preload("res://Music/SE/8_Atk_Magic_SFX/04_Fire_explosion_04_medium.wav")
var CycloneSE = preload("res://Music/SE/10_Battle_SFX/35_Miss_Evade_02.wav")

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")
@onready var ChargeParticle : GPUParticles2D = get_node("Node2D/Sprite/ChargeParticles")
@onready var hitbox : Area2D = get_node("Node2D/Sprite/Hitbox")
@onready var AudioPlayer : AudioStreamPlayer = get_node("AudioSEPlayer")

func get_input() -> void: #入力の受付
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("charge") #攻撃の入力した後にアニメーション再生
		_play_sound(3)
		AudioPlayer.playing = true
	elif Input.is_action_just_released("UI_Attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
			_play_sound(1)
			AudioPlayer.playing = true
		elif ChargeParticle.emitting:
			animation_player.play("Cyclone_attack")
			_play_sound(4)

func move(mouse_direction : Vector2) -> void:
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		rotation = mouse_direction.angle() #回転はマウスカーソルの移動に準ずる
		hitbox.knockback_direction = mouse_direction #当たり判定も同じく
		if scale.y == 1 and mouse_direction.x < 0: #マウス座標が0よりも下で大きさが1
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0: #マウス座標が0よりも上で大きさが-1
			scale.y = 1

func cancel_attack() -> void:
	animation_player.play("RESET")

func is_busy() -> bool:
	if animation_player.is_playing() or ChargeParticle.emitting:
		return true
	return false

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
