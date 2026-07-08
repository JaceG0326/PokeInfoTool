extends Node

@onready var http_request: HTTPRequest = $HTTPRequest

# https://pokeapi.co/api/v2/pokemon/ditto

func _ready() -> void:
	http_request.request("https://pokeapi.co/api/v2/pokemon/" + "ditto")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["types"][0]["type"]["name"])
