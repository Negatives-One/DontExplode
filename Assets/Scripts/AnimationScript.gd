extends AnimationTree

var playback : AnimationNodeStateMachinePlayback
var player

func _ready():
	player = $".."
	playback = get("parameters/playback")
	active = true
	pass

func _process(_delta):
	if player.velocity.x == 0:
		playback.travel("Idle")
	elif player.velocity.x != 0:
		playback.travel("Run")
