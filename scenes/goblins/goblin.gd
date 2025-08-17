extends CharacterBody2D
class_name Goblin

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var potion_holder: Marker2D = $PotionHolder

@export var movement_speed: float = 40.0

var movement_delta: float
var busy = false
var holding_potion = false


func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(Callable(_on_velocity_computed))
	GameManager.potion_created.connect(_on_potion_created)


func set_movement_target(movement_target: Vector2):
	navigation_agent_2d.set_target_position(movement_target)


func _physics_process(delta):
	if navigation_agent_2d.is_navigation_finished():
		if holding_potion:
			for carried_potion in potion_holder.get_children():
				carried_potion.queue_free()
				GameManager.potion_sold.emit(carried_potion.value)
				GameManager.potion_delivered.emit()
			holding_potion = false
			busy = false
		return

	movement_delta = movement_speed * delta
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

	move_and_slide()


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)


func _on_potion_created(pos: Vector2) -> void:
	if busy:
		return

	busy = true
	set_movement_target(pos)
