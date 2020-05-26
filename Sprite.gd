extends Sprite

var mouse

func _physics_process(delta):
	mouse = get_local_mouse_position()
	rotation += mouse.angle()
