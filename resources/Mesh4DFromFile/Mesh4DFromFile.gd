@tool

class_name Mesh4DFromFile

extends ArrayMesh

var shader = preload("res://shaders/slicer.gdshader")

@export var material_4d: ShaderMaterial = null

var verts = []
var indices = []

func _init(node4D, path, texture_3d):
	load4DM(path)
	generateMesh(node4D, texture_3d)

func load4DM(path):
	verts = []
	indices = []
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	var header = file.get_line().split(" ")
	if len(header) != 3 or header[0] != "4DMesh":
		push_error("4DMesh files must begin with correct header")
	
	for i in range(int(header[1])):
		var verts_line = file.get_line().split(" ")
		if len(verts_line) != 4:
			push_error("Each line of coordinates must have length 4")
		
		verts.append(Vector4(\
		float(verts_line[0]), float(verts_line[1]), float(verts_line[2]), float(verts_line[3])))
	
	for i in range(int(header[2])):
		var indices_line = file.get_line().split(" ")
		if len(indices_line) != 4:
			push_error("Each line of indices must have length 4")
		
		indices.append(int(indices_line[0]))
		indices.append(int(indices_line[1]))
		indices.append(int(indices_line[2]))
		indices.append(int(indices_line[3]))

func generateMesh(node_4d, texture_3d):
	clear_surfaces()
	custom_aabb = AABB(Vector3(0, 0, -1), Vector3(1, 1, 1))
	
	var mat = ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("object_transform", node_4d.transform_4d)
	mat.set_shader_parameter("object_origin", node_4d.position_4d)
	mat.set_shader_parameter("texture_3d", texture_3d)
	self.material_4d = mat
	
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_custom_format(0, SurfaceTool.CUSTOM_RGBA_FLOAT)
	surface_tool.set_custom_format(1, SurfaceTool.CUSTOM_RGBA_FLOAT)
	surface_tool.set_custom_format(2, SurfaceTool.CUSTOM_RGBA_FLOAT)
	surface_tool.set_custom_format(3, SurfaceTool.CUSTOM_RGBA_FLOAT)

	var r = Color(1, 0, 0)
	var g = Color(0, 1, 0)
	var b = Color(0, 0, 1)
	var y = Color(1, 1, 0)
	var black = Color(0, 0, 0)
	var colors = [r, g, b, black]

	for i in range(0, len(indices), 4):
		var p1 = verts[indices[i]]
		var p2 = verts[indices[i + 1]]
		var p3 = verts[indices[i + 2]]
		var p4 = verts[indices[i + 3]]
	
		for verts in [[p1, p2, p3], [p2, p3, p4]]:
			for p in verts:
				surface_tool.set_custom(0, Color(p1.x, p1.y, p1.z, p1.w))
				surface_tool.set_custom(1, Color(p2.x, p2.y, p2.z, p2.w))
				surface_tool.set_custom(2, Color(p3.x, p3.y, p3.z, p3.w))
				surface_tool.set_custom(3, Color(p4.x, p4.y, p4.z, p4.w))
				surface_tool.set_smooth_group(-1)
				surface_tool.set_uv(Vector2(p.x, p.y))
				surface_tool.set_uv2(Vector2(p.z, p.w))
				surface_tool.set_normal(Vector3(0, 1, 0))
				surface_tool.add_vertex(Vector3(p.x + p.w, p.y + p.w, p.z + p.w))
		
		#surface_tool.add_index(i)
		#surface_tool.add_index(i + 1)
		#surface_tool.add_index(i + 2)
		
		#surface_tool.add_index(i + 1)
		#surface_tool.add_index(i + 2)
		#surface_tool.add_index(i + 3)
		
	#surface_tool.generate_normals()
	surface_tool.set_material(mat)
	surface_tool.commit(self)
