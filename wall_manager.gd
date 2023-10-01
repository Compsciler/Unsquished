extends Node2D

@onready var all_walls = get_tree().get_nodes_in_group("wall")

# Invincibility settings
@export var offset_start = 0.0
@export var rate_start = 5.0
@export var rate_min = 3.5
@export var rate_increase = -0.1
@export var invincibility_period = 3.0
var rate = rate_start

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = rate_start + offset_start
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_random_wall_invinicble():
	var wall = all_walls[randi() % len(all_walls)]
	wall.make_invincible(invincibility_period)

func _on_timer_timeout():
	make_random_wall_invinicble()
	rate += rate_increase
	rate = max(rate, rate_min)
	timer.wait_time = rate
	# print(timer.wait_time)
