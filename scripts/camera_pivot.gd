extends Node3D

var direction = Vector3.FORWARD

const JOY_DEADZONE : float = 0.25
const JOY_V_SENS : float = 0.2
const JOY_H_SENS : float = 0.2
const JOY_AXIS_2 : int = 2
const JOY_AXIS_3 : int = 3

var rot_x = 0
var rot_y = 0
var LOOKAROUND_SPEED = 0.001
var has_controller = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init():
	has_controller = Input.get_connected_joypads().size() > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(LOOKAROUND_SPEED))
	rotation.x += deg_to_rad(LOOKAROUND_SPEED)
	rotation.x =clamp(rotation.x,deg_to_rad(-90),deg_to_rad(90))

func _input(event):
	if event is InputEventMouseMotion and event.button_mask & 1:
	# modify accumulated mouse rotation
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
		
	if event is InputEventJoypadMotion and has_controller:
		print(event.get_axis())
		if event.get_axis() == JOY_AXIS_2:
			if abs(event.get_axis_value()) > JOY_DEADZONE:
				rotation.y = (event.get_axis_value() * JOY_H_SENS)
			else:
				rotation.y = 0
		elif event.get_axis() == JOY_AXIS_3:
			if abs(event.get_axis_value()) > JOY_DEADZONE:
				rotation.x = (event.get_axis_value() * JOY_V_SENS)
			else:
				rotation.x = 0
				
#func _physics_process(delta: float) -> void:
	#var current_velocity = get_parent().get_parent().get_node('Ball').get_linear_velocity()
	#current_velocity.y = 0
	#print(get_parent().global_transform)
	#
	##global_transform.basis = global_transform.basis.slerp(current_velocity, 0.5)
	#direction = lerp(direction, -current_velocity.normalized(), 2.5 * delta)
	## set rotation of camera_pivot to the point in the direction vector
	## rotation basis weird
	#global_transform.basis = get_rotation_from_direction(direction)
	#
#func get_rotation_from_direction(look_direction: Vector3) -> Basis:
	#look_direction = look_direction.normalized()
	## cross product world UP
	#var x_axis = look_direction.cross(Vector3.UP)
	#return Basis(x_axis, Vector3.UP, -look_direction)
