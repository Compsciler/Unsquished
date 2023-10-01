extends Node2D

class_name Spike

@export var warning_time = 2.0
@export var damage_time = 1.0
@onready var sprite = $Sprite2D

var player = null

var is_damaging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.modulate.a = 0.2
#	var tween = create_tween()
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.6), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.2), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.6), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.2), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 1.0), 0.2)
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	
	is_damaging = true
	$Area2D.monitoring = true
	sprite.modulate.a = 1.0
	await get_tree().create_timer(damage_time).timeout
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		body.stun()


func _on_area_2d_body_exited(body):
	pass
		
		

func get_supered(player_pos):
	await get_tree().create_timer(0.125).timeout
	is_damaging = false
	queue_free()
