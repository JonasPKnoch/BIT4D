@tool

class_name DebugCamera4D

extends Camera4D

@onready var debug_label = $UI/Label
@onready var coords_label = $UI/CoordsLabel

var velocity = Vector4.ZERO
var look_3d = Vector2()
var heading_4d = 0

func _ready():
	if Engine.is_editor_hint():
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Engine.is_editor_hint():
		return
	
	if event is InputEventMouseMotion:
		look_3d += event.relative*0.01
		look_3d.y = clamp(look_3d.y, -PI*0.5, PI*0.5)

func _process(delta):
	if Engine.is_editor_hint():
		return
	coords_label.text = str(position_4d.snapped(Vector4(0.1, 0.1, 0.1, 0.1)))
	
	if Input.is_action_pressed("rotate_kata"):
		heading_4d += 0.01
	if Input.is_action_pressed("rotate_ana"):
		heading_4d -= 0.01
		
	transform_4d = get_zw_rotation_transform(heading_4d)*get_xz_rotation_transform(look_3d.x)*get_yz_rotation_transform(-look_3d.y)
	
	var input_direction = Vector4.ZERO
	var basis_x = transform_4d.x
	var basis_z = transform_4d.z
	var basis_w = transform_4d.w
	
	if Input.is_action_pressed("forward"):
		input_direction -= basis_z
	if Input.is_action_pressed("backward"):
		input_direction += basis_z
	if Input.is_action_pressed("left"):
		input_direction -= basis_x
	if Input.is_action_pressed("right"):
		input_direction += basis_x
	if Input.is_action_pressed("ana"):
		input_direction -= basis_w
	if Input.is_action_pressed("kata"):
		input_direction += basis_w
	
	if Input.is_action_pressed("up"):
		input_direction.y += 1
	if Input.is_action_pressed("down"):
		input_direction.y -= 1
	
	velocity = lerp(velocity, input_direction*2, 0.1)
	
	position_4d += velocity*delta
