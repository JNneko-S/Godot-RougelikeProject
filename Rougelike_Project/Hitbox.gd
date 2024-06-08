extends Area2D
class_name Hitbox

@export var damage : int = 1
@export var knockback_force : int = 300

@onready var collision_shape : CollisionShape2D = get_child(0)
@onready var timer :Timer = Timer.new()

var knockback_direction : Vector2 = Vector2.ZERO
var body_inside : bool = false

func _init() -> void:
	var __ = connect("body_entered", Callable(self, "_on_body_entered"))
	__ = connect("body_exited", Callable(self, "_on_body_exited"))

func _ready():
	assert(collision_shape != null)
	timer.wait_time	 = 1
	add_child(timer)

func _on_body_entered(body : Node2D) -> void:
	if body is CharacterBody2D:
		body_inside = true
		timer.start()
		while body_inside:
			_collide(body) 
			await timer.timeout

func _on_body_exited(_body : Node2D) -> void:
	if _body is CharacterBody2D:
		body_inside = false
		timer.stop()

#ヒットボックスがタイルマップのコリジョンシェイプに入るとnullになるか
#bodyがtake_damage関数を持っていないかをチェックする関数
func _collide(body: Node2D) -> void:
	if body == null or not body.has_method("take_damage"):
		queue_free() #ヒットボックスを解放する
	else: #そうでなければtake_damage関数を呼び出す
		body.take_damage(damage, knockback_direction, knockback_force) #body enteredシグナルのコード
	
