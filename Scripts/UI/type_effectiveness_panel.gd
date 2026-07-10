extends PanelContainer
class_name TypeEffectivenessChart

@onready var type_chart_grid: GridContainer = $TypeEffectivenessVBox/TypeChartGrid

var pokemon_type_urls: Dictionary[String, String] = {}

func _ready() -> void:
	pass

func evaluate_type_effectiveness():
	for type in type_chart_grid.get_children():
		var icon = type.get_child(0)
		var effectiveness = type.get_child(1)

func setup_types():
	for url in pokemon_type_urls.values():
		var new_request = HTTPRequest.new()
		add_child(new_request)
		new_request.request_completed.connect(_on_type_request_completed)
		new_request.request_completed.connect(new_request.queue_free.unbind(4))
		new_request.request(url)

func _on_type_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var type = JSON.parse_string(body.get_string_from_utf8())
		print(type["name"])
	else:
		print("Failed to complete request!")
