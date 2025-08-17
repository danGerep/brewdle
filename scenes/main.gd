extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var coins_animation: AnimatedSprite2D = $CoinsAnimation


func _ready() -> void:
	GameManager.potion_picked_up.connect(_on_potion_picked_up)
	GameManager.potion_delivered.connect(_on_potion_delivered)


# This happens here because I need to tell the Goblin where to go.
# The marker is set on the level.
func _on_potion_picked_up(goblin: Goblin) -> void:
	goblin.set_movement_target(marker_2d.position)


func _on_potion_delivered() -> void:
	coins_animation.visible = true
	coins_animation.play("default")
	await coins_animation.animation_finished
	coins_animation.visible = false
