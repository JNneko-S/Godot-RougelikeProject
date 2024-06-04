@icon("res://Arts/heroes/knight/weapon_sword_1.png")

extends Node2D
class_name Weapon

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")
@onready var ChargeParticle : GPUParticles2D = get_node("Node2D/Sprite/ChargeParticles")
@onready var hitbox : Area2D = get_node("Node2D/Sprite/Hitbox")
@onready var weapon : Node2D = $"."

func get_input() -> void: #入力の受付
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("charge") #攻撃の入力した後にアニメーション再生
	elif Input.is_action_just_released("UI_Attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif ChargeParticle.emitting:
			animation_player.play("strong_attack")

func move(mouse_direction : Vector2) -> void:
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		weapon.rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction
		if weapon.scale.y == 1 and mouse_direction.x < 0:
			weapon.scale.y = -1
		elif weapon.scale.y == -1 and mouse_direction.x > 0:
			weapon.scale.y = 1

func cancel_attack() -> void:
	animation_player.play("RESET")

func is_busy() -> bool:
	if animation_player.is_playing() or ChargeParticle.emitting:
		return true
	return false
