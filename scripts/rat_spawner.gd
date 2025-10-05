extends Node2D

# Exporta a cena do carro (arraste a cena no Inspector)
@export var rat: PackedScene
@export var time: float = 1.0
@export var max_rats : int = 3

var spawn_timer: Timer
var current_rats : int

func _ready():
	current_rats = 0
	# Cria o Timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = time
	spawn_timer.one_shot = true  # dispara apenas uma vez por ciclo
	add_child(spawn_timer)
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	
	# Inicia o timer
	spawn_timer.start()

func _on_spawn_timer_timeout():
	for child in get_children():
		if child is Node2D and child.name == "Rat":
			current_rats += 1
	if current_rats < max_rats:
		if rat:
			var instance = rat.instantiate()
			instance.position = Vector2(0, 0)
			add_child(instance)
		else:
			push_error("Variável 'rat' está nula! Arraste a cena no Inspector ou corrija o preload.")
	
	spawn_timer.wait_time = time
	spawn_timer.start()
