extends State

@onready var player: Player = get_parent().get_parent()

func physics_update(delta: float) -> void:
	if player.input_direction != Vector2.ZERO:
		state_machine.change_state("move")
	
	player.move(0, 15, delta)
	player.move_and_slide()
