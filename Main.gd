extends Control

func _ready():
	$GlassBlock.material.set_shader_param("salt", $VBox/TextureRect.texture)
	
	#Setup file menu shortcuts
	$VBox/btnFile/PopupMenu.set_item_shortcut(0, preload("res://ui/SrcShortcut.tres"), true)
	$VBox/btnFile/PopupMenu.set_item_shortcut(1, preload("res://ui/DestShortcut.tres"), true)
	$VBox/btnFile/PopupMenu.set_item_shortcut(3, preload("res://ui/SaveShortcut.tres"), true)
	

	var sq2 = sqrt(2) 
	for i in 7:
		var z = 0.25 * pow(sq2,i*2)
		$Zoom.set_meta(String(i), z)  #We'll need these values to set zoom later.
		
		
		var s = String(z*100).pad_decimals(1) + "%"
		$Zoom/Menu.add_item(s,i)
	$Zoom/Menu.rect_size = Vector2.ONE #Force a resize event before first popup.
	yield(get_tree(),"idle_frame")
	$Scroll/C.zoom = 1


func _on_PassPhrase_text_changed(new_text):
	$PassView/Sprite.update()  #Update the salt texture.

	$View/GlassBlock.useSalt = not $VBox/PassPhrase.text.empty()


#File menu
func _on_Button_pressed():
	$VBox/btnFile/PopupMenu.popup(Rect2(64,48,16,16))


func _on_Zoom_pressed():
	$Zoom/Menu.popup(Rect2($Zoom.rect_position-$Zoom/Menu.rect_size, Vector2.ONE))

func _on_Zoom_Menu_index_pressed(index):
	$Scroll/C.zoom = $Zoom.get_meta(String(index))
	pass # Replace with function body.


func _on_SpinGlass_value_changed(value):
	$View/GlassBlock.block_size = value
