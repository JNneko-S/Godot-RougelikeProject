extends Node2D

const SPAWN_EXPLOSION_SCENE : PackedScene = preload("res://Enemies/spawn_explosion.tscn")

const ENEMY_SCENES : Dictionary = {
	"FLYING_CREATURE" : preload("res://Enemies/Flying_creature.tscn")
}

@export var num_enemies : int 

@onready var tilemap : TileMap = get_node("TileMap2")
@onready var entrance : Node2D = get_node("Entrance")
@onready var door_container : Node2D = get_node("Doors")
@onready var enemy_positions_container : Node2D = get_node("EnemyPositions")
@onready var player_detector : Area2D = get_node("PlayerDetector")

func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		print(tilemap.local_to_map(entry_position.position))
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position), 0, Vector2i(2,6))
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 2, Vector2i.ZERO)

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy : CharacterBody2D = ENEMY_SCENES.FLYING_CREATURE.instantiate()
		enemy.global_position = enemy_position.global_position
		call_deferred("add_child", enemy)
		
		var spawn_exprosion : AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_exprosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_exprosion)

func _on_PlayerDetector_body_entered(_body : CharacterBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()
