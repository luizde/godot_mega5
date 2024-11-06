shader_type canvas_item;

uniform vec4 origin:source_color;
//uniform vec4 new:hint_color;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	
	//if (current_pixel == origin)
	if (lessThan(vec4(0.8),abs(current_pixel - origin))==bvec4(false))
		COLOR.a = 0.0;
	else
		COLOR = current_pixel;
}