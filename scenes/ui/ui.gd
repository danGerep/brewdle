extends CanvasLayer

@onready var gold_amount_label: Label = %GoldAmount


func _ready() -> void:
	GameManager.refresh_ui.connect(_on_refresh_ui)


func _on_refresh_ui() -> void:
	print("Refreshing UI")
	gold_amount_label.text = str(GameManager.gold_amount)
