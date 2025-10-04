extends Control

@export var order_timer : ProgressBar

@onready var soup_label : Label = $PaperSheet/VBoxContainer/SoupLabel
@onready var ingredient_image : TextureRect = $PaperSheet/VBoxContainer/IngredientImage

var order_data : Dictionary   # dados do pedido {dados: receita, tempo_restante: float}
var max_time : float          # tempo inicial do pedido

func set_pedido(order: Dictionary):
	order_data = order
	max_time = order["dados"]["tempo_limite"]
	
	# Atualizar nome
	soup_label.text = order["dados"]["nome"]
	
