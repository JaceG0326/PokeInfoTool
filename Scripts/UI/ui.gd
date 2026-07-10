extends CanvasLayer
class_name PokeUI

@onready var pokemon_name_label: Label = $PokeInfoContainer/PokeInfoHBox/GeneralDataPanel/GeneralDataVBox/Name

func set_pokemon_basic_info(_name: String = "MissingNo", _id: int = 0):
	pokemon_name_label.text = _name.to_pascal_case()

func set_pokemon_abilities():
	pass
