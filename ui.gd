extends CanvasLayer

@onready var charges = $TextureRect/HBoxContainer.get_children()

@onready var space_label = $Label

@export var increment_score = false

@onready var stage_labels = [
	$GROUND,
	$STRATOSPHERE,
	$EXOSPHERE,
	$OUTER_SPACE
]

var filled_texture = preload("res://Art/charge.png")
var depleted_texture = preload("res://Art/charge_depleted.png")

var val = 0.0

var abberation_strength: float = 1.0: 
	set(value):
		$ColorRect.get_material().set_shader_parameter("r_displacement", Vector2(value, 0.0))
		$ColorRect.get_material().set_shader_parameter("b_displacement", Vector2(-value, 0.0))

func _on_timer_timeout():
	if (increment_score):
		GameManager.score += 1
		GameManager.raw_score += 1
		$TextureRect/Score.text = str(GameManager.score)
		if GameManager.raw_score >= 100:
			GameManager.won = true
			await get_tree().create_timer(0.05).timeout
			get_tree().change_scene_to_file("res://end_scene.tscn")
		val += 1.39130434783
		$TextureRect/TextureRect2/TextureProgressBar.value = val


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
	
func _process(delta):
	$TextureRect/Score.text = str(GameManager.score)

func _on_character_body_2d_hit_wall():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "abberation_strength", 6.0, 0.5)
	tween.tween_property(self, "abberation_strength", 1.0, 0.5)


func tween_label(label):
	label.show()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "scale", Vector2(2.3, 2.3), 1)
	tween.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.2), 1)
	tween.set_parallel(false)
	tween.tween_callback(func(): label.hide())
	

func _on_ground_stage_change(stageidx):
	tween_label(stage_labels[stageidx])
