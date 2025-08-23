extends Area2D


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	input_event.connect(_on_input_event)


func _process(_delta: float) -> void:
	position = position + Vector2(0, 0.5)


func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			input_event.disconnect(_on_input_event)
			visible = false

			var value = randi_range(10, 20)
			GameManager.potion_value_bonus = value
			GameManager.bonus_collected.emit("+%d Potion Value!" % value)

			await get_tree().create_timer(10.0).timeout
			GameManager.potion_value_bonus = 0
			GameManager.bonus_ended.emit()
			queue_free()


func _on_mouse_entered() -> void:
	scale = Vector2(2.0, 2.0)
