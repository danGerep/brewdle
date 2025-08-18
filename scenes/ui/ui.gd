extends CanvasLayer

@onready var gold_amount_label: Label = %GoldAmount
@onready var cauldron_button: Button = %CauldronButton


func _ready() -> void:
	GameManager.refresh_ui.connect(_on_refresh_ui)
	cauldron_button.pressed.connect(_on_cauldron_button_pressed)
	_on_refresh_ui()


func _on_refresh_ui() -> void:
	gold_amount_label.text = str(GameManager.gold_amount)
	cauldron_button.text = "CAULDRON - %d" % GameManager.current_cauldron_price

	if GameManager.gold_amount >= GameManager.current_cauldron_price:
		cauldron_button.disabled = false
	else:
		cauldron_button.disabled = true


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
