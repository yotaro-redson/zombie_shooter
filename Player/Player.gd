extends CharacterBody3D

var speed
const WALK_SPEED = 3
const RUN_SPEED = 5.0
const JUMP_VELOCITY = 3.5
const SENSITIVITY = 0.003

const base_fov = 75.0
const fov_change = 1.5

var gravity = 10.0
@onready var head = $Head
@onready var camera = $Head/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x =clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	if Input.is_action_pressed("sprint"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():	
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x =lerp(velocity.x, direction.x * speed, delta * 6.5)
			velocity.z =lerp(velocity.z, direction.z * speed, delta * 6.5)
	else:
		velocity.x =lerp(velocity.x, direction.x * speed, delta * 2.5)
		velocity.z =lerp(velocity.z, direction.z * speed, delta * 2.5)
		
		
	#fov
	var velocity_clamped = clamp(velocity.length(), 0.5 , RUN_SPEED *2)
	var target_fov = base_fov+ fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	move_and_slide()


