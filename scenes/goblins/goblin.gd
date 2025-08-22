extends CharacterBody2D
class_name Goblin

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var potion_holder: Marker2D = $PotionHolder
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var potion_pool_timer: Timer = $PotionPoolTimer
@onready var voice_timer: Timer = $VoiceTimer
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var movement_speed: float = 40.0

var audio_list: Array = [
	"res://assets/audio/ca-ca-ca-ca-ca.wav",
	"res://assets/audio/talking.mp3",
	"res://assets/audio/vicious.mp3",
]

var busy = false
var holding_potion = false
var last_direction: Vector2 = Vector2.DOWN


func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(_on_velocity_computed)
	potion_pool_timer.timeout.connect(_check_potion_pool)
	voice_timer.timeout.connect(_on_voice_timer_timeout)
	update_animation()


func set_movement_target(movement_target: Vector2):
	navigation_agent_2d.set_target_position(movement_target)


func _physics_process(_delta):
	if navigation_agent_2d.is_navigation_finished():
		if holding_potion:
			for carried_potion in potion_holder.get_children():
				carried_potion.queue_free()
				GameManager.potion_sold.emit()
				GameManager.potion_delivered.emit()
			# Reset goblin state after selling potion.
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


func _check_potion_pool() -> void:
	if busy:
		return

	if GameManager.potion_pool.is_empty():
		return

	var potion_key = GameManager.potion_pool.keys().front()
	var potion = GameManager.potion_pool[potion_key]
	potion.goblin = self
	busy = true

	GameManager.remove_potion_from_pool(potion)
	set_movement_target(potion.global_position)


func update_animation():
	if velocity.length() < 1.0:
		if last_direction.y < 0:
			animated_sprite.play("idle_up")
		else:
			animated_sprite.play("idle")
		return

	last_direction = velocity.normalized()

	if holding_potion:
		animated_sprite.play("walking_carrying")
		return

	if abs(velocity.x) > abs(velocity.y):
		animated_sprite.play("walking_s")
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
		if velocity.y > 0:
			animated_sprite.play("walking_d")
		else:
			animated_sprite.play("walking_u")


func _on_voice_timer_timeout() -> void:
	if holding_potion and randi() % 10 == 0:
		var random_index = randi() % audio_list.size()
		var audio_file = audio_list[random_index]
		audio_stream_player.stream = load(audio_file)
		audio_stream_player.play()
