@tool

class_name Node4D

extends Node

@export var position_4d = Vector4(0, 0, 0, 0):
	set(value):
		position_updated(position_4d, value)
		position_4d = value

var transform_4d = Projection():
	set(value):
		transform_updated(transform_4d, value)
		transform_4d = value

@export var rotation_4d_1 = Vector3(0, 0, 0):
	set(value):
		rotation_4d_1 = value
		set_transform_from_values(rotation_4d_1, rotation_4d_2, scale_4d)
		
@export var rotation_4d_2 = Vector3(0, 0, 0):
	set(value):
		rotation_4d_2 = value
		set_transform_from_values(rotation_4d_1, rotation_4d_2, scale_4d)
		
@export var scale_4d = 1.0:
	set(value):
		scale_4d = value
		set_transform_from_values(rotation_4d_1, rotation_4d_2, scale_4d)

func transform_updated(old, new):
	pass

func position_updated(old, new):
	pass

func position_transform_update():
	transform_updated(transform_4d, transform_4d)
	position_updated(position_4d, position_4d)

func get_xy_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(c, s, 0, 0), Vector4(-s, c, 0, 0), Vector4(0, 0, 1, 0), Vector4(0, 0, 0, 1))

func get_xz_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(c, 0, s, 0), Vector4(0, 1, 0, 0), Vector4(-s, 0, c, 0), Vector4(0, 0, 0, 1))
	
func get_xw_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(c, 0, 0, s), Vector4(0, 1, 0, 0), Vector4(0, 0, 1, 0), Vector4(-s, 0, 0, c))

func get_yz_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(1, 0, 0, 0), Vector4(0, c, s, 0), Vector4(0, -s, c, 0), Vector4(0, 0, 0, 1))

func get_yw_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(1, 0, 0, 0), Vector4(0, c, 0, s), Vector4(0, 0, 1, 0), Vector4(0, -s, 0, c))

func get_zw_rotation_transform(angle):
	var c = cos(angle)
	var s = sin(angle)
	
	return Projection(Vector4(1, 0, 0, 0), Vector4(0, 1, 0, 0), Vector4(0, 0, c, s), Vector4(0, 0, -s, c))

func get_rotation_transform(xy, xz, xw, yz, yw, zw):
	return get_xy_rotation_transform(xy)\
	* get_yz_rotation_transform(yz)\
	* get_xz_rotation_transform(xz)\
	
	* get_xw_rotation_transform(xw)\
	* get_yw_rotation_transform(yw)\
	* get_zw_rotation_transform(zw)

func get_scale_transform(scale):
	return Projection(Vector4(scale, 0, 0, 0), Vector4(0, scale, 0, 0), Vector4(0, 0, scale, 0), Vector4(0, 0, 0, scale))

func set_transform_from_values(rotation_1, rotation_2, scale):
	var xy = rotation_1.z
	var xz = rotation_1.y
	var yz = rotation_1.x
	
	var xw = rotation_2.x
	var yw = rotation_2.y
	var zw = rotation_2.z
	transform_4d = get_rotation_transform(xy, xz, xw, yz, yw, zw)*get_scale_transform(scale_4d)
