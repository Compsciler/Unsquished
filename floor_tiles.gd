extends Node2D

@export var GRID_SIZE = 9
@onready var tile_size = 540.0 / GRID_SIZE
var spike = preload("res://spike.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn(2, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn(row, col):
	var pos = Vector2((row + 0.5) * tile_size, (col + 0.5) * tile_size)
	var spike_inst = spike.instantiate()
	add_child(spike_inst)
	spike_inst.position = pos
