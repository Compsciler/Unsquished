extends Node2D

@export var GRID_SIZE = 18
var tile_size = 540.0 / GRID_SIZE
var center = 540.0 * 0.5
var laser = preload("res://laser.tscn")

@export var spawn_offset_start = 0.0
@export var spawn_rate_start = 5.0
@export var spawn_rate_min = 2.5
@export var spawn_rate_increase = -0.1
var spawn_rate = spawn_rate_start

@onready var timer = $Timer

@onready var player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = spawn_offset_start
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_random():
	# TODO: choose row and col in bounds
	var idx = randi() % GRID_SIZE
	var is_row = randi() % 2 == 0
	spawn(idx, is_row)

func spawn(idx, is_row):
	var pos
	var rot
	if is_row:
		pos = Vector2(center, (idx + 0.5) * tile_size)
		rot = 0
	else:
		pos = Vector2((idx + 0.5) * tile_size, center)
		rot = PI / 2
	var laser_inst = laser.instantiate()
	add_child(laser_inst)
	laser_inst.position = pos
	laser_inst.rotation = rot

func spawn_on_player(offset = 0):
	var is_row = randi() % 2 == 0
	var pos
	var rot
	if is_row:
		pos = Vector2(center, player.position.y + offset)
		rot = 0
	else:
		pos = Vector2(player.position.x + offset, center)
		rot = PI / 2
	var laser_inst = laser.instantiate()
	add_child(laser_inst)
	laser_inst.position = pos
	laser_inst.rotation = rot

func _on_timer_timeout():
	spawn_on_player()
	spawn_rate += spawn_rate_increase
	spawn_rate = max(spawn_rate, spawn_rate_min)
	timer.wait_time = spawn_rate
	timer.start()
