extends Node


func create_item(popup:PopupMenu, label:String, scancode:int, meta, ctrl:bool = false, alt:bool = false, shift:bool = false):
	var ev = InputEventKey.new()
	ev.scancode = scancode
	ev.meta = false
	if OS.get_name() == "OSX":
		ev.command = ctrl
	else:
		ev.control = ctrl
	ev.alt = alt
	ev.shift = shift
	var shortcut = ShortCut.new()
	shortcut.resource_name = label
	shortcut.shortcut = ev
	popup.add_shortcut(shortcut)
	popup.set_item_metadata(popup.get_item_count() - 1, meta)




func maxv(a:Vector2, b:Vector2):
	var c = Vector2.ZERO
	c.x = max(a.x, b.x)
	c.y = max(a.y, b.y)
	return c
