extends Node

# Array with all possible soups
var soups = [
	{
		"name": "Carrot Soup",
		"time_limit": 20.0,
		"ingredients": ["Carrot", "Meat"]
	},
	{
		"name": "Potato Soup",
		"time_limit": 20.0,
		"ingredients": ["Potato", "Meat"]
	},
	{
		"name": "Radish Soup",
		"time_limit": 20.0,
		"ingredients": ["Radish", "Meat"]
	}
]

# Preload OrderUI scene
var order_ui_scene = preload("res://prefabs/order.tscn")

# Active orders
var active_orders = []

# Interval between generating new orders
@export var spawn_interval: float = 10.0

# Container in the HUD where OrderUIs are added
@onready var orders_container : HBoxContainer = $"../UI/HBoxContainer"

func _ready() -> void:
	# Start a timer to spawn orders periodically
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_spawn_order)

func _on_spawn_order() -> void:
	generate_order()

func generate_order() -> void:
	# Pick a random soup
	var soup = soups.pick_random()
	
	# Create order data
	var order = {
		"data": soup,
		"time_remaining": soup["time_limit"]
	}
	
	# Add to active orders
	active_orders.append(order)
	
	# Instantiate OrderUI for this order
	var order_ui = order_ui_scene.instantiate()
	order_ui.set_order(order)
	orders_container.add_child(order_ui)

func validate_delivery(player_plate: Array) -> bool:
	# Check if the delivered ingredients match any active order
	for order in active_orders:
		var required = order["data"]["ingredients"].duplicate()
		required.sort()
		
		var delivered = player_plate.duplicate()
		delivered.sort()
		
		if delivered == required:
			complete_order(order)
			return true
	return false

func complete_order(order: Dictionary) -> void:
	# Remove order from active orders
	active_orders.erase(order)
	# Optionally, you can remove the corresponding OrderUI from HUD
	for child in orders_container.get_children():
		if child.order_data == order:
			child.queue_free()
			break
