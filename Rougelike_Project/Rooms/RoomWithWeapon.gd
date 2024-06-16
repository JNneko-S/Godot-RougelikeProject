extends Room

const  WEAPONS : Array = [preload("res://Weapons/Hammer.tscn"),preload("res://Weapons/Spear.tscn")]

@onready var Weaponpos : Marker2D = get_node("WeaponPos")

func _ready() -> void:
	var weapon: Node2D = WEAPONS[randi() % WEAPONS.size()].instantiate()
	weapon.position = Weaponpos.position
	weapon.on_floor = true
	add_child(weapon)
