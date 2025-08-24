extends Area2D

@onready var power_up_tutorial_label: Label = $PowerUpTutorialLabel


func _ready() -> void:
	if not GameManager.power_up_tutorial_displayed:
		power_up_tutorial_label.visible = true
		GameManager.power_up_tutorial_displayed = true

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)


func _process(_delta: float) -> void:
	position = position + Vector2(0, 0.5)


func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			input_event.disconnect(_on_input_event)
			visible = false

			var speed_bonus = randf_range(1.5, 2.5)
			GameManager.goblin_speed_bonus = speed_bonus
			GameManager.bonus_collected.emit("+%.1fx Goblin Speed!" % speed_bonus)

			await get_tree().create_timer(5.0).timeout
			GameManager.goblin_speed_bonus = 1.0
			GameManager.bonus_ended.emit()
			queue_free()


func _on_mouse_entered() -> void:
	scale = Vector2(2.0, 2.0)


func _on_mouse_exited() -> void:
	scale = Vector2(0.7, 0.7)
