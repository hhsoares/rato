extends StaticBody2D

@onready var interactable : Area2D = $Interactable

@export var ingredient: String
@export var ingredient_icon: Texture2D 

@export var ingredient_quantity : Label
@export var max_quantity : int = 3


var current_quantity : int

func _ready() -> void:
	interactable.interact = _on_interact
	
	current_quantity = max_quantity
	
func _on_interact():
	if player.holding_item == null and current_quantity >= 0:
		
