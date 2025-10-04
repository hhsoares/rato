extends StaticBody2D

var mix_percent: int = 0
@export var increment: int = 10

@onready var interactable: Area2D = $Interactable

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	print("cauldron interacted")
	mix_cauldron()

func mix_cauldron() -> void:
	mix_percent += increment
	mix_percent = clamp(mix_percent, 0, 100)
	print("Mix:", mix_percent, "%")
