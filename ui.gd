extends CanvasLayer

@onready var charges = $TextureRect/HBoxContainer.get_children()

@onready var space_label = $Label

var filled_texture = preload("res://Art/charge.png")
var depleted_texture = preload("res://Art/charge_depleted.png")

func _on_timer_timeout():
	GameManager.score += 1
	$TextureRect/Score.text = str(GameManager.score)


func _on_character_body_2d_charge_change(charge):
	for i in range(charge):
		charges[i].texture = filled_texture
	for i in range(charge, len(charges)):
		charges[i].texture = depleted_texture
	space_label.show()
	space_label.scale = Vector2(1.165, 1.165)
	space_label.modulate = Color(1.0,1.0,1.0,1.0)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(space_label, "scale", Vector2(2.3, 2.3), 1)
	tween.tween_property(space_label, "modulate", Color(1.0, 1.0, 1.0, 0.2), 1)
	tween.set_parallel(false)
	tween.tween_callback(func(): space_label.hide())
	
