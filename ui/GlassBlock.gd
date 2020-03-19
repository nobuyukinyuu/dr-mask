extends ColorRect

export (int, 0, 0xFFFFFF) var block_size setget set_block_size

var useSalt = false setget set_useSalt

func set_useSalt(val):
	useSalt = val
	material.set_shader_param("useSalt", val)
	

func set_block_size(val):
	block_size = val
	
	material.set_shader_param("block_size", val)
	
	if block_size > 1:
		rect_size = ($"..".size / block_size).floor() * block_size
#		rect_size = $"..".size
	else:
		rect_size = Vector2.ZERO
