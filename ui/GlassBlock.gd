extends ColorRect

export (int, 0, 0xFFFFFF) var block_size setget set_block_size

func set_block_size(val):
	block_size = val
	
	material.set_shader_param("block_size", val)
	
	if block_size > 1:
		rect_size = ($"..".size / block_size).floor() * block_size
	else:
		rect_size = Vector2.ZERO
