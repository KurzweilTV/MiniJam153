extends CharacterBody2D

var accelerating: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if accelerating:
		position.x += 1
		sprite.play("drive")
		
	else:
		sprite.stop()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accelerate"):
		accelerating = true
		$Smoke.emitting = true
		$SmokeIdle.emitting = false
		print($Smoke.emitting)
	if Input.is_action_just_released("accelerate"):
		accelerating = false
		$Smoke.emitting = false
		$SmokeIdle.emitting = true
		print($Smoke.emitting)
