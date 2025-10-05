
extends Node2D

@onready var interact_label: Label = $InteractLabel
@onready var player: Player = get_parent() as Player

var current_interactions: Array = []
var can_interact: bool = true
var active_target: Area2D = null


func _input(event: InputEvent) -> void:
	if not (event.is_action_pressed("interact") and can_interact):
		return

	# If a session is active, pressing interact should end it and exit Mix.
	if active_target:
		can_interact = false
		var still_active: bool = active_target.interact.call(player)  # should return false
		active_target = null
		player.controls_enabled = true

		var sm := player.get_node("StateMachine") as StateMachine
		if sm and sm.current_state and sm.current_state.name.to_lower() == "mix":
			sm.change_state("idle")

		can_interact = true
		return

	# No active session: start with nearest target
	if current_interactions.size() == 0:
		return

	var target: Area2D = current_interactions[0]
	can_interact = false
	interact_label.hide()

	var active: bool = target.interact.call(player)

	if active:
		active_target = target
		#player.controls_enabled = false

		# Enter Mix only if not already in Mix
		if target.get_parent() is Cauldron:
			var sm := player.get_node("StateMachine") as StateMachine
			if sm and (not sm.current_state or sm.current_state.name.to_lower() != "mix"):
				sm.change_state("mix")
	else:
		# safety
		active_target = null
		player.controls_enabled = true

	can_interact = true

func _process(_delta: float) -> void:
	if current_interactions.size() > 0 and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable and active_target == null:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
		else:
			interact_label.hide()
	else:
		interact_label.hide()

func _sort_by_nearest(a, b):
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

func _on_interact_range_area_entered(area: Area2D) -> void:
	current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
	# If leaving the active target, unlock and clear
	if active_target == area:
		active_target = null
		player.controls_enabled = true
