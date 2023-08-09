extends Node

@onready var cube = $Mesh4D
@onready var rot_transform = cube.get_xw_rotation_transform(PI/100)


func _process(delta):
	cube.transform_4d *= rot_transform
