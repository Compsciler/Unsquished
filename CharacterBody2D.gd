extends CharacterBody2D

const SPEED = 300.0

var punch_walls = []
var hurt_walls = []
var player_facing = Vector2.RIGHT
@onready var audio_player = $AudioStreamPlayer2D
@onready var sprite = $Icon

var squished = false

func _physics_process(delta):
	var horizontal_direction = Input.get_axis("left", "right")
	var vertical_direction = Input.get_axis("up", "down")
	var direction = Vector2(horizontal_direction, vertical_direction).normalized();
	if direction.is_zero_approx():
		if not (player_facing.x == 0 or player_facing.y == 0):
			player_facing.y = 0
			player_facing = player_facing.normalized()
	else:
		player_facing = direction
	# print(player_facing)
	
	# Punch
	if Input.is_action_just_pressed("hit"):
		print("got input")
		var retract_walls = []
		for wall in punch_walls:
			print("some punch walls")
			var dot_prod = -wall.normal.dot(player_facing)
			if dot_prod > 0:
				retract_walls.append(wall)
		for wall in retract_walls:
			print("some walls")
			wall.retract(1.0 / len(retract_walls))
	
	
	if Input.is_action_just_pressed("super"):
		print("super")
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()


func _on_punch_area_2d_body_entered(body):
	if body is Wall:
		punch_walls.append(body)

func _on_punch_area_2d_body_exited(body):
	if body is Wall:
		punch_walls.erase(body)

func _on_hurt_area_2d_body_entered(body):
	if body is Wall:
		hurt_walls.append(body)
	if not squished and is_squished():
		audio_player.play()
		sprite.hide()
		squished = true

func _on_hurt_area_2d_body_exited(body):
	if body is Wall:
		hurt_walls.erase(body)

func is_squished():
	var hurt_wall_names = []
	for hurt_wall in hurt_walls:
		hurt_wall_names.append(hurt_wall.name)
	# TODO: change to use normals
	return (hurt_wall_names.has("LeftWall") and hurt_wall_names.has("RightWall")) or \
		(hurt_wall_names.has("UpWall") and hurt_wall_names.has("DownWall"))

