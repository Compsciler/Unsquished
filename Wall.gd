extends AnimatableBody2D
class_name Wall

@export var speed = 35
@export var speed_max = 45
@export var speed_increase_rate = 0.25
@onready var normal = $CollisionShape2D.get_shape().normal;
@export var retract_strength = 100

var retracting:bool = false
@onready var target_position = position
@onready var starting_position = position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	target_position += normal * speed * delta
	position = position.lerp(target_position, 0.8)


func retract(amount: float):
	target_position -= normal * retract_strength * amount
	
