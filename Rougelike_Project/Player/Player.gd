extends Character

@onready var sword : Node2D = get_node("Sword")
@onready var sword_hitbox : Area2D = get_node("Sword/Node2D/SwordSprite/Hitbox")
@onready var SwordAnimation : AnimationPlayer = sword.get_node("SwordAnimation")

func _process(_delta : float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = false
	elif mouse_direction.x < 0 and not Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = true
		
	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
	
func get_input() -> void:
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis("UI_Left","UI_Right")
	move_direction.y = Input.get_axis("UI_Up","UI_Back")

	if Input.is_action_just_pressed("UI_Attack") and not SwordAnimation.is_playing():
		SwordAnimation.play("attack")
