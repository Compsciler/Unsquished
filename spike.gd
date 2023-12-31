extends Node2D
class_name Spike

@export var warning_time = 1.0
@export var damage_time = 1.0
@onready var sprite = $PrepSprite1/PrepSprite2
@onready var spike_sprite = $PrepSprite1/AnimatedSprite2D

@onready var warning = $SpikeWarning
@onready var appear = $SpikeAppear

var player = null

var is_damaging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.show()
#	var tween = create_tween()
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.6), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.2), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.6), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 0.2), 0.5)
#	tween.tween_property(sprite, "modulate", Color(1,0, 0, 1.0), 0.2)
	
	warning.play()
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	warning.play()
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	warning.play()
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	warning.play()
	await get_tree().create_timer(warning_time * 0.33).timeout
	sprite.hide()
	await get_tree().create_timer(warning_time * 0.17).timeout
	sprite.show()
	appear.play()
	
	is_damaging = true
	$Area2D.monitoring = true
	sprite.modulate.a = 1.0
	spike_sprite.show()
	spike_sprite.play("default")
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
