extends Area2D

@onready var Collision_shape : CollisionShape2D = get_node("CollisionShape")

func _on_body_entered(player : CharacterBody2D) -> void:
	Collision_shape.set_deferred("disabled", true)
	player.hp += 1
	SavedData.hp += 1
	
	var tween : Tween = create_tween().set_parallel() #この後に追加されたTweenは同時実行される
	modulate.a = 1
	tween.tween_property(self, "modulate:a", 0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y - 16, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_Tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
