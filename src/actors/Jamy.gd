extends KinematicBody2D

signal shoot

onready var Brush = get_parent().get_node("Brush")
onready var camera = $GridSnapper/Camera2D
onready var aim_offset = $Pivot/AimOffset
onready var aim_sprite = $Pivot/AimOffset/Sprite
onready var animatedSprite = $AnimatedSprite

export var max_speed = Vector2(500.0, 300.0)
export var max_walk_speed = 250 #Plus grand pour compenser la friction
export var jump_amount = 300
export var gravity = 1000
export var shoot_brush_impact = Vector2(700, 300)

var wall_jump_amount = 100
var acceleration = 70.0 #Plus grand pour compenser la friction
var deceleration = 0.4
var velocity = Vector2.ZERO
var brush_picked: bool = false
var aim_direction = Vector2.ZERO
var facing: bool = true #true -> right, false -> left
var can_wall_jump: bool = true


func _ready():
	
	$GridSnapper/Camera2D._set_current(true)

func _physics_process(delta):
	run()
	fall(delta)
	jump(delta)
	max_speed_limit()
	velocity = move_and_slide(Vector2(velocity.x, velocity.y), Vector2.UP)
	slow_mo_throw_brush()
	set_animations()


func fall(delta):
	velocity.y += gravity * delta


func jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			can_wall_jump = true
			velocity.y = -jump_amount
		elif is_on_wall() and can_wall_jump:
			velocity.y = -jump_amount
			velocity.x = wall_jump_amount if !facing else -wall_jump_amount
			can_wall_jump = false


func get_input_x_strength():
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func run():
	var player_input_x = get_input_x_strength()
	if not Input.is_action_pressed("throw_brush") or aim_direction.length() == 0:
		var walk_acceleration
		if(is_on_floor()):
			walk_acceleration = player_input_x * acceleration
		else:
			walk_acceleration = player_input_x * acceleration / 5
		if not (velocity.x + walk_acceleration > max_walk_speed or velocity.x + walk_acceleration < -max_walk_speed):
			#Moment d'accélération
			velocity.x += walk_acceleration
	
	friction()

func friction():
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, deceleration)
	else:
		velocity.x = lerp(velocity.x, 0, deceleration / 4)

func max_speed_limit():
	velocity.x = min(velocity.x, max_speed.x)
	velocity.x = max(velocity.x, -max_speed.x)
	velocity.y = min(velocity.y, max_speed.y)
	velocity.y = max(velocity.y, -max_speed.y)

func slow_mo_throw_brush():
	if Input.is_action_pressed("throw_brush") and Brush.picked:
		Engine.time_scale = 0.05
		aim_direction = aim_brush()
	elif Input.is_action_just_released("throw_brush") and Brush.picked:
		shoot_brush(aim_direction)
		aim_offset.set_position(Vector2(0, 0))
		Engine.time_scale = 1
	else:
		aim_direction = Vector2.ZERO


func aim_brush():
	var aim_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
	aim_direction = aim_direction.normalized()
	aim_offset.position.x = lerp(aim_offset.position.x, aim_direction.x * 40, 0.5)
	aim_offset.position.y = lerp(aim_offset.position.y, aim_direction.y * 40, 0.5)
	aim_sprite.set_visible(aim_direction.length() > 0)
	aim_sprite.set_rotation(aim_direction.angle())
	return aim_direction


func shoot_brush(aim_direction):
	aim_sprite.set_visible(false)
	if aim_direction.length() > 0:
		Brush.shoot(aim_direction)
		velocity = -aim_direction * shoot_brush_impact

func inactive(milisecond):
	pass

func set_animations():
	set_facing()
	animatedSprite.flip_h = !facing
	if aim_direction.length() > 0: #Si le player est en train de viser
		if is_on_floor():
			if Input.is_action_pressed("move_up"):
				animatedSprite.animation = "aim_ground_up"
			elif Input.is_action_pressed("move_down"):
				animatedSprite.animation = "aim_ground_down"
			else:
				animatedSprite.animation = "aim_ground_middle"
		else:
			if Input.is_action_pressed("move_up"):
				animatedSprite.animation = "aim_air_up"
			elif Input.is_action_pressed("move_down"):
				animatedSprite.animation = "aim_air_down"
			else:
				animatedSprite.animation = "aim_air_middle"
	else:
		if not is_on_floor() and not is_on_wall():
			if velocity.y < 0:
				animatedSprite.animation = "jump"
			else:
				animatedSprite.animation = "fall"
		elif is_on_wall() and can_wall_jump and not is_on_floor():
			animatedSprite.animation = "hang"
		else:
			if get_input_x_strength() != 0:
				animatedSprite.animation = "run"
			else:
				animatedSprite.animation = "idle"
	

func set_facing():
	if Input.is_action_just_pressed("move_right"):
		facing = true
	elif Input.is_action_just_pressed("move_left"):
		facing = false
