extends CPUParticles3D

var _time := 0.0


func _ready()->void:
	emitting = true


func _process(delta)->void:
	if not emitting:
		queue_free()
	if _time < 1:
		_time += delta * speed_scale
	var custom_color = lerp(Color.YELLOW, Color.ORANGE_RED, _time)
	mesh.material.albedo_color = custom_color
