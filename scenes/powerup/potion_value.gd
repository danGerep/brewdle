extends Area2D

@onready var power_up_tutorial_label: Label = $PowerUpTutorialLabel
@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var speed = 50.0
var bonus_timer: Timer = null


func _ready() -> void:
	if not GameManager.power_up_tutorial_displayed:
		power_up_tutorial_label.visible = true
		GameManager.power_up_tutorial_displayed = true
		speed = 25.0

	bonus_timer = Timer.new()
	add_child(bonus_timer)
	bonus_timer.timeout.connect(_on_bonus_timeout)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)
	visible_on_screen.screen_exited.connect(
		func() -> void:
			if bonus_timer.is_stopped():
				call_deferred("queue_free")
	)


func _on_bonus_timeout() -> void:
	GameManager.goblin_speed_bonus = 1.0
	GameManager.bonus_ended.emit()
	queue_free()


func _process(delta: float) -> void:
	position = position + Vector2(0, speed * delta)


func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			input_event.disconnect(_on_input_event)
			visible = false
			bonus_timer.wait_time = 5.0
			bonus_timer.start()
			var value = randi_range(10, 20)
			GameManager.potion_value_bonus = value
			GameManager.bonus_collected.emit("+%d Potion Value!" % value)


func _on_mouse_entered() -> void:
	scale = Vector2(2.0, 2.0)


func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
