extends CharacterBody2D
class_name Rat

@export var area: NodePath  # Area2D that defines the movement bounds
@export var speed: float = 100.0  # Rat movement speed
@export var wait_time: float = 1.5  # Time the rat waits before choosing a new destination

@onready var interactable: Area2D = $Interactable
@export var item: InvItem

var destination: Vector2  # Current target position
var waiting: bool = false  # Whether the rat is currently waiting
var wait_timer: float = 0.0  # Timer that controls the waiting period

@onready var anim_player: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	randomize()
	var area_node = get_node(area)
	destination = generate_random_point_in_area(area_node)
	interactable.interact = _on_interact

func _physics_process(delta: float) -> void:
	if waiting:
		wait_timer -= delta
		if wait_timer <= 0:
			waiting = false
			var area_node = get_node(area)
			destination = generate_random_point_in_area(area_node)

			# When the rat starts moving again, play the running animation
			if not anim_player.is_playing() or anim_player.animation != "running":
				anim_player.play("running")
	else:
		move_to_destination(destination, delta)

func generate_random_point_in_area(area_node: Area2D) -> Vector2:
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


func move_to_destination(target: Vector2, _delta: float) -> void:
	var direction = target - global_position
	var distance = direction.length()

	if distance > 5:
		velocity = direction.normalized() * speed
		move_and_slide()

		# Ensure running animation is active while moving
		if anim_player.animation != "running":
			anim_player.play("running")
	else:
		velocity = Vector2.ZERO
		move_and_slide()

		# Switch to idle and start waiting for the next move
		if not waiting:
			anim_player.play("idle")
			waiting = true
			wait_timer = wait_time

func _on_interact(body: Player) -> bool:
	if body.collect(item):
		print("collected:", item.name)
		queue_free()   # or disable the box
		return true    # success
	print("inventory full")
	return false      # nothing collected
