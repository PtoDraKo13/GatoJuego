extends CharacterBody2D

@onready var sfx_jump = $SFX_Jump
@onready var collider = $CollisionShape2D
@onready var timer: Timer = $Timer

var SPEED = 110.0
const JUMP_VELOCITY = -300.0
var BULLET_SPEED = 400
var DIRECTION
var ATTACKING = false
var IS_RUNNING = false

@onready var bullet = preload("res://scenes/projectile.tscn")
var instBullet

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func shoot(delta):
	instBullet = bullet.instantiate()
	get_parent().add_child(instBullet)
	instBullet.body_position = animated_sprite.flip_h
	instBullet.global_position = collider.global_position

func _on_timer_timeout():
	ATTACKING = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()
	
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
		DIRECTION = false
	elif direction < 0:
		animated_sprite.flip_h = true
		DIRECTION = true

# Handle bullet
	if Input.is_action_just_pressed("attack"):
		ATTACKING = true
		shoot(delta)
		

	#Play animations
	if !ATTACKING:
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
	else:
		animated_sprite.play("attack")
		timer.start()
		_on_timer_timeout()
		
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
