extends Node

signal potion_created(position: Vector2)
signal potion_picked_up(goblin: Goblin)
signal potion_sold(value: int)
signal potion_delivered

signal refresh_ui

var gold_amount: int = 0


func _ready() -> void:
	potion_sold.connect(_on_potion_sold)


func _on_potion_sold(value: int) -> void:
	gold_amount += value
	print("Gold amount is now: %d" % gold_amount)
	refresh_ui.emit()
