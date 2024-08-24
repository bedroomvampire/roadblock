extends Area3D

func _on_body_entered(body):
	if body.has_node("Health"):
		body.health.health = 0
