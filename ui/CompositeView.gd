extends Viewport

func load_src(path):
	pass
	
func load_dest(path):
	pass
	
	
func _ready():
	size = $Src.texture.get_size()
	
	for o in get_children():
		if o is ColorRect and o.is_in_group("GlassBlock"):
			o.rect_size = size
