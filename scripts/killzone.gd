extends Area2D

@onready var sfx_dead = $SFX_Dead
@onready var timer = $Timer

func _on_body_entered(body):
	print("You died lmao")
	Engine.time_scale = 0.7
	body.get_node("CollisionShape2D").queue_free()
	sfx_dead.play()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
