extends Control

@onready var label = $Label

func _ready():
	label.text = "Your final score is " + str(GameManager.score)

func _unhandled_key_input(event):
	if event.is_pressed():
		GameManager.score = 0
		get_tree().change_scene_to_file("res://node_2d.tscn")

		
