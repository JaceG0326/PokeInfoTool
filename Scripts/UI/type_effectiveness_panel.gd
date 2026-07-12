extends PanelContainer
class_name TypeEffectivenessChart

const IMMUNITY_COLOR: Color = Color("243136ff")
const RESISTANCE_COLOR: Color = Color("a40000")
const EXTREME_RESISTANCE_COLOR: Color = Color("510013ff")
const WEAKNESS_COLOR: Color = Color("00db21ff")
const EXTREME_WEAKNESS_COLOR: Color = Color("205d00ff")
const NEUTRAL_COLOR: Color = Color("ffffff")

@onready var type_chart_grid: GridContainer = $TypeEffectivenessVBox/TypeChartGrid
var api_handler : APIHandler = null

var pokemon_type_urls: Dictionary[String, String] = {}
var weaknesses: Array[String] = []
var extreme_weaknesses: Array[String] = []
var immunities: Array[String] = []
var resistances: Array[String] = []
var extreme_resistances: Array[String] = []

func _ready() -> void:
	hide()
	api_handler = get_node_or_null("/root/Main")

func evaluate_type_effectiveness():
	for weakness in weaknesses:
		if immunities.has(weakness) or resistances.has(weakness):
			weaknesses.erase(weakness)
			resistances.erase(weakness)
	print("Weaknesses: " + str(weaknesses))
	print("Extreme Weaknesses: " + str(extreme_weaknesses))
	print("Resistances: " + str(resistances))
	print("Extreme Resistances: " + str(extreme_resistances))
	
	for type in type_chart_grid.get_children():
		var type_name = type.name.to_upper().trim_suffix("TYPE") # i.e. NORMALTYPE -> NORMAL
		var effectiveness: ColorRect = type.get_child(1)
		var label: Label = effectiveness.get_child(0)
		effectiveness.color = NEUTRAL_COLOR
		label.text = "1"
		if weaknesses.has(type_name):
			effectiveness.color = WEAKNESS_COLOR
			label.text = "2"
		if extreme_weaknesses.has(type_name):
			effectiveness.color = EXTREME_WEAKNESS_COLOR
			label.text = "4"
		if resistances.has(type_name):
			effectiveness.color = RESISTANCE_COLOR
			label.text = "1/2"
		if extreme_resistances.has(type_name):
			effectiveness.color = EXTREME_RESISTANCE_COLOR
			label.text = "1/4"
		if immunities.has(type_name):
			effectiveness.color = IMMUNITY_COLOR
			label.text = "0"
	if api_handler != null:
		api_handler.part_loaded["Type Chart"] = true

func setup_types():
	weaknesses.clear()
	extreme_weaknesses.clear()
	resistances.clear()
	extreme_resistances.clear()
	immunities.clear()
	for url in pokemon_type_urls.values():
		var new_request = HTTPRequest.new()
		add_child(new_request)
		new_request.use_threads = true
		new_request.request_completed.connect(_on_type_request_completed)
		new_request.request_completed.connect(new_request.queue_free.unbind(4))
		new_request.request(url)

func _on_type_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var type = JSON.parse_string(body.get_string_from_utf8())
		#print(type["damage_relations"])
		var double_damage_from: Array = type["damage_relations"]["double_damage_from"]
		var half_damage_from: Array = type["damage_relations"]["half_damage_from"]
		var no_damage_from: Array = type["damage_relations"]["no_damage_from"]
		for weakness in double_damage_from:
			var weakness_name = weakness["name"].to_upper()
			if !weaknesses.has(weakness_name): weaknesses.append(weakness_name)
			else: extreme_weaknesses.append(weakness_name)
		for resistance in half_damage_from:
			var resistance_name = resistance["name"].to_upper()
			if !resistances.has(resistance_name): resistances.append(resistance_name)
			else: extreme_resistances.append(resistance_name)
		for immunity in no_damage_from:
			var immunity_name = immunity["name"].to_upper()
			if !immunities.has(immunity_name): immunities.append(immunity_name)
		evaluate_type_effectiveness()
	else:
		print("Failed to complete request!")
