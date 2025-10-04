extends State

@onready var player: Player = get_parent().get_parent()

func physics_update(delta: float) -> void:
	if player.input_direction == Vector2.ZERO:
		state_machine.change_state("idle")
	
	player.move(400, 20, delta)
	player.move_and_slide()
