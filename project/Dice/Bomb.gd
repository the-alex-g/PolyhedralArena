extends RigidBody3D


func _on_Timer_timeout()->void:
	var damage := randi_range(1, 6)
	for body in $Area3D.get_overlapping_bodies():
		if body is Enemy:
			body.hit(damage)
	var explosion = load("res://Effects/Explosion.tscn").instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	var floating_text = load("res://Effects/FloatingText.tscn").instantiate()
	floating_text.position = position
	get_parent().add_child(floating_text)
	floating_text.set_deferred("text", str(damage))
	queue_free()
