extends CharacterBody2D
class_name Goblin

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var potion_holder: Marker2D = $PotionHolder
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var movement_speed: float = 40.0

var busy = false
var holding_potion = false
var last_direction: Vector2 = Vector2.DOWN


func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(_on_velocity_computed)
	GameManager.potion_created.connect(_on_potion_created)
	update_animation()


func set_movement_target(movement_target: Vector2):
	navigation_agent_2d.set_target_position(movement_target)


func _physics_process(_delta):
	if navigation_agent_2d.is_navigation_finished():
		if holding_potion:
			for carried_potion in potion_holder.get_children():
				carried_potion.queue_free()
				GameManager.potion_sold.emit(carried_potion.value)
				GameManager.potion_delivered.emit()
			holding_potion = false
			busy = false
		velocity = Vector2.ZERO
		update_animation()
		move_and_slide()
		return

	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_path_position)
	velocity = direction * movement_speed

	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	update_animation()
	move_and_slide()


func _on_potion_created(pos: Vector2) -> void:
	if busy:
		return
	busy = true
	set_movement_target(pos)


func update_animation():
	if velocity.length() < 1.0:
		if last_direction.y < 0:
			animated_sprite.play("idle_up")
		else:
			animated_sprite.play("idle")
		return

	last_direction = velocity.normalized()

	if abs(velocity.x) > abs(velocity.y):
		animated_sprite.play("walking_s")
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
		if velocity.y > 0:
			animated_sprite.play("walking_d")
		else:
			animated_sprite.play("walking_u")
