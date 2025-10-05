extends StaticBody2D
class_name Hole

@onready var interactable: Area2D = $Interactable
@export var item: InvItem

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact(body: Player) -> bool:
	if body.collect(item):
		print("collected:", item.name)
		#queue_free()   # or disable the box
		return true    # success
	print("inventory full")
	return false      # nothing collected
