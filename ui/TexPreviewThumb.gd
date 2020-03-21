extends TextureRect

signal blip

#var mouse_inside:bool setget set_mouse_inside
#
#func set_mouse_inside(val):
#	print ("blep", val)
#	mouse_inside = val
#
#func _ready():
#	connect("mouse_entered", self, "set_mouse_inside", [true])
#	connect("mouse_exited", self, "set_mouse_inside", [false])


#Handles right clicking and emits a blip
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			emit_signal("blip")

