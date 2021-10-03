extends Camera2D

const FRICTION = 0.3
const MAX_SPEED = 75
onready var _context = get_node("/root/Orchestrator")
var player_ref = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player_ref = _context.get_player()
	position = player_ref.position

func _process(_delta):
	var new_pos_x = lerp(position.x, player_ref.position.x, FRICTION)
	var new_pos_y = lerp(position.y, player_ref.position.y, FRICTION)
	position = Vector2(new_pos_x, new_pos_y)
