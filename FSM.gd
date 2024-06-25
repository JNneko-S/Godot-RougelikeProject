extends Node
class_name FiniteStateMachine

var states: Dictionary = {} #状態名（str）をキーにして、それに対応する状態のindex（int）を値として持つ
var previous_state: int = -1 #前の状態
var state: int = -1: set = set_state #現在の状態

@onready var parent: CharacterBody2D = get_parent() #Characterクラスの親ノード
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer") #親ノード内のアニメーションプレイヤー

func _physics_process(delta: float) -> void:
	if state != -1: #有効な状態(-1でない）場合、 _state_logic(delta) を呼び出して状態に応じた処理を行う
		_state_logic(delta)
		var transition: int = _get_transition()
		if transition != -1:
			set_state(transition)

#サブクラスで処理を実装・各状態ごとのロジックを実装するためのメソッド
func _state_logic(_delta: float) -> void:
	pass

#サブクラスで処理を実装・状態遷移を決定するロジックを実装するためのメソッド
func _get_transition() -> int:
	return -1 #デフォルトでは遷移がないことを示す-1を返す。

#新しい状態をstates(Dictionary)に追加
func _add_state(new_state: String) -> void:
	states[new_state] = states.size()

#状態を変更するメソッド
func set_state(new_state: int) -> void:
	_exit_state(state) #現在の状態から遷移する時に呼び出す
	previous_state = state #previous_state を更新し、新しい状態に設定
	state = new_state
	_enter_state(previous_state, state) #新しい状態に遷移する時に呼び出す

#サブクラスで処理を実装・新しい状態に遷移した際に実行される処理を実装するためのメソッド
func _enter_state(_previous_state: int, _new_state: int) -> void:
	pass

#現在の状態から遷移する際に実行される処理を実装するためのメソッド
func _exit_state(_state_exited: int) -> void:
	pass
