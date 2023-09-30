extends CharacterBody2D

const SPEED = 300.0

var hurt_walls = []
var player_facing = Vector2.RIGHT

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
	
	
	if Input.is_action_just_pressed("hit"):
		print("hit")
	if Input.is_action_just_pressed("super"):
		print("super")
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("wall"):
		pass


func _on_hurt_area_2d_body_entered(body):
	if body is Wall:
		hurt_walls.append(body)
	print("Is squished: %s" % [is_squished()])

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
