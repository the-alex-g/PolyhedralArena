extends AudioStreamPlayer3D

@export var delay := 0.0

func _ready()->void:
	await get_tree().create_timer(delay).timeout
	volume_db += randf()
	pitch_scale += randf() - 0.5
