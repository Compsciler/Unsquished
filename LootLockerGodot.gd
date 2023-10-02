extends Node

# Use this game API key if you want to test it with a functioning leaderboard
# "987dbd0b9e5eb3749072acc47a210996eea9feb0"
var game_API_key = "987dbd0b9e5eb3749072acc47a210996eea9feb0"  # "dev_44530aaddb0b4294bc56bfe3f7c515c8"
var development_mode = true
var leaderboard_key = "leaderboardKey"
var session_token = ""
var score = 0

# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()
var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()

var items

signal leaderboard_collected

func _ready():
    _authentication_request()

func _process(_delta):
    if(Input.is_action_just_pressed("ui_up")):
        score += 1
        print("CurrentScore:"+str(score))
    
    if(Input.is_action_just_pressed("ui_down")):
        score -= 1
        print("CurrentScore:"+str(score))
    
    # Upload score when pressing enter
    if(Input.is_action_just_pressed("ui_accept")):
        _upload_score(score)
    
    # Get score when pressing spacebar
    if(Input.is_action_just_pressed("ui_select")):
        _get_leaderboards()


func _authentication_request():
    # Check if a player session has been saved
    var player_session_exists = false
    var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE_READ)
    var player_identifier = file.get_as_text()
    print("")
    file.close()
    if(player_identifier.length() > 1):
        player_session_exists = true
        
    ## Convert data to json string:
    var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }
    
    # If a player session already exists, send with the player identifier
    if(player_session_exists == true):
        data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": true }
    
    # Add 'Content-Type' header:
    var headers = ["Content-Type: application/json"]
    
    # Create a HTTPRequest node for authentication
    auth_http = HTTPRequest.new()
    add_child(auth_http)
    auth_http.request_completed.connect(_on_authentication_request_completed)
    # Send request
    auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.new().stringify(data))
    # Print what we're sending, for debugging purposes:
    print(data)


func _on_authentication_request_completed(result, response_code, headers, body):
    
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    # Save player_identifier to file
    var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)

    file.store_string(json.data["player_identifier"])
    file.close()
    
    # Save session_token to memory
    session_token = json.data["session_token"]
    
    # Clear node
    auth_http.queue_free()
    # Get leaderboards
    _get_leaderboards()


func _get_leaderboards():
    print("Getting leaderboards")
    var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
    var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
    
    # Create a request node for getting the highscore
    leaderboard_http = HTTPRequest.new()
    add_child(leaderboard_http)
    leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
    # Send request
    leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")


func _on_leaderboard_request_completed(result, response_code, headers, body):
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    
    # Print data
    print(json.data)
    
    # Formatting as a leaderboard
    var leaderboardFormatted = ""
    for n in json.data["items"].size():
        leaderboardFormatted += str(json.data["items"][n]["rank"])+str(". ")
        leaderboardFormatted += str(json.data["items"][n]["player"]["id"])+str(" - ")
        leaderboardFormatted += str(json.data["items"][n]["score"])+str("\n")
    
    # Print the formatted leaderboard to the console
    print(leaderboardFormatted)
    
    # Clear node
    leaderboard_http.queue_free()
    items = json.data["items"]
    emit_signal("leaderboard_collected")


func _upload_score(score):
    var data = { "score": str(score) }
    var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
    submit_score_http = HTTPRequest.new()
    add_child(submit_score_http)
    submit_score_http.request_completed.connect(_on_upload_score_request_completed)
    # Send request
    submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.new().stringify(data))
    # Print what we're sending, for debugging purposes:
    print(data)

func _change_player_name():
    print("Changing player name")
    
    # use this variable for setting the name of the player
    var player_name = "newName"
    
    var data = { "name": str(player_name) }
    var url =  "https://api.lootlocker.io/game/player/name"
    var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
    
    # Create a request node for getting the highscore
    set_name_http = HTTPRequest.new()
    add_child(set_name_http)
    set_name_http.request_completed.connect(_on_player_set_name_request_completed)
    # Send request
    set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.new().stringify(data))
    
func _on_player_set_name_request_completed(result, response_code, headers, body):
    var json = JSON.new().parse(body.get_string_from_utf8())
    
    # Print data
    print(json.result)
    set_name_http.queue_free()

func _get_player_name():
    print("Getting player name")
    var url = "https://api.lootlocker.io/game/player/name"
    var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
    
    # Create a request node for getting the highscore
    get_name_http = HTTPRequest.new()
    add_child(get_name_http)
    get_name_http.request_completed.connect(_on_player_get_name_request_completed)
    # Send request
    get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")
    
func _on_player_get_name_request_completed(result, response_code, headers, body):
    var json = JSON.new().parse(body.get_string_from_utf8())
    
    # Print data
    print(json.result)
    # Print player name
    print(json.result.name)

func _on_upload_score_request_completed(result, response_code, headers, body) :
    var json = JSON.new().parse(body.get_string_from_utf8())
    
    # Print data
    print(json.result)
    
    # Clear node
    submit_score_http.queue_free()
    
