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

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = spawn_rate_start + spawn_offset_start

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

func _on_timer_timeout():
	spawn_random()
	spawn_rate += spawn_rate_increase
	spawn_rate = max(spawn_rate, spawn_rate_min)
	timer.wait_time = spawn_rate
