extends Camera3D

var player_node
var y = 0;

func _ready() -> void:
	#find player node // this runs on start
	player_node = get_node("../player")
	y = player_node.get_global_position().y

func _physics_process(delta: float) -> void:
	#set position to player node with an offset
	global_position = Vector3(player_node.get_global_position().x, y + 6, player_node.get_global_position().z + 8)
