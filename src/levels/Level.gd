extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_garden():
	for i in range(18, 28+1, 1):
		for j in range(0, 1+1, 1):
			$House/WoodDarker.set_cell(j, i, -1)
	pass
