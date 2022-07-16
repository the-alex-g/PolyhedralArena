extends CPUParticles

var _time := 0.0


func _ready()->void:
	emitting = true


func _process(delta)->void:
	if not emitting:
		queue_free()
	if _time < 1:
		_time += delta * speed_scale
	var custom_color = lerp(Color.yellow, Color.red, _time)
	mesh.material.albedo_color = custom_color
