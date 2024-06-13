extends Character 

enum {UP,DOWN}

const DUST_SCENE : PackedScene = preload("res://Character/dust.tscn")

var current_weapon : Node2D

## ノードを取得して格納している変数
@onready var parent : Node2D = get_parent()
@onready var weapons : Node2D = get_node("Weapons")
@onready var dust_position : Marker2D = get_node("DustPoisiton")

func _ready() -> void:
	_restor_previous_state()

func _restor_previous_state() -> void:
	self.hp = SavedData.hp
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
	current_weapon = weapons.get_child(SavedData.equipped_weapon_index)
	current_weapon.show()
	

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
		elif Input.is_action_just_pressed("UI_throw") and current_weapon.get_index() != 0:
			_drop_weapon()
			
	current_weapon.get_input()

func _switch_weapon(direction : int) -> void:
	var _prev_index: int = current_weapon.get_index()
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
	SavedData.equipped_weapon_index = index
	
func pick_up_weapon(weapon : Weapon) -> void: ### 武器を拾う処理
	if weapon.on_floor:
		SavedData.weapons.append(weapon.duplicate())
		var _prev_index : int = SavedData.equipped_weapon_index
		var new_index : int = weapons.get_child_count()
		SavedData.equipped_weapon_index = new_index
		weapon.get_parent().call_deferred("remove_child",weapon) 
		weapons.call_deferred("add_child", weapon)
		weapon.set_deferred("owner", weapons)
		#親ノードから武器を削除して、Player/Weaponsノードに追加し、所有者をWeaponsノードに設定する
		#call_deferredとset_deferredを使わないとエラーが出る(Godot3時点での話なので今はわからない)
		
		current_weapon.hide()
		print("隠れる")
		current_weapon.cancel_attack()
		print("攻撃をキャンセル")
		current_weapon = weapon
		print("武器を獲得")
		#現在の武器を隠し、最後に現在の武器を拾った武器に設定する。
	
func _drop_weapon() -> void:
	SavedData.weapons.remove_at(current_weapon.get_index() - 1)
	var weapon_to_drop : Node2D = current_weapon
	_switch_weapon(UP)
	weapons.call_deferred("remove_child", weapon_to_drop) 
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()
	
	var throw_dir : Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
	
	print("武器を捨てる")
###

func cancel_attack() -> void:
	current_weapon.cancel_attack()

func spawn_dust() -> void:
	var Dust : Sprite2D = DUST_SCENE.instantiate()
	Dust.position = dust_position.global_position
	parent.get_child(get_index() - 1).add_sibling(Dust)
