extends State
@onready var player: Player = get_parent().get_parent()
var cauldron: Cauldron

func enter() -> void:
	cauldron = get_tree().get_first_node_in_group("cauldron") as Cauldron
	print("Mix: enter")

func exit() -> void:
	print("Mix: exit")

func physics_update(delta: float) -> void:
	if not cauldron:
		return
	if not cauldron.session_active:
		return
	if not Input.is_action_pressed("mix"):
		return
	
	var p := cauldron.mix_step(delta)
	print("Mix:", int(p), "%")
