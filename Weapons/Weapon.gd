@icon("res://Arts/heroes/knight/weapon_sword_1.png")

extends Node2D
class_name Weapon

@export var on_floor : bool = false
@export var id : int

@export_enum("Common","Rare","Epic","Legendary")
var Rarity : String = "Common"

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")
@onready var ChargeParticle : GPUParticles2D = get_node("Node2D/Sprite/ChargeParticles")
@onready var hitbox : Area2D = get_node("Node2D/Sprite/Hitbox")
@onready var weapon : Node2D = $"."
@onready var PlayerDetector : Area2D = get_node("PlayerDetector")

var tween : Tween

func _ready() -> void:
	if not on_floor:
		PlayerDetector.set_collision_mask_value(1, false)
		PlayerDetector.set_collision_mask_value(2, false)

func get_input() -> void: #入力の受付
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("charge") #攻撃の入力した後にアニメーション再生
	elif Input.is_action_just_released("UI_Attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif ChargeParticle.emitting:
			animation_player.play("strong_attack")
	elif Input.is_action_just_pressed("UI_ABILITY") and animation_player.has_animation("active_ability") and not is_busy():
		animation_player.play("active_ability")

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

func _on_player_detector_body_entered(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		PlayerDetector.set_collision_mask_value(1, true)
		PlayerDetector.set_collision_mask_value(2, true)
		_body.pick_up_weapon(self)
		on_floor = false
		position = Vector2.ZERO
		animation_player.play("RESET")
	else:
		if tween:
			tween.kill()
			PlayerDetector.set_collision_mask_value(2, true)
		

func interpolate_pos(initial_pos : Vector2, final_pos:Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_Tween_tween_complated)
	PlayerDetector.set_collision_mask_value(1,true)

func _on_Tween_tween_complated() -> void:
	PlayerDetector.set_collision_mask_value(2,true)
	on_floor = true

func get_texture() -> Texture:
	return get_node("Node2D/Sprite").texture
