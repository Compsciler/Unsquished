extends Node2D

@export var GRID_SIZE = 9
var tile_size = 540.0 / GRID_SIZE
var spike = preload("res://spike.tscn")

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
	var row = randi() % GRID_SIZE
	var col = randi() % GRID_SIZE
	spawn(row, col)

func spawn(row, col):
	var pos = Vector2((row + 0.5) * tile_size, (col + 0.5) * tile_size)
	var spike_inst = spike.instantiate()
	add_child(spike_inst)
	spike_inst.position = pos
	
func spawn_on_player(offset_x = 0, offset_y = 0):
	var pos = Vector2(player.position.x + offset_x, player.position.y + offset_y)
	var spike_inst = spike.instantiate()
	add_child(spike_inst)
	spike_inst.position = pos

func _on_timer_timeout():
	var offset_x = 0
	for i in range(5):
		offset_x += randi() % 41 - 20
	var offset_y = 0
	for i in range(5):
		offset_y += randi() % 41 - 20
	spawn_on_player(offset_x, offset_y)
	
	spawn_rate += spawn_rate_increase
	spawn_rate = max(spawn_rate, spawn_rate_min)
	timer.wait_time = spawn_rate
	print("FLOOR:", spawn_rate)
	timer.start()
