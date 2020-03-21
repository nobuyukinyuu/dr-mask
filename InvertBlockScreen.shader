shader_type canvas_item;
uniform int block_size;

//Invert blocks screen-space shader for reversing invert blocks in the drMask shader after de-scrambling glass blocks.
void fragment()
{
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

	if (block_size>0) {
		// Apply inverted checkerboard pattern.
		ivec2 n = ivec2( vec2(textureSize(SCREEN_TEXTURE, 0)) * UV / vec2(float(block_size)) );
		n.x = n.x % 2;
		n.y = n.y % 2;
		if ((n.x ^ n.y) > 0)  color.rgb = vec3(1.0) - color.bgr;
	}
	
	COLOR = color;
}