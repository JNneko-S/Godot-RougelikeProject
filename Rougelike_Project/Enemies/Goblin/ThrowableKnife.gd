extends Hitbox

var enemy_exited: bool = false
var direction : Vector2 = Vector2.ZERO
var Knife_speed : int = 0

#3つのパラメータ（ナイフの初期位置、方向、速度）を指定
#ナイフをインスタンス化するときにこの関数を呼び出す。
func launch(initial_position : Vector2, dir: Vector2, speed: int) -> void:
	#ナイフを初期位置に移動させる
	position = initial_position
	
	#パラメータdirectionで変数directionとknockback_directionを設定
	direction = dir
	knockback_direction = dir
	
	#knife_speed変数にspeedパラメータをセット
	Knife_speed = speed
	
	#シーンを 方向角 + πの1/4回転させる
	rotation += dir.angle() + PI/4

func _physics_process(delta : float) -> void:
	position += direction * Knife_speed * delta

func _on_ThrowableKnife_body_exited(_body : Node2D) -> void:
	if not enemy_exited:
		enemy_exited = true
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)

func _collide(body: Node2D) -> void:
	if enemy_exited:
		if body != null:
			body.take_damage(damage, knockback_direction, knockback_force)
		queue_free()
