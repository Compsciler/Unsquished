extends CharacterBody2D
class_name Player

const SPEED = 300.0

var punch_walls = []
var hurt_walls = []
var player_facing = Vector2.RIGHT
@onready var audio_player = $AudioStreamPlayer2D
@onready var visuals = $Visuals
@onready var body_sprite = $Visuals/BodySprite
@onready var fist_sprite = $Visuals/FistSprite

@onready var all_walls = get_tree().get_nodes_in_group("wall")

var squished = false

var in_cooldown = false

@export var super_count = 3

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
	
	body_sprite.flip_h = player_facing.x < 0
	fist_sprite.flip_h = player_facing.x < 0
	
	if player_facing.x != 0:
		if direction != Vector2.ZERO:
			body_sprite.play("right_run")
			fist_sprite.play("right_run_normal")
		else:
			body_sprite.play("right_idle")
			fist_sprite.play("right_idle_normal")
	elif player_facing.y > 0:
		if direction != Vector2.ZERO:
			body_sprite.play("front_run")
			fist_sprite.play("front_run_normal")
		else:
			body_sprite.play("front_idle")
			fist_sprite.play("front_idle_normal")
	elif player_facing.y < 0:
		if direction != Vector2.ZERO:
			body_sprite.play("back_run")
			fist_sprite.play("back_run_normal")
		else:
			body_sprite.play("back_idle")
			fist_sprite.play("back_idle_normal")
		
	
	# Punch
	if Input.is_action_just_pressed("hit"):
		if !in_cooldown:
			in_cooldown = true
			var retract_walls = []
			for wall in punch_walls:
				var dot_prod = -wall.normal.dot(player_facing)
				if dot_prod > 0:
					retract_walls.append(wall)
			for wall in retract_walls:
				wall.retract(1.0 / len(retract_walls))
			await get_tree().create_timer(0.2).timeout
			in_cooldown = false
	
	if Input.is_action_just_pressed("super") and super_count > 0:
		for wall in all_walls:
			wall.retract(1.5)
		
		var all_spikes_and_lasers = get_tree().get_nodes_in_group("trap")
		for spike_or_laser in all_spikes_and_lasers:
			spike_or_laser.get_supered(position)
		
		super_count -= 1
		
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()

func stun(stun_source):
	pass


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
		visuals.hide()
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

