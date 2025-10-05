extends Control

@onready var soup_label : Label = $PaperSheet/VBoxContainer/SoupLabel
@onready var ingredients_box : HBoxContainer = $PaperSheet/VBoxContainer/IngredientsBox
@onready var order_timer : ProgressBar = $PaperSheet/VBoxContainer/OrderTimer

var order_data : Dictionary   # Order data {data: recipe, time_remaining: float}
var max_time : float          # Initial time for the order

# Map ingredient names to textures
var ingredient_icons = {
	"Carrot": preload("res://assets/ingredients/cenoura.png"),
	"Potato": preload("res://assets/ingredients/batata.png"),
	"Radish": preload("res://assets/ingredients/rabanete.png"),
	"Meat": preload("res://icon.svg")
}

func set_order(order: Dictionary) -> void:
	order_data = order
	max_time = order["data"]["time_limit"]
	print_debug("Soup Label: ", soup_label)
	# Update soup name
	soup_label.text = order["data"]["name"]
	
	# Clear previous ingredient images
	for child in ingredients_box.get_children():
		child.queue_free()
	
	# Add ingredient images dynamically
	for ing in order["data"]["ingredients"]:
		var img = TextureRect.new()
		if ingredient_icons.has(ing):
			img.texture = ingredient_icons[ing]
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		img.size_flags_vertical = Control.SIZE_EXPAND_FILL
		ingredients_box.add_child(img)
	
	# Configure progress bar
	order_timer.max_value = max_time
	order_timer.value = order["time_remaining"]

func _process(delta: float) -> void:
	if order_data:
		order_data["time_remaining"] -= delta
		if order_data["time_remaining"] < 0:
			order_data["time_remaining"] = 0
		order_timer.value = order_data["time_remaining"]
		
		# Change progress bar color based on remaining time
		if order_timer.value < max_time * 0.3:
			order_timer.add_color_override("fg", Color.RED)
		elif order_timer.value < max_time * 0.6:
			order_timer.add_color_override("fg", Color.YELLOW)
		else:
			order_timer.add_color_override("fg", Color.GREEN)
