extends Node2D
class_name Potion

@onready var area_2d: Area2D = $Area2D

var goblin: Goblin


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	modulate = GameManager.current_potion_color


func _on_body_entered(area_goblin: Node2D) -> void:
	if area_goblin != goblin:
		return

	# This tells the main script to point the goblin to the selling point.
	GameManager.potion_picked_up.emit(area_goblin)

	area_2d.set_deferred("monitoring", false)
	# Remove potion from cauldron slot.
	get_parent().remove_potion_used_slot()

	reparent.call_deferred(area_goblin.potion_holder)
	global_position = area_goblin.potion_holder.global_position
	area_goblin.holding_potion = true
