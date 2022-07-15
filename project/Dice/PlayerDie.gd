extends KinematicBody

export var speed := 200

func _physics_process(delta:float)->void:
	rotation_degrees.y += Input.get_axis("right", "left") * 2
	var direction := Vector3(0, 0, Input.get_axis("backward", "forward")).rotated(Vector3.UP, rotation.y)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * speed)
