extends Node2D

@export var WANDER_RANGE : int = 100

@onready var start_position = global_position
@onready var target_position = global_position

@onready var wander_timer = $WanderTimer

func get_time_left():
	return wander_timer.time_left

func start_wander_timer(duration):
	wander_timer.start(duration)

func _on_wander_timer_timeout():
	var target_vector = Vector2(randf_range(-WANDER_RANGE,WANDER_RANGE),randf_range(-WANDER_RANGE,WANDER_RANGE))
	target_position = start_position + target_vector
