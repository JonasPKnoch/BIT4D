@tool

class_name Mesh4D

extends Node4D

@export var texture_3d: Texture3D

@onready var mesh_instance = $MeshInstance3D

var material_4d: ShaderMaterial = null
var loaded = false

@export_file var mesh_4D_path: String:
	set(path):
		mesh_4D_path = path
		
		if Engine.is_editor_hint():
			load_mesh_from_path(path)
	get:
		return mesh_4D_path	
		
func _ready():
	if not loaded:
		load_mesh_from_path(mesh_4D_path)

func load_mesh_from_path(path):	
	var mesh_4d = Mesh4DFromFile.new(self, path, texture_3d)
	mesh_instance.mesh = mesh_4d
	material_4d = mesh_4d.material_4d
	loaded = true
	position_transform_update()
	

func transform_updated(old, new):	
	if loaded:
		material_4d.set_shader_parameter("object_transform", new)

func position_updated(old, new):	
	if loaded:
		material_4d.set_shader_parameter("object_origin", new)
	


