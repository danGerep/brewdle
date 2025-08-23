extends Node2D

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var slots: Node2D = $Slots

const POTION = preload("res://scenes/potion/potion.tscn")
const CAULDRON_FULL = preload("res://assets/cauldron-full.png")
const CAULDRON = preload("res://assets/cauldron.png")

var potion_slots = []
var potion_dictionary: Dictionary = {}


func _ready() -> void:
	potion_slots = slots.get_children()

	for slot in range(potion_slots.size()):
		potion_dictionary[slot] = false

	timer.timeout.connect(_on_timer_timeout)
	sprite_2d.texture = CAULDRON_FULL


func _on_timer_timeout() -> void:
	var available_slot = -1

	for slot in potion_dictionary:
		if potion_dictionary[slot] == false:
			available_slot = slot
			break

	if available_slot == -1:
		return

	potion_dictionary[available_slot] = true

	var potion_instance = POTION.instantiate()
	potion_instance.position = potion_slots[available_slot].position
	potion_instance.cauldron_position_index = available_slot
	add_child(potion_instance)

	GameManager.add_potion_pool(potion_instance)


func remove_potion_used_slot(index: int) -> void:
	potion_dictionary[index] = false
