extends Position2D

export var grid_size = Vector2()
var grid_position = Vector2()
onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_size = get_viewport_rect().size
	set_as_toplevel(true)
	update_grid_position()
	position = Vector2(0, 0)

func _physics_process(delta):
	update_grid_position()

func update_grid_position():
	var x = (parent.position.x - grid_size.x/2) / (grid_size.x)
	var y = (parent.position.y - grid_size.y/2) / (grid_size.y)
	var new_grid_position = Vector2(round(x), round(y))
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	position = grid_position * grid_size
