shader_type canvas_item;
uniform int bits: hint_range(1, 8) = 4;
void fragment()
{
	//bit crush test.  dr-Mask produces final images of 21-bit fidelity instead of 24.
	float threshold = pow(2.0, float(bits));
	
	vec4 c = texture(TEXTURE, UV);
	
	ivec3 crush = ivec4(c * threshold).rgb;
	c.rgb = vec3(crush) / threshold;
	
	COLOR = c;
}