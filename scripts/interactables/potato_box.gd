extends StaticBody2D
class_name PotatoBox

@onready var interactable: Area2D = $Interactable
@export var item: InvItem

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact(body: Node) -> bool:
	if body is Player:
		print("potato box interacted")
		body.collect(item)
		return true
	return false
