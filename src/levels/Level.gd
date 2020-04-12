extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($House/WoodDeco.world_to_map(get_global_mouse_position()))
	pass

func open_garden():
	for i in range(18, 28+1, 1):
		for j in range(0, 1+1, 1):
			$House/WoodDarker.set_cell(j, i, -1)

func open_front_door():
	$House/WoodDeco.set_cell(58, 25, -1)
	for i in range(58, 59+1, 1):
		for j in range(25, 28+1, 1):
			$House/WoodDarker.set_cell(i, j, -1)

func _on_Game_show_dialogue(val):
	$Jamy.can_move = val
