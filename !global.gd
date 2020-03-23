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


func beep():
	if OS.is_debug_build():
		printraw (PoolByteArray([0x07]).get_string_from_ascii())
	else:
		make_beep()

func make_beep():
	if !get_node_or_null("beep"):
		var node = AudioStreamPlayer.new()
		node.name = "beep"
		node.volume_db = -12.0
		add_child(node, true)
	
		var a = AudioStreamSample.new()
		a.format =AudioStreamSample.FORMAT_8_BITS
		a.mix_rate =44100
	
		var data = PoolByteArray([])
		var length = a.mix_rate * 0.2  #200ms
		var phase = 0.0
		var DING_FREQUENCY = 800.0  #Windows ding.wav frequency lol
		var increment = 1.0/(a.mix_rate/DING_FREQUENCY)
	
		for i in range(length):
			var percent = i/length
			var LFO = increment*-sin(percent*TAU)*10 + phase
	
			var byte = (128.0*pow(1-percent, 4) * sin(TAU*LFO) ) 
			phase = fmod(phase+increment, 1.0)
			
			data.append( byte )
			
		a.data = data
		node.stream = a 
	
	get_node("beep").play()

func buzzer():
	if !get_node_or_null("buzz"):
		var node = AudioStreamPlayer.new()
		node.name = "buzz"
		node.volume_db = -12.0
		add_child(node, true)
	
		var a = AudioStreamSample.new()
		a.format =AudioStreamSample.FORMAT_8_BITS
		a.mix_rate =44100
	
		var data = PoolByteArray([])
		var length = a.mix_rate * 0.15  #200ms
		var phase = 0.0
		var DING_FREQUENCY = 100.0  
		var increment = 1.0/(a.mix_rate/DING_FREQUENCY)
	
		for i in range(length):
			var percent = i/length
	
			var byte = (128.0*pow(1-percent, 4) * (phase) ) 
			phase = fmod(phase+increment, 1.0)
			
			data.append( byte )
			
		a.data = data
		node.stream = a 
	
	get_node("buzz").play()
