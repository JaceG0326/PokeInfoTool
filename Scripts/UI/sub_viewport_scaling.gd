extends SubViewport

func _ready() -> void:
	get_tree().root.size_changed.connect(_on_resize_window)

func _on_resize_window():
	size_2d_override = get_window().size
	print("TEST")
