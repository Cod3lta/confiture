extends RigidBody2D

onready var Jamy = get_parent().get_node("Jamy")
onready var Exterieur = get_parent().get_node("Exterieur")
var picked: bool = false
var shoot_speed = 400.0
var gravity_scale_reset = 9.0
var brush_radius = 3.5

func _ready():
	set_bounce(0)
	set_can_sleep(false) #Force à appeler _integrate_forces() tout le temps


func _physics_process(delta):
	paint()

func _integrate_forces(state):
	if picked:
		state.transform.origin = Vector2(Jamy.position.x, Jamy.position.y - 10)
		var xform = state.get_transform()
		var brush_position = Vector2(Jamy.position.x, Jamy.position.y - 100)
		xform.origin = brush_position
		if Jamy.aim_direction.length() > 0:
			


func _on_PickupDetector_area_shape_entered(area_id, area, area_shape, self_shape):
	pick()


func pick():
	set_gravity_scale(0)
	set_linear_velocity(Vector2.ZERO)
	set_applied_force(Vector2.ZERO)
	brush_radius = 4.5
	picked = true


func release():
	set_gravity_scale(gravity_scale_reset)
	brush_radius = 3.5
	picked = false


func shoot(aim_direction):
	release()
	apply_central_impulse(aim_direction * shoot_speed)

func paint():
	var coord = Exterieur.world_to_map(position)
	for row in range(coord.y - brush_radius, coord.y + brush_radius):
		for col in range(coord.x - brush_radius, coord.x + brush_radius):
			var dx = abs(coord.x - col)
			var dy = abs(coord.y - row)
			var d_squared = pow(dx, 2) + pow(dy, 2)
			if d_squared <= pow(brush_radius, 2):
				#Cercle autour du brush
				Exterieur.set_cell(col, row, 2, false, false, false)
				Exterieur.update_bitmask_area( Vector2(col, row))
