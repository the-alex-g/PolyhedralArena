extends Node3D

var text := "": set = _set_text


func _set_text(value:String)->void:
	$SubViewport/Label.text = value
