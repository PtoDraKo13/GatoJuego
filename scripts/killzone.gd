extends Area2D

func _on_body_entered(body):
	if body.has_method("dead"):
		body.dead()
