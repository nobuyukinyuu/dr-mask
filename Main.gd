extends Control

func _ready():
	$GlassBlock.material.set_shader_param("salt", $PassPhrase/TextureRect.texture)
	
	pass # Replace with function body.


func _physics_process(delta):
#	var a = 32* sin(Engine.get_frames_drawn()/60.0)
#	$GlassBlock.material.set_shader_param("block_size", a)
	pass


func _on_PassPhrase_text_changed(new_text):
	$Viewport/Sprite.update()
	pass # Replace with function body.
