extends Label


func start(text_to_show: String, start_position: Vector2):
	text = text_to_show
	global_position = start_position

	var tween = create_tween()

	(
		tween
		. tween_property(self, "position:y", position.y - 40, 1.0)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)

	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	tween.finished.connect(queue_free)
