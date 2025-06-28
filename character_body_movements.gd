extends CharacterBody2D

const SPEED = 150.0

@onready var monk = $Monk
@onready var aura_anim = $HealAura

var is_healing: bool = false

func _physics_process(delta: float) -> void:
	if is_healing:
		velocity = Vector2.ZERO
		return
		
	aura_anim.visible = false

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

	if velocity.length() > 0:
		monk.play("Run")
	else:
		monk.play("Idle")

	if velocity.x != 0:
		monk.flip_h = velocity.x < 0
		aura_anim.flip_h = velocity.x < 0

	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_accept") and not is_healing:
		start_healing()

func start_healing():
	is_healing = true
	velocity = Vector2.ZERO
	monk.play("Heal")
	aura_anim.visible = true
	aura_anim.play("Heal_Aura")

	# Connect only once
	if not monk.animation_finished.is_connected(_on_heal_finished):
		monk.animation_finished.connect(_on_heal_finished)

func _on_heal_finished():
	if monk.animation == "Heal":
		aura_anim.visible = false
		is_healing = false
