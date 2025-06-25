extends CharacterBody2D

const SPEED = 150.0

@onready var animated_sprite = $AnimatedSprite2D

var is_healing: bool = false

func _physics_process(delta: float) -> void:
	# If healing, stop everything and wait until animation finishes
	if is_healing:
		velocity = Vector2.ZERO
		return

	# Handle movement input
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Play animation based on movement
	if velocity.length() > 0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	# Flip based on direction
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0

	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_accept") and not is_healing:
		start_healing()

func start_healing():
	is_healing = true
	velocity = Vector2.ZERO
	animated_sprite.play("Heal")

	# Connect animation finished signal (only once)
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	if animated_sprite.animation == "Heal":
		is_healing = false
