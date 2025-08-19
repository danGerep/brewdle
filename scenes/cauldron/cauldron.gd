extends Node2D

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var slots: Node2D = $Slots

const POTION = preload("res://scenes/potion/potion.tscn")
const CAULDRON_FULL = preload("res://assets/cauldron-full.png")
const CAULDRON = preload("res://assets/cauldron.png")

var potion_slots = []
var next_slot_index = 0


func _ready() -> void:
	potion_slots = slots.get_children()

	timer.timeout.connect(_on_timer_timeout)
	sprite_2d.texture = CAULDRON_FULL


func _on_timer_timeout() -> void:
	if next_slot_index < potion_slots.size():
		var potion_instance = POTION.instantiate()
		potion_instance.position = potion_slots[next_slot_index].position
		add_child(potion_instance)
		next_slot_index += 1

		GameManager.add_potion_pool(potion_instance)


func remove_potion_used_slot() -> void:
	if next_slot_index > 0:
		next_slot_index -= 1
