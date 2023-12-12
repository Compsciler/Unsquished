extends AnimatableBody2D
class_name Wall

@export var speed = 35.0
@export var speed_max = 45.0
@export var speed_increase_start_offset = 60.0
@export var speed_increase_rate = 0.25
@onready var normal = $CollisionShape2D.get_shape().normal;
@export var retract_strength = 100

var time = 0

var retracting:bool = false
@onready var target_position = position
@onready var starting_position = position

var is_invincible = false

@onready var sprite = $Sprite2D
@onready var base_color = modulate
@export var invincible_color = Color(1, 1, 0)

@onready var timer = get_node("../UpWall/Timer")

@export var beat_step = true

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 0.4347826
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	return
	if not beat_step:
		target_position += normal * speed * delta
		position = position.lerp(target_position, 0.8)
	if time >= speed_increase_start_offset:
		speed += speed_increase_rate * delta
		speed = min(speed, speed_max)
	time += delta

func _on_timer_timeout():
#	Engine.time_scale = 10
#	return
	if beat_step:
		print(speed)
		position += normal * speed * timer.wait_time


func retract(amount: float):
	if beat_step:
		position -= normal * retract_strength * amount
	else:
		target_position -= normal * retract_strength * amount


func make_invincible(duration):
	is_invincible = true
	modulate = invincible_color
	z_index = 0
	await get_tree().create_timer(duration).timeout
	is_invincible = false
	modulate = base_color
	z_index = 1

func get_supered(player_pos):
	await get_tree().create_timer(0.075).timeout
	modulate = base_color
	is_invincible = false
