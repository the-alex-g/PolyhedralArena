class_name Player
extends KinematicBody

export var speed := 15


func _physics_process(delta:float)->void:
	rotation_degrees.y += Input.get_axis("turn_right", "turn_left") * 2
	var direction := Vector3(Input.get_axis("right", "left"), 0, Input.get_axis("backward", "forward")).rotated(Vector3.UP, rotation.y)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * speed)
