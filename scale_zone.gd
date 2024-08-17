extends Area3D

var player_node

func _ready() -> void:
	player_node = get_node("../player")

func _on_body_entered(body: CharacterBody3D) -> void:
	player_node.is_in_scale_zone = true

func _on_body_exited(body: CharacterBody3D) -> void:
	player_node.is_in_scale_zone = false
