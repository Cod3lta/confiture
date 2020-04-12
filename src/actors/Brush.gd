extends RigidBody2D

onready var Jamy = get_parent().get_node("Jamy")
onready var exterieur = get_parent().get_node("Exterieur")
onready var wood = get_parent().get_node("House/Wood")
var picked: bool = false
var shoot_speed = 400.0
var gravity_scale_reset = 9.0
var brush_radius = 3.5

func _ready():
	set_bounce(0.3)
	set_can_sleep(false) #Force à appeler _integrate_forces() tout le temps


func _physics_process(delta):
	paint()

func _integrate_forces(state):
	if picked:
		var brush_position = Vector2(Jamy.position.x, Jamy.position.y - 10)
		if Jamy.aim_direction.length() > 0:
			brush_position += -Jamy.aim_direction * 6
			brush_position.y -= 6
		
		var xform = state.get_transform()
		xform.origin = brush_position
		state.set_transform(xform)
		
		"""var angle_diff = PI/2 - Jamy.aim_direction.angle()
		print(Jamy.aim_direction.angle())
		state.set_angular_velocity(angle_diff)
		"""

func _on_PickupDetector_body_entered(body):
	if body is KinematicBody2D:
		pick()


func pick():
	Jamy.can_wall_jump = true
	set_gravity_scale(0)
	set_linear_velocity(Vector2.ZERO)
	set_applied_force(Vector2.ZERO)
	brush_radius = 4.0
	picked = true


func release():
	set_gravity_scale(gravity_scale_reset)
	brush_radius = 3.5
	picked = false


func shoot(aim_direction):
	release()
	apply_central_impulse(aim_direction * shoot_speed)

func paint():
	var coord = exterieur.world_to_map(position)
	for row in range(coord.y - brush_radius, coord.y + brush_radius):
		for col in range(coord.x - brush_radius, coord.x + brush_radius):
			var dx = abs(coord.x - col)
			var dy = abs(coord.y - row)
			var d_squared = pow(dx, 2) + pow(dy, 2)
			if d_squared <= pow(brush_radius, 2):
				#Cercle autour du brush
				if exterieur.get_cell(col, row) != -1:
					exterieur.set_cell(col, row, 2)
					exterieur.update_bitmask_area(Vector2(col, row))
				
				if wood.get_cell(col, row) == 1:
					wood.set_cell(col, row, 2)
					wood.update_bitmask_area(Vector2(col, row))
				
				if wood.get_cell(col, row) == 8:
					wood.set_cell(col, row, 6)
				
				if wood.get_cell(col, row) == 7:
					wood.set_cell(col, row, 5)
				

