extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var coins_animation: AnimatedSprite2D = $CoinsAnimation
@onready var cauldron_markers: Node = $CauldronMarkers
@onready var ui: CanvasLayer = $UI


func _ready() -> void:
	GameManager.potion_picked_up.connect(_on_potion_picked_up)
	GameManager.potion_delivered.connect(_on_potion_delivered)
	GameManager.cauldron_bought.connect(_on_cauldron_bought)


# This happens here because I need to tell the Goblin where to go.
# The marker is set on the level.
func _on_potion_picked_up(goblin: Goblin) -> void:
	goblin.set_movement_target(marker_2d.position)


func _on_potion_delivered() -> void:
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
