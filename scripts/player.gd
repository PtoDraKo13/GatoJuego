extends CharacterBody2D


var SPEED = 110.0
const JUMP_VELOCITY = -300.0
var IS_RUNNING = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle running
	if Input.is_action_just_pressed("run") and is_on_floor():
		IS_RUNNING = true
		SPEED = 150.0
	elif Input.is_action_just_released("run"):
		IS_RUNNING = false
		SPEED = 110.0
	
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

	# Flip the sprite
	if direction > 0 :
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif direction != 0:
			if IS_RUNNING:
				animated_sprite.play("run")
			else:
				animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
