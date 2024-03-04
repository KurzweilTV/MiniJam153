extends RigidBody2D


func _ready() -> void:
	self.rotation_degrees = randf_range(0, 360)
