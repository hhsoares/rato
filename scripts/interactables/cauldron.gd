extends StaticBody2D
class_name Cauldron

@export var inv: Inv

@export var fill_rate: float = 40.0
var mix_percent: float = 0.0

@export_node_path("StateMachine") var state_machine_path: NodePath
@onready var state_machine: StateMachine = get_node(state_machine_path) as StateMachine
@onready var interactable: Area2D = $Interactable
var session_active := false

func _ready() -> void:
	add_to_group("cauldron")
	interactable.interact = _on_interact

func _on_interact(body: Player) -> bool:
	var held := body.inv.first_item()
	if held:
		if inv.insert_single(held):
			body.inv.remove_one(held)
			print("deposited:", held.name)
			return session_active
		if inv.is_full():
			print("cauldron full")
			return session_active

	# no deposit -> toggle session
	print("cauldron interacted")
	session_active = !session_active
	return session_active

func mix_step(delta: float) -> float:
	mix_percent = min(100.0, mix_percent + fill_rate * delta)
	return mix_percent

func is_ready() -> bool:
	return mix_percent >= 100.0

func reset() -> void:
	mix_percent = 0.0
