extends Control
export (float) var zoom = 1.0 setget set_zoom


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func set_zoom(val):
	zoom = val
	var s = String(zoom * 100.0).pad_decimals(1)
	owner.get_node("Zoom").text = s + "%"
	
#	$Preview.rect_size = Vector2.ONE
	$Preview.rect_scale = Vector2.ONE * zoom
	_on_Scroll_resized()



func _input(_ev):
	if Input.is_action_just_pressed("ui_zoom_in"):
		set_zoom(zoom * sqrt(2))
		OS.low_processor_usage_mode = true
	if Input.is_action_just_pressed("ui_zoom_out"):
		set_zoom(zoom / sqrt(2))
		OS.low_processor_usage_mode = true
	if Input.is_action_just_pressed("ui_zoom_reset"):
		set_zoom(1)
		OS.low_processor_usage_mode = true


func _on_Scroll_resized():
	var sz = global.maxv($"..".rect_size, $Preview.rect_size * $Preview.rect_scale)
	rect_min_size = sz

	$Preview.rect_size = Vector2.ONE if !owner.get_node("View") else owner.get_node("View").size
	
	$Preview.rect_position = rect_min_size / 2 - ($Preview.rect_size*$Preview.rect_scale) / 2
	owner.get_node("Zoom/Menu").visible = false

