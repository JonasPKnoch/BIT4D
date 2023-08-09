@tool

class_name Camera4D

extends Node4D

func transform_updated(old, new):
	RenderingServer.global_shader_parameter_set("plane_transform", new)

func position_updated(old, new):
	RenderingServer.global_shader_parameter_set("plane_origin", new)
