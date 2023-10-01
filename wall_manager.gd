extends Node2D

@onready var all_walls = get_tree().get_nodes_in_group("wall")

# Invincibility settings
@export var offset_start = 0.0
@export var rate_start = 3.47826
@export var rate_min = 3.47826
@export var rate_increase = 0.0
@export var invincibility_period = 2.608695
var rate = rate_start

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = offset_start
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# print(timer.wait_time)
	pass

func make_random_wall_invinicble():
	var wall = all_walls[randi() % len(all_walls)]
	wall.make_invincible(invincibility_period)

func _on_timer_timeout():
	make_random_wall_invinicble()
	rate += rate_increase
	rate = max(rate, rate_min)
	timer.wait_time = rate
	timer.start()
	print(timer.wait_time, " ", rate)
