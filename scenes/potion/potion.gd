extends Node2D

@onready var area_2d: Area2D = $Area2D

@export var value: int = 10


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)


func _on_body_entered(goblin: Node2D) -> void:
	GameManager.potion_picked_up.emit(goblin)
	area_2d.set_deferred("monitoring", false)
	get_parent().remove_potion_used_slot()

	reparent.call_deferred(goblin.potion_holder)
	global_position = goblin.potion_holder.global_position
	goblin.holding_potion = true
