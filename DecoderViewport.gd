extends Viewport
#This viewport is for applying inverse and glass block effects in the diff tex
#Before it gets passed to drMask for reprocessing.
#Effects should be in reverse order of the encode process.  ie:
# GlassBlock 2 (large pass), GlassBlock (small pass), invert checkerboard/swiz.


func _ready():
	reload()
	
func reload():
	#Note that if the viewport of $Dest updated size, it won't show up on our
	#own viewport until it's manually redrawn for some reason. TODO: Report bug?
	if $Diff.texture:
		size = $Diff.texture.get_size()
		$Diff.update()
	else:
		return
	
	
	for o in get_children():
		if o is ColorRect and o.is_in_group("GlassBlock"):
			o.rect_size = size
