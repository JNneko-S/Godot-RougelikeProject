extends Character 

enum {UP,DOWN}

var current_weapon : Node2D

## ノードを取得して格納している変数
@onready var weapons : Node2D = get_node("Weapons")

func _ready() -> void:
	current_weapon = weapons.get_child(0)

func _process(_delta : float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	# マウスカーソルが右画面に寄ったらスプライトが反転しない
	if mouse_direction.x > 0 and Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = false
	# マウスカーソルが左画面に寄ったらスプライトが反転する
	elif mouse_direction.x < 0 and not Animated_Sprite.flip_h:
		Animated_Sprite.flip_h = true
	
	current_weapon.move(mouse_direction)
	
func get_input() -> void: #入力の受付
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis("UI_Left","UI_Right") #横移動の入力
	move_direction.y = Input.get_axis("UI_Up","UI_Back") #縦移動の入力
	
	if not current_weapon.is_busy(): #is_busyはWeapon.gd内にある処理
		if Input.is_action_just_released("UI_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("UI_next_weapon"):
			_switch_weapon(DOWN)
	
	current_weapon.get_input()

func _switch_weapon(direction : int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index : int = current_weapon.get_index()
	if direction == UP: #方向が上ならindexを-1する
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else: #方向が上ではないならindexを+1する
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	
func pick_up_weapon(weapon : Weapon) -> void: ### 武器を拾う処理
	if weapon.on_floor:
		weapon.get_parent().call_deferred("remove_child",weapon) 
		weapons.call_deferred("add_child", weapon)
		weapon.set_deferred("owner", weapons)
		#親ノードから武器を削除して、Player/Weaponsノードに追加し、所有者をWeaponsノードに設定する
		#call_deferredとset_deferredを使わないとエラーが出る(Godot3時点での話なので今はわからない)
		
		current_weapon.hide()
		current_weapon = weapon
		current_weapon.show()
		#現在の武器を隠し、最後に現在の武器を拾った武器に設定する。
		### ここの上記の処理が何回も繰り返されている。
	
	
func cancel_attack() -> void:
	current_weapon.cancel_attack()


