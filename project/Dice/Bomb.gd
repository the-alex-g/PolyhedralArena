extends RigidBody


func _on_Timer_timeout()->void:
	var damage := (randi() % 6) + 1
	for body in $Area.get_overlapping_bodies():
		if body is Enemy:
			body.hit(damage)
	queue_free()
