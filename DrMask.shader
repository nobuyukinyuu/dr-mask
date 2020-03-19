shader_type canvas_item;
uniform bool unmask;
uniform sampler2D salt;
uniform int block_size = 8;

void fragment() {
	vec2 texSz = vec2(654, 1155);

	vec4 c = texture(TEXTURE, UV);
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);


	//Convert UV to position on texture
	vec2 uv2 = vec2(textureSize(TEXTURE,0)) * UV; //UV position, in pixels, of sampled tex.

	vec2 saltRatio = vec2(textureSize(TEXTURE, 0)) / vec2(textureSize(salt, 0));
	vec2 saltpos = saltRatio * UV;  // Un modulus'd position to sample from the salt, in px.
	vec4 saltColor = texture(salt, saltpos);


	//Get the typical diff.
	vec4 diff = vec4(0.5);
	diff.a = 1.0;
	diff.rgb += bg.rgb - c.rgb;


	//Now salt it.
	diff.rgb = mod(saltColor.rgb + diff.rgb, vec3(1.0));

	
	ivec2 n = ivec2( vec2(textureSize(TEXTURE, 0)) * UV / vec2(float(block_size)) );

	n.x = n.x % 2;
	n.y = n.y % 2;
	if ((n.x ^ n.y) > 0)  diff.rgb = 1.0-diff.bgr;
 	

	COLOR = diff;
}