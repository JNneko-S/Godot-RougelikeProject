@icon("res://Arts/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Character

const FRICTION : float = 0.15

@export var max_hp: int = 2
@export var hp : int = 2: set = set_hp
signal  hp_changed(new_hp)

@export var accerelation : int = 20
@export var max_speed : int = 60

@onready var Animated_Sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var state_machine : Node = get_node("FiniteStateMachine")

var move_direction : Vector2 = Vector2.ZERO

func _physics_process(_delta : float) -> void:
	move_and_slide()
	velocity = velocity
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)

func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * accerelation

func take_damage(dam : int, dir : Vector2, force : int) -> void:
	self.hp -= dam
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force* 2
	

func set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	emit_signal("hp_changed", hp)
