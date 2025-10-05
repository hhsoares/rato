# mix.gd
extends State
@onready var player: Player = get_parent().get_parent()

func enter() -> void:
	print("Mix: enter")

func exit() -> void:
	print("Mix: exit")

func physics_update(_delta: float) -> void:
	pass
