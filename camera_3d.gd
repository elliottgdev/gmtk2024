extends Camera3D

var player_node

func _ready() -> void:
	#find player node // this runs on start
	player_node = get_node("../player")

func _physics_process(delta: float) -> void:
	#set position to player node with an offset
	global_position = player_node.get_global_position() + Vector3(0, 11, 6)
