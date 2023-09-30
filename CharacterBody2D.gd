extends CharacterBody2D


const SPEED = 300.0

var walls = []
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
	print(player_facing)
	
	
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
