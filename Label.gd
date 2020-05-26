extends Label

func _process(delta):
	text = String($cd.get_wait_time())
