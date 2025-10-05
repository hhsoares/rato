extends Node2D  # Ou "Control", dependendo do tipo de nó raiz

@onready var viewport = get_viewport()

func _ready():
	var base_resolution = Vector2(1920, 1080)  # Resolução final desejada
	var sprite_size = 32  # Tamanho do sprite (32x32 pixels)
	
	# Calcula o fator de escala baseado na resolução e no tamanho do sprite
	var scale_factor = min(base_resolution.x / (sprite_size * 60), base_resolution.y / (sprite_size * 34))
	
	# Aplica a transformação de escala no canvas do viewport
	viewport.canvas_transform = Transform2D(scale_factor, Vector2())
