extends CanvasLayer

@onready var gold_amount_label: Label = %GoldAmount
@onready var cauldron_button: Button = %CauldronButton
@onready var goblin_button: Button = %GoblinButton
@onready var better_potion_button: Button = %PotionButton

@onready var label_placeholder: Marker2D = %LabelPlaceholder


func _ready() -> void:
	GameManager.refresh_ui.connect(_on_refresh_ui)
	GameManager.potion_sold.connect(_on_potion_sold)

	cauldron_button.pressed.connect(_on_cauldron_button_pressed)
	goblin_button.pressed.connect(_on_goblin_button_pressed)
	better_potion_button.pressed.connect(_on_better_potion_button_pressed)

	_on_refresh_ui()


func _on_refresh_ui() -> void:
	gold_amount_label.text = str(GameManager.gold_amount)
	cauldron_button.text = "%d" % GameManager.current_cauldron_price
	goblin_button.text = "%d" % GameManager.current_goblin_price
	better_potion_button.text = "%d" % GameManager.current_better_potion_price

	cauldron_button.disabled = GameManager.gold_amount < GameManager.current_cauldron_price
	goblin_button.disabled = GameManager.gold_amount < GameManager.current_goblin_price
	better_potion_button.disabled = (
		GameManager.gold_amount < GameManager.current_better_potion_price
	)


var can_buy_cauldron: bool = true:
	set(value):
		can_buy_cauldron = value
		cauldron_button.disabled = not value


func _on_cauldron_button_pressed() -> void:
	if GameManager.gold_amount >= GameManager.current_cauldron_price:
		GameManager.gold_amount -= GameManager.current_cauldron_price
		GameManager.current_cauldron_price += 5
		GameManager.cauldron_bought.emit()
	_on_refresh_ui()


func _on_goblin_button_pressed() -> void:
	if GameManager.gold_amount >= GameManager.current_goblin_price:
		GameManager.gold_amount -= GameManager.current_goblin_price
		GameManager.current_goblin_price += 5
		GameManager.goblin_bought.emit()
	_on_refresh_ui()


var potion_colors: Array = [
	Color(1, 1, 1),  # White
	Color(1, 0, 0),  # Red
	Color(0, 1, 0),  # Green
	Color(0, 0, 1),  # Blue
	Color(1, 1, 0),  # Yellow
	Color(1, 0, 1),  # Magenta
	Color(0, 1, 1),  # Cyan
	Color(1, 0.5, 0),  # Orange
	Color(0.5, 0, 1),  # Purple
	Color(0.5, 0.5, 0.5),  # Gray
	Color(0.6, 0.4, 0.2),  # Brown
	Color(1, 0.75, 0.8),  # Pink
	Color(0.5, 1, 0.5),  # Light Green
	Color(0.5, 0.5, 1),  # Light Blue
	Color(1, 1, 0.5),  # Light Yellow
	Color(1, 0.5, 1),  # Light Magenta
	Color(0.5, 1, 1),  # Light Cyan
	Color(0.8, 0.8, 0.8),  # Light Gray
	Color(0.3, 0.2, 0.1),  # Dark Brown
]


func _on_better_potion_button_pressed() -> void:
	if GameManager.gold_amount >= GameManager.current_better_potion_price:
		GameManager.gold_amount -= GameManager.current_better_potion_price
		GameManager.current_better_potion_price += 5
		GameManager.current_potion_selling_price += 1
		GameManager.current_potion_color = potion_colors[randi() % potion_colors.size()]
	_on_refresh_ui()


const FloatingTextScene = preload("res://scenes/ui/floating_text.tscn")


func _on_potion_sold() -> void:
	var floating_text = FloatingTextScene.instantiate()

	add_child(floating_text)

	var popup_text = "+%s G" % GameManager.current_potion_selling_price
	var start_position = (
		label_placeholder.global_position + Vector2(randi_range(-20, 20), randi_range(-20, -20))
	)
	floating_text.start(popup_text, start_position)

	# Flash the gold amount label to indicate an increase.
	var flash_tween = create_tween()
	flash_tween.tween_property(gold_amount_label, "modulate", Color(1, 1, 0), 0.0)
	flash_tween.tween_property(gold_amount_label, "modulate", Color(1, 1, 1), 0.5)
