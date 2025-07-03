extends CharacterBody2D

const SPEED = 100.0

@export var player: CharacterBody2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var this: AnimatedSprite2D = $AnimatedSprite2D 

var start_position: Vector2
var is_chasing: bool = false

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		getPosition()
		var dir = (agent.get_next_path_position() - global_position).normalized()
		velocity = dir * SPEED
		if dir.x != 0:
			this.flip_h = dir.x < 0
		
	if velocity.length() > 0:
		this.play("Run")
	else:
		this.play("Idle")
	move_and_slide()

func getPosition() -> void:
	if is_chasing and player:
		agent.target_position = player.global_position
	else:
		agent.target_position = start_position

func _on_area_2d_body_entered(body: Node) -> void:
	if body == player:
		is_chasing = true
		getPosition()

func _on_area_2d_body_exited(body: Node) -> void:
	if body == player:
		is_chasing = false
