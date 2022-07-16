extends RigidBody


func _on_Timer_timeout()->void:
	var damage := (randi() % 6) + 1
	for body in $Area.get_overlapping_bodies():
		if body is Enemy:
			body.hit(damage)
	var explosion = load("res://Explosions/Explosion.tscn").instance()
	explosion.translation = translation
	get_parent().add_child(explosion)
	explosion.emitting = true
	queue_free()
