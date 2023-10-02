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

@onready var signpost_bgs = [
	$GrassTilemap,
	$Clouds,
	$Space1,
	$Space2
]

signal stage_change


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if signpost_idx < len(times) and time >= times[signpost_idx]:
		signpost_audios[signpost_idx].play()
		for i in range(len(signpost_bgs)):
			if i == signpost_idx:
				signpost_bgs[i].show()
			else:
				signpost_bgs[i].hide()
		signpost_idx += 1
		emit_signal("stage_change", signpost_idx-1)
	time += delta
