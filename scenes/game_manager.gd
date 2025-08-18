extends Node

signal potion_created(position: Vector2)
signal potion_picked_up(goblin: Goblin)
signal potion_sold(value: int)
signal potion_delivered

signal cauldron_bought

signal refresh_ui

var gold_amount: int = 10000
var current_cauldron_price: int = 10
var current_goblin_price: int = 10


func _ready() -> void:
	potion_sold.connect(_on_potion_sold)


func _on_potion_sold(value: int) -> void:
	gold_amount += value
	refresh_ui.emit()
