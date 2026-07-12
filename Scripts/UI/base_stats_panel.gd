extends PanelContainer
class_name BaseStatsHandler

const BAD_STAT_COLOR: Color = Color("f34444")
const OKAY_STAT_COLOR: Color = Color("ff7f0f")
const GOOD_STAT_COLOR: Color = Color("ffdd57")
const GREAT_STAT_COLOR: Color = Color("a0e515")
const AWESOME_STAT_COLOR: Color = Color("23cd5e")
const OUTSTANDING_STAT_COLOR: Color = Color("00c2b8")

@onready var base_stats_v_box: VBoxContainer = $BaseStatsVBox
var api_handler : APIHandler = null

var pokemon_base_stats: Dictionary[String, int] = { "hp": 0, "attack": 0, "defense": 0, "special-attack": 0, "special-defense": 0, "speed": 0 }

func _ready() -> void:
	hide()
	for base_stat_object in base_stats_v_box.get_children():
		if base_stat_object is not HBoxContainer: continue
		if base_stat_object.name == "TOTAL":
			var total_label: Label = base_stat_object.get_child(1)
			total_label.text = str(0)
			continue
		var stat: Label = base_stat_object.get_child(1)
		var stat_bar: ProgressBar = base_stat_object.get_child(2)
		var min_stat: Label = base_stat_object.get_child(3)
		var max_stat: Label = base_stat_object.get_child(4)
		
		stat.text = str(0)
		stat_bar.value = stat_bar.max_value / 2
		var new_stylebox_normal = stat_bar.get_theme_stylebox("fill").duplicate()
		new_stylebox_normal.bg_color = get_stat_color(stat_bar.value)
		stat_bar.add_theme_stylebox_override("fill", new_stylebox_normal)
		min_stat.text = str(0)
		max_stat.text = str(0)
	api_handler = get_node_or_null("/root/Main")

func setup_base_stats():
	var total_label: Label = null
	var bst = 0
	for base_stat_object in base_stats_v_box.get_children():
		if base_stat_object is not HBoxContainer: continue
		if base_stat_object.name == "TOTAL":
			total_label = base_stat_object.get_child(1)
			continue
		var stat: Label = base_stat_object.get_child(1)
		var stat_bar: ProgressBar = base_stat_object.get_child(2)
		var min_stat: Label = base_stat_object.get_child(3)
		var max_stat: Label = base_stat_object.get_child(4)
		
		var base = -1
		var min = -1
		var max = -1
		match base_stat_object.name:
			"HP":
				base = pokemon_base_stats["hp"]
			"ATK":
				base = pokemon_base_stats["attack"]
			"DEF":
				base = pokemon_base_stats["defense"]
			"SpATK":
				base = pokemon_base_stats["special-attack"]
			"SpDEF":
				base = pokemon_base_stats["special-defense"]
			"SPEED":
				base = pokemon_base_stats["speed"]
		
		if base_stat_object.name == "HP":
			min = floori(((2 * base + 0 + floori(0 / 4)) * 100) / 100) + 100 + 10
			max = floori(((2 * base + 31 + floori(252 / 4)) * 100) / 100) + 100 + 10
		else:
			min = floori((floori((2 * base + 0 + floori(0 / 4)) * 100 / 100) + 5) * 0.9)
			max = floori((floori((2 * base + 31 + floori(252 / 4)) * 100 / 100) + 5) * 1.1)
		stat.text = str(base)
		stat_bar.value = base
		var new_stylebox_normal = stat_bar.get_theme_stylebox("fill").duplicate()
		new_stylebox_normal.bg_color = get_stat_color(stat_bar.value)
		stat_bar.add_theme_stylebox_override("fill", new_stylebox_normal)
		min_stat.text = str(min)
		max_stat.text = str(max)
		bst += base
	total_label.text = str(bst)
	if api_handler != null:
		api_handler.part_loaded["Stats"] = true

func get_stat_color(value: int):
	if value >= 150:
		return OUTSTANDING_STAT_COLOR
	elif value >= 120:
		return AWESOME_STAT_COLOR
	elif value >= 90:
		return GREAT_STAT_COLOR
	elif value >= 60:
		return GOOD_STAT_COLOR
	elif value >= 30:
		return OKAY_STAT_COLOR
	else:
		return BAD_STAT_COLOR
		
