extends TextureProgress

func _on_health_update(health, amount):
	self.value = health
