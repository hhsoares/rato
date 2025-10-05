extends StaticBody2D
class_name PotatoBox

@onready var interactable: Area2D = $Interactable

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact() -> bool:
	print("potato box interacted")
	return true
