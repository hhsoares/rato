extends StaticBody2D
class_name RadishBox

@onready var interactable: Area2D = $Interactable
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact() -> bool:
	print("radish box interacted")
	return true
