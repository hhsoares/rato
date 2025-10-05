extends State

@onready var player: Player = get_parent().get_parent()
@onready var anim = $"../../AnimatedSprite2D"

func physics_update(delta: float) -> void:
	anim.play("walk_forward")
	if player.input_direction == Vector2.ZERO:
		state_machine.change_state("idle")
	
	player.move(200, 15, delta)
	player.move_and_slide()
