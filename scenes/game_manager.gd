extends Node

@warning_ignore("unused_signal")
signal potion_created(position: Vector2)
@warning_ignore("unused_signal")
signal potion_picked_up(goblin: Goblin)
signal potion_sold
@warning_ignore("unused_signal")
signal potion_delivered

@warning_ignore("unused_signal")
signal cauldron_bought

@warning_ignore("unused_signal")
signal goblin_bought

signal refresh_ui

@warning_ignore("unused_signal")
signal bonus_collected(text: String)
@warning_ignore("unused_signal")
signal bonus_ended

var gold_amount: int = 100
var current_cauldron_price: int = 10
var current_goblin_price: int = 5
var current_potion_selling_price: int = 1
var current_better_potion_price: int = 200
var current_potion_color: Color = Color.WHITE

var goblin_speed_bonus: float = 1.0
var potion_value_bonus: int = 0

var bonus_enabled: bool = false

var power_up_tutorial_displayed: bool = false


func _ready() -> void:
	potion_sold.connect(_on_potion_sold)


func _on_potion_sold() -> void:
	gold_amount += GameManager.current_potion_selling_price + GameManager.potion_value_bonus
	refresh_ui.emit()


# POTIONS

var potion_pool: Dictionary = {}


func add_potion_pool(potion: Potion) -> void:
	potion_pool[potion.get_instance_id()] = potion


func remove_potion_from_pool(potion: Potion) -> void:
	if potion_pool.size() > 0:
		potion_pool.erase(potion.get_instance_id())
