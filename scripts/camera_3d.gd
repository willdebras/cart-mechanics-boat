extends Camera3D


@export var camera_offset = Vector3(0, 1.7, -4.47)  # Camera offset behind the target
@export var lerp_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	pass
	#var target = get_parent()
	#var target_position = target.position
	##var target_position = get_parent().global_position
	#var desired_camera_position = target_position + camera_offset
#
	#var new_position = lerp(position, desired_camera_position, lerp_speed)
#
	#position = new_position
	#look_at(target_position)
