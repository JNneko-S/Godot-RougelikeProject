extends Enemy #親Character→Enemyから継承されている

@onready var hitbox : Area2D = get_node("Hitbox")

func _process(_delta : float) -> void:
	hitbox.knockback_direction = velocity.normalized()
