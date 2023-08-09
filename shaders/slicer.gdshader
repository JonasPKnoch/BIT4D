shader_type spatial;
render_mode world_vertex_coords, vertex_lighting, cull_disabled;

global uniform sampler2D slice_map;
global uniform mat4 plane_transform;
global uniform vec4 plane_origin;

uniform sampler3D texture_3d;

uniform mat4 object_transform;
uniform vec4 object_origin;

ivec2 getEdge(int bits1, int bits2) {
	vec4 data = texelFetch(slice_map, ivec2(bits1, bits2), 0); 
	return ivec2(int(data.r*3.0), int(data.g*3.0));
}

vec4 intersection(vec4 p1, vec4 p2) {
	vec4 d = p2 - p1;
	float t = -(-dot(plane_transform[3], plane_origin) + dot(plane_transform[3], p1))/dot(plane_transform[3], d);
	
	return p1 + d*t;
}

vec3 project(vec4 v) {
	return vec3(dot(plane_transform[0], v), dot(plane_transform[1], v), dot(plane_transform[2], v));
	//return (plane_transform * v).xyz;
}

int getID(int id) {
	int index = id%6;
	int second = int(index >= 3);

	return index - second*2;
	//return id%3;
}

void vertex() {
	vec4[] p = {
		object_transform*CUSTOM0 + object_origin, 
		object_transform*CUSTOM1 + object_origin, 
		object_transform*CUSTOM2 + object_origin, 
		object_transform*CUSTOM3 + object_origin};
	int id = getID(VERTEX_ID);
	
	int p1_side = int(dot(p[0] - plane_origin, plane_transform[3]) > 0.0);
	int p2_side = int(dot(p[1] - plane_origin, plane_transform[3]) > 0.0);
	int p3_side = int(dot(p[2] - plane_origin, plane_transform[3]) > 0.0);
	int p4_side = int(dot(p[3] - plane_origin, plane_transform[3]) > 0.0);
	
	
	ivec2 edge = getEdge(p1_side + p2_side*2 + p3_side*4, id + p4_side*4);
	vec4 p1 = p[edge.x];
	vec4 p2 = p[edge.y];
	
	vec4 intersection = intersection(p1, p2);
	
	//VERTEX.y = float(id);
	VERTEX = project(intersection - plane_origin);
	UV = intersection.xy;
	UV2 = intersection.zw;
}

void fragment() {
	NORMAL *= 1.0 - 2.0*float(FRONT_FACING);
	ALBEDO = texture(texture_3d, vec3(UV.x + UV2.y, UV.y + UV2.y, UV2.x + UV2.y)).rgb;
}
