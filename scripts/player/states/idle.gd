extends State

@onready var player: Player = get_parent().get_parent()

func physics_update(delta: float) -> void:
	#if Input.is_action_just_pressed("mix"):
		#state_machine.change_state("mix")
		#return

	if player.input_direction != Vector2.ZERO:
		state_machine.change_state("move")

	player.move(0, 15, delta)
	player.move_and_slide()
