extends PanelContainer
class_name BaseStatsHandler

@onready var base_stats_v_box: VBoxContainer = $BaseStatsVBox

var pokemon_base_stat_urls: Dictionary[String, String] = {}

func _ready() -> void:
	for base_stat in 
