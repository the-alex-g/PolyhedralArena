extends RigidBody

func _ready()->void:
	$AudioStreamPlayer3D.unit_db += randf() - 0.5
	$AudioStreamPlayer3D.pitch_scale += randf() - 0.5


func _on_Timer_timeout()->void:
	var damage := (randi() % 6) + 1
	for body in $Area.get_overlapping_bodies():
		if body is Enemy:
			body.hit(damage)
	var explosion = load("res://Effects/Explosion.tscn").instance()
	explosion.translation = translation
	get_parent().add_child(explosion)
	explosion.emitting = true
	var floating_text = load("res://Effects/FloatingText.tscn").instance()
	floating_text.translation = translation
	get_parent().add_child(floating_text)
	floating_text.set_deferred("text", str(damage))
	queue_free()
