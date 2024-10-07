extends Area2D

@onready var sfx_dead = $SFX_Dead
@onready var timer = $Timer

func _on_body_entered(body):
	print("You died lmao")
	sfx_dead.play()
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
