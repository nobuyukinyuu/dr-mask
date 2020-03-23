extends Viewport

#func load_src(path):
#	pass
#
#func load_dest(path):
#	pass
	
	
func _ready():
	reload()
	
func reload():
	#Note that if the viewport of $Dest updated size, it won't show up on our
	#own viewport until it's manually redrawn for some reason. TODO: Report bug?
	if $Src.texture and $Dest.texture:
		$Dest.update()
		size = global.maxv($Src.texture.get_size(), $Dest.texture.get_size())
	elif $Src.texture:
		size = $Src.texture.get_size()
	elif $Dest.texture:
		$Dest.update()
		size = $Dest.texture.get_size()
	else:
		return
	
	
	for o in get_children():
		if o is ColorRect and o.is_in_group("GlassBlock"):
			o.rect_size = size

