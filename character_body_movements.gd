extends CharacterBody2D

const SPEED = 150.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	# Set horizontal velocity
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Set vertical velocity
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Handle animation & flipping
	if velocity.length() > 0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	# Flip sprite depending on direction
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0

	move_and_slide()
