extends Node3D

@onready var ball = $Ball
@onready var boat_mesh = $Boat
@onready var ground_ray = $Boat/RayCast3D
@onready var body_mesh = $"Boat/boat-row-large"

@export var sphere_offset = Vector3(0, -0.5, 0)
@export var acceleration = 50
@export var max_speed = 200
@export var steering = 10.0
@export var turn_speed = 5
@export var turn_stop_limit = 0.75
@export var body_tilt_x = 10
@export var body_tilt_y = 2


# variables for input values
var speed_input = 0
var rotate_input = 0
var previous_position = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ground_ray.add_exception(ball)

func _physics_process(delta: float) -> void:
	boat_mesh.transform.origin = ball.transform.origin + sphere_offset
	# apply physics in direction mesh is facing
	ball.apply_central_force(boat_mesh.global_transform.basis.z * speed_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Can't steer/accelerate when in the air
	#if not ground_ray.is_colliding():
		#return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg_to_rad(steering)
	
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = boat_mesh.global_transform.basis.rotated(boat_mesh.global_transform.basis.y,
				rotate_input)
		boat_mesh.global_transform.basis = boat_mesh.global_transform.basis.slerp(new_basis,
				turn_speed * delta)
		boat_mesh.global_transform = boat_mesh.global_transform.orthonormalized()
		
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt_x
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 10 * delta)
		body_mesh.rotation.z = clamp(body_mesh.rotation.z, deg_to_rad(-20), deg_to_rad(20))
		var z = (-speed_input) / 1000 * ball.linear_velocity.length() / body_tilt_y
		body_mesh.rotation.x = lerp(body_mesh.rotation.x, z, 10 * delta)
		body_mesh.rotation.x = clamp(body_mesh.rotation.x, deg_to_rad(-16), deg_to_rad(4))
	
	# align with ground
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(boat_mesh.global_transform, n.normalized())
	boat_mesh.global_transform = boat_mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
