
extends Node2D

@onready var interact_label: Label = $InteractLabel
@onready var player: Player = get_parent() as Player

var current_interactions: Array = []
var can_interact: bool = true
var active_target: Area2D = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact and current_interactions.size() > 0:
		var target: Area2D = current_interactions[0]
		can_interact = false
		interact_label.hide()

		# Start or stop the target. The callable returns whether it remains active.
		var active: bool = target.interact.call()

		if active:
			active_target = target
			player.controls_enabled = false
		else:
			if active_target == target:
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
