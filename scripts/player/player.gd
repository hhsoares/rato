class_name Player extends CharacterBody2D

var input_direction = Vector2.ZERO
var controls_enabled: bool = true

@export var inv: Inv

func _physics_process(_delta: float) -> void:
	if controls_enabled:
		input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	else:
		input_direction = Vector2.ZERO

func move(speed: float, acceleration: float, delta: float) -> void:
	if not controls_enabled:
		velocity = Vector2.ZERO
		return
	velocity = lerp(velocity, input_direction * speed, acceleration * delta)
