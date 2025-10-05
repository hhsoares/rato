# cauldron.gd
extends StaticBody2D
class_name Cauldron

@export var inv: Inv
@export var fill_rate: float = 40.0

var mix_percent := 0.0
var session_active := false

@export_node_path("StateMachine") var state_machine_path: NodePath
@onready var state_machine: StateMachine = get_node(state_machine_path) as StateMachine
@onready var interactable: Area2D = $Interactable
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# visual state
var _base_state: StringName = &"empty"   # empty|carrot|radish|potato|spoiled
var _mixing := false

func _ready() -> void:
	add_to_group("cauldron")
	interactable.interact = _on_interact
	_update_anim()

func _on_interact(body: Player) -> bool:
	var held := body.inv.first_item()
	if held:
		if inv.insert_single(held):
			body.inv.remove_one(held)
			_apply_deposit(held)
			return session_active
		if inv.is_full():
			print("cauldron full")
			return session_active

	# no deposit -> toggle session
	session_active = !session_active
	return session_active

func _apply_deposit(item) -> void:
	var kind := _classify_item(item) # carrot|radish|potato|spoiled
	if kind == &"spoiled":
		_base_state = &"spoiled"  # spoiled overrides everything
	elif _base_state == &"empty":
		_base_state = kind        # first valid ingredient locks base
	_update_anim()

func _classify_item(item) -> StringName:
	var n := str(item.name).to_lower()
	if n == "carrot": return &"carrot"
	if n == "radish": return &"radish"
	if n == "potato": return &"potato"
	return &"spoiled"

func set_mixing(active: bool) -> void:
	if _mixing == active:
		return
	_mixing = active
	_update_anim()

func _update_anim() -> void:
	var name := String(_base_state)
	if _mixing and _base_state != &"empty":
		name += "_mixing"
	anim.play(name)

func mix_step(delta: float) -> float:
	mix_percent = min(100.0, mix_percent + fill_rate * delta)
	return mix_percent

func is_ready() -> bool:
	return mix_percent >= 100.0

func reset() -> void:
	mix_percent = 0.0
	_base_state = &"empty"
	_mixing = false
	_update_anim()
