extends AnimationTree

var playback : AnimationNodeStateMachinePlayback
var player

func _ready():
	player = $".."
	playback = get("parameters/playback")
	active = true
	pass

func _process(_delta):
	if player.motion.x == 0 and player.is_on_floor():
		playback.travel("Idle")
	elif player.motion.x != 0 and player.is_on_floor():
		playback.travel("Run")
