extends CharacterBody2D

@export var area: NodePath  # NodePath for the Area2D that defines movement bounds
@export var speed: float = 100.0  # Movement speed
var destination: Vector2  # Current movement target

@onready var anim_player: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var area_node = get_node(area)
	destination = gerar_ponto_aleatorio_na_area(area_node)

func _physics_process(delta: float) -> void:
	mover_ate_destino(destination, delta)

func gerar_ponto_aleatorio_na_area(area_node: Area2D) -> Vector2:
	var shape = area_node.get_node("CollisionShape2D").shape

	if shape is RectangleShape2D:
		var rect = shape.extents
		var point = Vector2(
			randf_range(-rect.x, rect.x),
			randf_range(-rect.y, rect.y)
		)
		return area_node.global_position + point

	elif shape is CircleShape2D:
		var radius = shape.radius
		var angle = randf_range(0, 2 * PI)
		var distance = randf_range(0, radius)
		var point = Vector2(cos(angle), sin(angle)) * distance
		return area_node.global_position + point

	return area_node.global_position


func mover_ate_destino(target: Vector2, _delta: float) -> void:
	var direction = target - global_position
	var distance = direction.length()

	if distance > 5:
		velocity = direction.normalized() * speed
		move_and_slide()

		if not anim_player.is_playing():
			anim_player.play("running")
	else:
		anim_player.play("idle")
		velocity = Vector2.ZERO
