extends Node2D

const IDLE_POS = Vector2(-40, 40)
const CRANE_LENGTH = 600.0

@onready var crane_mount = $Body/Mount
@onready var magnet_mount = $Magnet/Mount
@onready var chain = $Chain
@onready var magnet: Sprite2D = $Magnet

var extension_speed: float = 80
var extending : bool = false
var retracting : bool = false
var lean_amount : = 8.0

func _ready():
	chain.points = [Vector2.ZERO, Vector2.ZERO]

func _physics_process(delta: float) -> void:
	chain.points[0] = chain.to_local(crane_mount.global_position)
	chain.points[1] = chain.to_local(magnet_mount.global_position)
	
	var move_x = 0
	var move_y = 0
	var is_moving = false

	if Input.is_action_just_pressed("toggle_deploy") and not Truck.deployed:
		reset_magnet()
	if Input.is_action_just_pressed("reel_in") and Truck.deployed:
		reset_magnet()
		
	# Handle vertical movement (in and out)
	if Input.is_action_pressed("crane_out") and Truck.deployed:
		move_y += extension_speed * delta
	if Input.is_action_pressed("crane_in") and Truck.deployed:
		move_y -= extension_speed * delta

	# Handle horizontal movement (left and right)
	if Input.is_action_pressed("crane_left") and Truck.deployed:
		move_x -= extension_speed * delta
		lean_magnet(-lean_amount)
		is_moving = true
	if Input.is_action_pressed("crane_right") and Truck.deployed:
		move_x += extension_speed * delta
		lean_magnet(lean_amount)
		is_moving = true
		
	if not is_moving: lean_magnet(0)
	is_moving = false

	# handle crane movement
	var new_position = magnet.position + Vector2(move_x, move_y)
	new_position.x = clamp(new_position.x, IDLE_POS.x - 225, IDLE_POS.x + 150) #distance crane can move left/right
	new_position.y = clamp(new_position.y, IDLE_POS.y, IDLE_POS.y + CRANE_LENGTH)

	magnet.position = new_position


func lean_magnet(lean) -> void:
	var tween = create_tween()
	tween.tween_property(magnet, "rotation_degrees", lean, 0.2)

func reset_magnet() -> void:
	var tween = create_tween()
	tween.tween_property(magnet, "position", IDLE_POS, 1.5)
