extends Spatial

var text := "" setget _set_text


func _set_text(value:String)->void:
	$Viewport/Label.text = value
