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
