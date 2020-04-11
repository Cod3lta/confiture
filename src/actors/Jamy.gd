extends KinematicBody2D

signal shoot

onready var Brush = get_parent().get_node("Brush")
onready var camera = $GridSnapper/Camera2D
onready var aim_offset = $Pivot/AimOffset
onready var aim_sprite = $Pivot/AimOffset/Sprite
onready var animatedSprite = $AnimatedSprite

export var max_speed = Vector2(100.0, 5000.0)
export var max_walk_speed = 100.0
export var jump_amount = 300
export var gravity = 30.0

var acceleration = 20.0
var deceleration = 0.4
var velocity = Vector2.ZERO
var brush_picked: bool = false
var aim_direction = Vector2.ZERO
var facing: bool #true -> right, false -> left


func _physics_process(delta):
	fall(delta)
	jump(delta)
	run()
	max_speed_limit()
	velocity = move_and_slide(Vector2(velocity.x, velocity.y), Vector2.UP)
	slow_mo_throw_brush()
	set_animations()


func fall(delta):
	velocity.y += gravity * delta


func jump(delta):
	print(is_on_floor())
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = -jump_amount


func get_input_x_strength():
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func run():
	var player_imput_x = get_input_x_strength()
	if not Input.is_action_pressed("throw_brush"):
		var walk_speed
		if(is_on_floor()):
			walk_speed = player_imput_x * acceleration
		else:
			walk_speed = player_imput_x * acceleration / 5
		velocity.x += walk_speed
	if player_imput_x == 0:
		friction()
	return player_imput_x

func max_speed_limit():
	velocity.x = min(velocity.x, max_speed.x)
	velocity.x = max(velocity.x, -max_speed.x)
	velocity.y = min(velocity.y, max_speed.y)
	velocity.y = max(velocity.y, -max_speed.y)

func friction():
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, deceleration)
	else:
		pass

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
		print(-aim_direction * 500)
		velocity = -aim_direction * 500

func inactive(milisecond):
	pass

func set_animations():
	print(aim_direction)
	set_facing()
	animatedSprite.flip_h = !facing
	if aim_direction.length() > 0:
		if is_on_floor():
			if Input.is_action_pressed("move_up"):
				animatedSprite.animation = "aim_ground_up"
			elif Input.is_action_pressed("move_down"):
				animatedSprite.animation = "aim_ground_down"
			else:
				animatedSprite.animation = "aim_ground_middle"
		else:
			pass #Animations de shoot en l'air
	else:
		if !is_on_floor():
			if velocity.y < 0:
				#animatedSprite.animation = "Jump"
				pass
			else:
				#animatedSprite.animation = "fall"
				pass
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
