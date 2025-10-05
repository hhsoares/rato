# mix.gd
extends State
@onready var player: Player = get_parent().get_parent()
var cauldron: Cauldron

func enter() -> void:
	cauldron = get_tree().get_first_node_in_group("cauldron") as Cauldron
	print("Mix: enter")

func exit() -> void:
	if cauldron:
		cauldron.set_mixing(false)
	print("Mix: exit")

func physics_update(delta: float) -> void:
	if not cauldron or not cauldron.session_active:
		if cauldron: cauldron.set_mixing(false)
		return

	var pressing := Input.is_action_pressed("mix")
	cauldron.set_mixing(pressing)
	if not pressing:
		return

	var p := cauldron.mix_step(delta)
	print("Mix:", int(p), "%")
