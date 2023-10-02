extends Node2D

var time = 0.0
var signpost_idx = 0

var beat = 0.4347826
var times = [beat * 0, beat * 80, beat * 144, beat * 256]
@onready var signpost_audios = [
	$Signpost0AudioStreamPlayer,
	$Signpost1AudioStreamPlayer,
	$Signpost2AudioStreamPlayer,
	$Signpost3AudioStreamPlayer,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if signpost_idx < len(times) and time >= times[signpost_idx]:
		signpost_audios[signpost_idx].play()
		# Change tile sprites here
		signpost_idx += 1
	time += delta
