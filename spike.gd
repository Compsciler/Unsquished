extends Node2D

@export var warning_time = 2.0
@onready var sprite = $Sprite2D

var is_damaging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.modulate = Color(1, 1, 1, 0.2)
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
	sprite.modulate = Color.WHITE


func _on_area_2d_body_entered(body):
	if body is Player and is_damaging:
		body.stun()


func _on_area_2d_body_exited(body):
	pass # Replace with function body.
