extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"),preload("res://Rooms/SpawnRoom1.tscn")]
const INTERMEDIATE_ROOMS: Array = [
	preload("res://Rooms/Room0.tscn"),
	preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn"),
	preload("res://Rooms/Room3.tscn"),
	preload("res://Rooms/Room4.tscn"),
	preload("res://Rooms/Room5.tscn")
]
const SLIME_BOSS_SCENE : PackedScene = preload("res://Rooms/BossRoom1.tscn")
const SPECIAL_ROOMS: Array = [preload("res://Rooms/SpecialRoom0.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]

const TILE_SIZE : int = 16

@export var num_levels: int = 5

#そのシーンにいたら取得をする
@onready var player : CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	SavedData.num_floor += 1
	if SavedData.num_floor == 3:
		num_levels = 3
	_spawn_rooms()
	#ready関数で最初に部屋を生成する

func _spawn_rooms() -> void:
	var previous_room : Node2D
	var special_room_spawned : bool = false
	
	for i in num_levels: #生成する部屋の数だけ繰り返す (default:5)
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else: #1よりも上だと敵スポーン部屋が生成する
				if SavedData.num_floor == 3:
					room = SLIME_BOSS_SCENE.instantiate()
				else:
					if ((randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned)):
						room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
						special_room_spawned = true
					else:
						room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2 = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2
			
			#廊下生成をするためのタイル生成準備
			var corridor_height : int = randi() % 5 + 2 #廊下の長さは6~1までの長さで生成される
			for y in corridor_height: #for文でカウントされた数だけタイルを生成する(for文で反復処理)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(-2, -y), 0, Vector2(4,5))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(-1, -y), 0, Vector2(2,1))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(0, -y), 0, Vector2(2,1))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(1, -y), 0, Vector2(3,5))
			
			## 廊下生成に使用する変数(いじるな)## 
			var room_tilemap : TileMap = room.get_node("TileMap")
			var Multiplied_yTile = room_tilemap.get_used_rect().size.y * TILE_SIZE
			var VertPlusTile = (1 + corridor_height) * TILE_SIZE
			## ## ## ## ## ## ## ## ## ## ##
			
			#廊下生成
			room.position = previous_room_door.global_position + Vector2.UP * Multiplied_yTile + Vector2.UP * VertPlusTile + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE
			
		add_child(room)
		previous_room = room
