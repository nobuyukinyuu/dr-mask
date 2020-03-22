extends ScrollContainer



func _input(event):
	if event is InputEventMouseMotion:
#		print(event)
		if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			scroll_horizontal -= event.relative.x
			scroll_vertical -= event.relative.y
			

func _gui_input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			owner.low_processor_mode(false)
			scroll_horizontal -= event.relative.x
			scroll_vertical -= event.relative.y

	
	elif event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_WHEEL_DOWN:
				$C.zoom /= sqrt(2)
				OS.low_processor_usage_mode = true
			BUTTON_WHEEL_UP:
				$C.zoom *= sqrt(2)
				OS.low_processor_usage_mode = true
			_:
				pass
			#Scroll wheel.  Consume the event.


		get_tree().set_input_as_handled()

#		scroll_horizontal_enabled = false
#		scroll_vertical_enabled = false
#		yield(get_tree(),"idle_frame")
#		scroll_horizontal_enabled = true
#		scroll_vertical_enabled = true
