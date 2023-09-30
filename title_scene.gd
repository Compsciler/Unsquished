extends Control

func _unhandled_key_input(event):
	if event.is_pressed():
		get_tree().change_scene_to_file("res://node_2d.tscn")

		
