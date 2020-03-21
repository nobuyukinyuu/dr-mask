extends Control
const nothing = preload("res://ui/nothing.png")


func _ready():

	#Debug?
#	$GlassBlock.material.set_shader_param("salt", $VBox/TextureRect.texture)

	#Setup drag and drop.
	get_tree().connect("files_dropped", self, "_on_files_dropped")
	
	#Setup file menu shortcuts
	var popup = $VBox/btnFile.get_popup()
	popup.add_stylebox_override("panel", preload("res://ui/PopupMenu.stylebox"))
	popup.set_item_shortcut(0, preload("res://ui/SrcShortcut.tres"), true)
	popup.set_item_shortcut(1, preload("res://ui/DestShortcut.tres"), true)
	popup.set_item_shortcut(3, preload("res://ui/SaveShortcut.tres"), true)

	popup.connect("index_pressed", self, "_on_FileMenu_index_pressed")
	
	#Set up the Image right click quick load signals
	$VBox/SrcTex.connect("blip", self, "_on_FileMenu_index_pressed", [0])
	$VBox/DestTex.connect("blip", self, "_on_FileMenu_index_pressed", [1])
	
	#Set up the zoom control.
	var sq2 = sqrt(2) 
	for i in 7:
		var z = 0.25 * pow(sq2,i*2)
		$Zoom.set_meta(String(i), z)  #We'll need these values to set zoom later.
		
		
		var s = String(z*100).pad_decimals(1) + "%"
		$Zoom/Menu.add_item(s,i)
	$Zoom/Menu.rect_size = Vector2.ONE #Force a resize event before first popup.
	yield(get_tree(),"idle_frame")
	$Scroll/C.zoom = 1


func _on_PassPhrase_text_changed(_new_text):
	$PassView/Sprite.update()  #Update the salt texture.

	$View/GlassBlock.useSalt = not $VBox/PassPhrase.text.empty()


#File menu
func _on_btnFile_pressed():
	pass



func _on_Zoom_pressed():
	$Zoom/Menu.popup(Rect2($Zoom.rect_position-$Zoom/Menu.rect_size, Vector2.ONE))

func _on_Zoom_Menu_index_pressed(index):
	$Scroll/C.zoom = $Zoom.get_meta(String(index))
	pass # Replace with function body.



func _on_SpinInvert_value_changed(value):
	var loc 
	if $VBox/chkEncode.pressed:
		loc = $View/InvertBlock
	else:
		loc = $Decoder/InvertBlock
		
	loc.material.set_shader_param("block_size", value)

func _on_SpinGlass_value_changed(value):
	$View/GlassBlock.block_size = value



func _on_FileMenu_index_pressed(index):
	#Turn off low processor mode, otherwise the viewports will update lazily
	OS.low_processor_usage_mode = false

	#Refresh files list.
	$SaveDialog.invalidate()
	$OpenDialog.invalidate()
	$OpenDialog2.invalidate()

	match index:
		0:  #Source img
			$OpenDialog.popup_centered()
			pass
		1:  #Dest img
			$OpenDialog2.popup_centered()
			pass
		3:  #Save output
			$SaveDialog.popup_centered()
			pass
		5:  #Clear dest
			$VBox/DestTex.texture = nothing
			reload_preview()

func _on_files_dropped(files, _screen):
	OS.low_processor_usage_mode = false
	#Load image.
	var tex:ImageTexture = tryLoadImg(files[0])

	if !tex:  return
	
	#Find where to drag
	var sr = Rect2($VBox/SrcTex.rect_position,$VBox/SrcTex.rect_size)
	var sd = Rect2($VBox/DestTex.rect_position,$VBox/DestTex.rect_size)
	
	if sr.has_point(get_local_mouse_position()):
		print ("Loading source image...")
		$VBox/SrcTex.texture = tex
		
		if files.size() > 1:
			var tex2:ImageTexture = tryLoadImg(files[1])
			if !tex2:  return
			$VBox/DestTex.texture = tex2
	if sd.has_point(get_local_mouse_position()):
		print ("Loading diff image...")
		$VBox/DestTex.texture = tex
			
	reload_preview()


func tryLoadImg (path):
	var tex:ImageTexture = ImageTexture.new()
	var err = tex.load(path)
	
	if err != OK:  #Problem
		var s = String(err)
		match err:
			ERR_FILE_ALREADY_IN_USE:
				s = "File already in use"
			ERR_FILE_CANT_OPEN, ERR_FILE_CANT_READ:
				s = "File can't be opened for read"
			ERR_FILE_CORRUPT:
				s = "The file is corrupt"
			ERR_FILE_NO_PERMISSION:
				s = "Permission denied"
			ERR_FILE_UNRECOGNIZED: 
				s = "Unrecognized file format "
				s += path.right(path.find_last("."))
				
		print("Error loading dragDrop file: %s (%s)" % [s,err])
		OS.alert("Error loading dragDrop file: %s (%s)" % [s,err], "Error")
		return

	return tex


func _on_OpenDialog_file_selected(path):  #Src image
	var tex:ImageTexture = tryLoadImg(path)
	if !tex:  return

	$VBox/SrcTex.texture = tex
	reload_preview()
	
func _on_OpenDialog2_file_selected(path):  #Dest image
	var tex:ImageTexture = tryLoadImg(path)
	if !tex:  return

	$VBox/DestTex.texture = tex
	reload_preview()

func _on_SaveDialog_file_selected(path):
	
	var s = ""
	var err = $View.get_texture().get_data().save_png(path)

	match err:
		OK:
			print("File saved.")
			return
		ERR_FILE_ALREADY_IN_USE:
			s = "File already in use"
		ERR_FILE_CANT_OPEN, ERR_FILE_CANT_WRITE:
			s = "File can't be opened for writing"
		ERR_FILE_CORRUPT:
			s = "The file is corrupt"
		ERR_FILE_NO_PERMISSION:
			s = "Permission denied"
		ERR_FILE_UNRECOGNIZED: 
			s = "Unrecognized file format "
			s += path.right(path.find_last("."))
		ERR_FILE_BAD_PATH:
			s = "Bad path"
			
	print("Error loading dragDrop file: %s (%s)" % [s,err])
	OS.alert("Error loading dragDrop file: %s (%s)" % [s,err], "Error")


func reload_preview():
	$View/Src.texture = null
	$Decoder/Diff.texture = null
	
	if $VBox/SrcTex.texture != nothing: 
		$View/Src.texture = $VBox/SrcTex.texture.duplicate()
		$View/Src.texture.flags = 0  #No filter, no mipmap
	if $VBox/DestTex.texture != nothing: 
		$Decoder/Diff.texture = $VBox/DestTex.texture.duplicate()
		$Decoder/Diff.texture.flags = 0  #No filter, no mipmap
	
	$Decoder.reload()
	$View.reload()
	$Scroll/C.rect_size = Vector2.ONE
	$Scroll/C.zoom = 1

	#Wait a second to resume low processor usage mode.
	yield(get_tree().create_timer(0.2), "timeout")
	OS.low_processor_usage_mode = true

func _on_chkEncode_toggled(button_pressed):
	#Disable low processor mode for a second to let the images update themselves.
	OS.low_processor_usage_mode = false
	
	$View/Dest.material.set_shader_param("unmask", !button_pressed)
	
	for o in $View.get_children():
		if o.is_in_group("GlassBlock"):
			o.visible = button_pressed
	for o in $Decoder.get_children():
		if o.is_in_group("GlassBlock"):
			o.visible = !button_pressed

