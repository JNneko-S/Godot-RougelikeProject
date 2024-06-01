extends Character 

## ノードを取得して格納している変数
@onready var sword : Node2D = get_node("Sword")
@onready var sword_hitbox : Area2D = get_node("Sword/Node2D/SwordSprite/Hitbox")
@onready var SwordAnimation : AnimationPlayer = sword.get_node("SwordAnimation")

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
		SwordAnimation.play("attack") #攻撃の入力した後にアニメーション再生
