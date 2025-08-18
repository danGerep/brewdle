extends CanvasLayer

@onready var gold_amount_label: Label = %GoldAmount
@onready var cauldron_button: Button = %CauldronButton
@onready var goblin_button: Button = %GoblinButton


func _ready() -> void:
	GameManager.refresh_ui.connect(_on_refresh_ui)
	cauldron_button.pressed.connect(_on_cauldron_button_pressed)
	goblin_button.pressed.connect(_on_goblin_button_pressed)

	_on_refresh_ui()


func _on_refresh_ui() -> void:
	gold_amount_label.text = str(GameManager.gold_amount)
	cauldron_button.text = "CAULDRON - %d" % GameManager.current_cauldron_price
	goblin_button.text = "GOBLIN - %d" % GameManager.current_goblin_price


var can_buy_cauldron: bool = true:
	set(value):
		can_buy_cauldron = value
		cauldron_button.disabled = not value


func _on_cauldron_button_pressed() -> void:
	if GameManager.gold_amount >= GameManager.current_cauldron_price:
		GameManager.gold_amount -= GameManager.current_cauldron_price
		GameManager.current_cauldron_price += 5
		GameManager.refresh_ui.emit()
		GameManager.cauldron_bought.emit()


var can_buy_goblin: bool = true:
	set(value):
		can_buy_goblin = value
		goblin_button.disabled = not value


func _on_goblin_button_pressed() -> void:
	if GameManager.gold_amount >= GameManager.current_goblin_price:
		GameManager.gold_amount -= GameManager.current_goblin_price
		GameManager.current_goblin_price += 5
		GameManager.refresh_ui.emit()
		GameManager.goblin_bought.emit()
