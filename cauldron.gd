extends StaticBody2D

var mix_percent: float = 0.0
@export var fill_rate: float = 40.0
@onready var interactable: Area2D = $Interactable

var is_mixing: bool = false

func _ready() -> void:
	interactable.interact = _on_interact
	interactable.body_exited.connect(func(_b): is_mixing = false)

func _process(delta: float) -> void:
	if is_mixing and Input.is_action_pressed("mix"):
		mix_percent = min(100.0, mix_percent + fill_rate * delta)
		print("Mix:", roundi(mix_percent), "%")

	if mix_percent >= 100.0:
		_exit_interaction()

func _on_interact() -> bool:
	is_mixing = not is_mixing
	if is_mixing:
		print("cauldron interacted")
	print("Mix:", mix_percent, "%")
	return is_mixing

func _exit_interaction() -> void:
	is_mixing = false
	interactable.interact = func() -> bool:
		return false
	interactable.interact.call()
