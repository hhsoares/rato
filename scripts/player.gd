class_name Player extends CharacterBody2D

var input_direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	input_direction = Input.get_vector("left", "right", "up", "down").normalized()

func move(speed: float, acceleration: float, delta: float) -> void:
	velocity = lerp(velocity, input_direction * speed, acceleration * delta)
