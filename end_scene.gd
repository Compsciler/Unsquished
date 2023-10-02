extends Control

@onready var label = $Label

@onready var score_text = $Scores
@onready var loot_locker = $LootLocker

func _ready():
	label.text = "Your final score is " + str(GameManager.score)
	
#
#func _unhandled_key_input(event):
#	if event.is_pressed():
#		GameManager.score = 0
#		get_tree().change_scene_to_file("res://node_2d.tscn")
#
#


func _on_button_pressed():
	pass # Replace with function body.

func pad_left(input: String, length: int, char: String = " ") -> String:
	var result = input
	while result.length() < length:
		result = char + result
	return result

func pad_right(input: String, length: int, char: String = " ") -> String:
	var result = input
	while result.length() < length:
		result += char
	return result

func get_top_n_scores(data: Array, n: int) -> String:
	var result = "RANK          NAME  SCORE\n"
	
	for i in range(min(n, data.size())):
		var entry = data[i]
		var rank = pad_left(str(entry["rank"]), 4)
		var name = pad_left(entry["player"]["public_uid"].substr(0, 12), 12)
		var score = pad_left(str(entry["score"]), 5)
		result += "%s  %s  %s\n" % [rank, name, score]
	
	return result




func _on_loot_locker_leaderboard_collected():
	score_text.text = get_top_n_scores(loot_locker.items, 15)
