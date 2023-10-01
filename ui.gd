extends CanvasLayer

@onready var charges = $TextureRect/HBoxContainer.get_children()

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
