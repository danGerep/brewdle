extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var coins_animation: AnimatedSprite2D = $CoinsAnimation
@onready var cauldron_markers: Node = $CauldronMarkers
@onready var goblin_markers: Node = $GoblinMarkers
@onready var ui: CanvasLayer = $UI
@onready var coin_sount_stream_player: AudioStreamPlayer2D = $CoinSoundStreamPlayer
@onready var powerup_timer: Timer = $PowerUpTimer
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var coin_sounds: Array = [
	"res://assets/audio/coin1.mp3",
	"res://assets/audio/coin2.wav",
]

var cursor_textures: Array[Texture2D] = [
	preload("res://assets/mouse-pointer.png"),
	preload("res://assets/mouse-pointer-click.png"),
]


func _ready() -> void:
	GameManager.potion_picked_up.connect(_on_potion_picked_up)
	GameManager.potion_delivered.connect(_on_potion_delivered)
	GameManager.cauldron_bought.connect(_on_cauldron_bought)
	GameManager.goblin_bought.connect(_on_goblin_bought)

	powerup_timer.timeout.connect(_on_powerup_timeout)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			Input.set_custom_mouse_cursor(cursor_textures[1])
		else:
			Input.set_custom_mouse_cursor(cursor_textures[0])


# This happens here because I need to tell the Goblin where to go.
# The marker is set on the level.
func _on_potion_picked_up(goblin: Goblin) -> void:
	goblin.set_movement_target(marker_2d.position)


func _on_potion_delivered() -> void:
	var random_index = randi() % coin_sounds.size()
	var audio_file = coin_sounds[random_index]
	coin_sount_stream_player.stream = load(audio_file)
	coin_sount_stream_player.play()

	coins_animation.visible = true
	coins_animation.play("default")
	await coins_animation.animation_finished
	coins_animation.visible = false


# ---- CAULDRON BUYING ----
var cauldrons: Array = []
const CAULDRON_SCENE = preload("res://scenes/cauldron/cauldron.tscn")


func _on_cauldron_bought() -> void:
	if cauldrons.size() < 8:
		var cauldron_instance = CAULDRON_SCENE.instantiate()
		var marker = cauldron_markers.get_child(cauldrons.size())

		marker.add_child(cauldron_instance)
		cauldron_instance.global_position = marker.global_position
		cauldrons.append(cauldron_instance)
		ui.can_buy_cauldron = cauldrons.size() < 8


# ---- GOBLIN BUYING ----
var goblins: Array = []
const GOBLIN_SCENE = preload("res://scenes/goblins/goblin.tscn")


func _on_goblin_bought() -> void:
	if goblins.size() < 15:
		var goblin_instance = GOBLIN_SCENE.instantiate()
		var marker = goblin_markers.get_child(goblins.size())

		marker.add_child(goblin_instance)
		goblin_instance.global_position = marker.global_position
		goblins.append(goblin_instance)


var power_ups: Array = [
	preload("res://scenes/powerup/goblin_speed.tscn"),
	preload("res://scenes/powerup/potion_value.tscn"),
]


func _on_powerup_timeout() -> void:
	path_follow_2d.progress_ratio = randi()

	var random_index = randi() % power_ups.size()
	var powerup_scene = power_ups[random_index].instantiate()
	powerup_scene.global_position = path_follow_2d.position
	add_child(powerup_scene)
