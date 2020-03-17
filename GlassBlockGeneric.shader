shader_type canvas_item;
uniform bool enabled = true;
uniform int block_size = 8;
uniform bool useSalt;
uniform sampler2D salt;


void fragment(){
	
	ivec2 pos = ivec2( vec2(textureSize(TEXTURE, 0)) * UV / float(block_size) );
	ivec2 n = pos;
	
	//Setup the glass block masking.
	vec2 uv = UV;  
	vec2 fpos = (vec2(textureSize(TEXTURE, 0)) * UV);  // Pixel position
	fpos -= vec2(pos * block_size);  //now it's the offset from block origin.

	if (useSalt==false) //Generic glass block texture.
	{
		// Generate generic pattern.
		n.x = n.x % 2;
		n.y = n.y % 2;
		if (n.x+n.y == 1)  //hflip
		{
			//Subtract specified pixel offset from the block origin + blocksize
			uv.x = vec2(pos*block_size + block_size).x - fpos.x;
			uv.x /= float(textureSize(TEXTURE,0).x);
	
		} else if (n.x+n.y == 2) { //vflip
			uv.y = vec2(pos*block_size + block_size).y - fpos.y;
			uv.y /= float(textureSize(TEXTURE,0).y);
	
		} else if (n.x+n.y == 0) { //swizzle + rotate 180 (essentially rotate 270)
//			fpos.xy = fpos.yx;
			uv = vec2(pos*block_size + block_size) - fpos;
			uv /= vec2(textureSize(TEXTURE,0));
		}
		
	} else {  //Use the salt texture to determine how to apply glass block.
		
		//TODO:  DON'T APPLY EFFECT FOR NON-FULLSIZE BLOCKS ON BTM-RIGHT EDGES,
		//		 THIS BREAKS THE ENUMERATION AND DE-MASKING WILL FAIL.  FIXME
		
		//Which pixel are we on in the salt texture?  Presumes a sample on the first row only.
		vec2 pos2 = floor(vec2(textureSize(TEXTURE,0)) * UV / float(block_size));
		int px = int(pos2.y* float(textureSize(TEXTURE,0).x / block_size) + pos2.x)  % textureSize(salt,0).x;
//		int px = (pos.x + pos.y * textureSize(TEXTURE,0).x) % textureSize(salt,0).x;
		vec4 saltval = texture(salt, vec2(float(px) / float(textureSize(salt,0).x) + 0.000001, 0) );
		COLOR.rgb = vec3(0);
		if (saltval.r >= 0.5)  //hflip
		{
			//Subtract specified pixel offset from the block origin + blocksize
			uv.x = vec2(pos*block_size + block_size).x - fpos.x;
			uv.x /= float(textureSize(TEXTURE,0).x);
//			COLOR.r = 1.0;
		} 
		if (saltval.g >= 0.5) { //vflip
			uv.y = vec2(pos*block_size + block_size).y - fpos.y;
			uv.y /= float(textureSize(TEXTURE,0).y);
//			COLOR.g = 1.0;
		}
		if (saltval.b >= 0.5) { //swizzle
			fpos.xy = fpos.yx;
			uv = vec2(pos*block_size) + fpos;
			uv /= vec2(textureSize(TEXTURE,0));
//			COLOR.b = 1.0;
		}
		
	}
		
	vec4 c = texture(TEXTURE, uv);
		
	COLOR.rgb = c.rgb;
	if (!enabled || block_size==0)  COLOR = texture(TEXTURE, UV);
	
}