extends Control

@onready var label = $Label

@onready var score_text = $Scores
@onready var loot_locker = $LootLocker

@onready var submit_button = $Submit
@onready var name_input = $TextEdit



func _ready():
	if not GameManager.won:
		label.text = "Score: " + str(GameManager.score)
	else:
		var base = GameManager.score
		var bonus = GameManager.supers_unused * 10
		GameManager.score = base + bonus
		label.text = "Score: " + str(base) + " + \n 10 x " + str(GameManager.supers_unused) + " (LEFTOVER SPACE) = " + str(GameManager.score)
	
#
#func _unhandled_key_input(event):
#	if event.is_pressed():
#		GameManager.score = 0
#		get_tree().change_scene_to_file("res://node_2d.tscn")
#
#


func _on_button_pressed():
	submit_button.disabled = true
	if name_input.text == "":
		name_input.text = "[NAMELESS]"
	loot_locker._change_player_name(name_input.text)
	await loot_locker.player_name_changed
	loot_locker._upload_score(GameManager.score)
	await loot_locker.player_score_uploaded
	loot_locker._get_leaderboards()


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
		var name = pad_left(entry["player"]["name"].substr(0, 12), 12)
		var score = pad_left(str(entry["score"]), 5)
		result += "%s  %s  %s\n" % [rank, name, score]
	
	return result

func _on_loot_locker_leaderboard_collected():
	score_text.text = get_top_n_scores(loot_locker.items, 16)



func _on_back_pressed():
	GameManager.score = 0
	GameManager.raw_score = 0
	GameManager.supers_unused = 3
	get_tree().change_scene_to_file("res://title_scene.tscn")
