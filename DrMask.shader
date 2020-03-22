shader_type canvas_item;
uniform bool enabled = true;
uniform bool unmask;
uniform sampler2D salt;
uniform int block_size = 8;

bool approx_equal(float a,float b){
	return (abs(a - b)) < 0.00001;
}

void fragment() {
	vec2 texSz = vec2(654, 1155);

	vec4 c = textureLod(TEXTURE, UV, 0);
	vec4 bg = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0);


	//Convert UV to position on texture
	vec2 uv2 = vec2(textureSize(TEXTURE,0)) * UV; //UV position, in pixels, of sampled tex.

	vec2 saltRatio = vec2(textureSize(TEXTURE, 0)) / vec2(textureSize(salt, 0));
	vec2 saltpos = saltRatio * UV;  // Un modulus'd position to sample from the salt, in px.
	vec4 saltColor = texture(salt, saltpos);

	vec4 diff = vec4(0.5);
	diff.a = 1.0;

	if (!unmask) {
		//Get the typical diff.
		diff.rgb += (bg.rgb - c.rgb) * 0.5;
		
		//Now salt it.
		diff.rgb = mod(saltColor.rgb + diff.rgb, vec3(1.0));
	} else {    //unmask mode
		diff.rgb = -c.rgb*2.0 + bg.rgb + vec3(1);
//		diff.rgb = mod(bg.rgb - c.rgb, vec3(1.000001));
	}
	 
	// Apply inverted checkerboard pattern.
	if (block_size > 0){
		ivec2 n = ivec2( vec2(textureSize(TEXTURE, 0)) * UV / vec2(float(block_size)) );
		n.x = n.x % 2;
		n.y = n.y % 2;
		if ((n.x ^ n.y) > 0)  diff.rgb = 1.0-diff.bgr;
		
	}

	COLOR = diff;
	if (!enabled) COLOR = c;
}