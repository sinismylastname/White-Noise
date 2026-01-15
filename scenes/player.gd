extends CharacterBody3D

@onready var button_left = $Camera3D/PlayerUI/Left
@onready var button_right = $Camera3D/PlayerUI/Right
@onready var camera = $Camera
@onready var flashlight = $Camera/Flashlight

var target_rotation_y: float = 0.0
var max_velocity_z: float = 20.0
var able_to_turn: bool = true
var able_to_move:bool = true
var current_angle: float


func _init() -> void:
	pass

func _input(event: InputEvent) -> void:
	handle_rotation()
	handle_movement()
	current_angle = posmod(int(target_rotation_y), 360)

		
func handle_rotation() -> void:
	if Input.is_action_just_pressed("Look Left"):
		if able_to_turn:
			target_rotation_y += 90
			animate_rotation()
		else:
			pass
	elif Input.is_action_just_pressed("Look Right"):
		if able_to_turn:
			target_rotation_y -= 90
			animate_rotation()
		else:
			pass

func handle_movement() -> void:
	var angle = posmod(int(target_rotation_y), 360)
	
	if angle == 90 or angle == 270:
		able_to_move = false
		return
	elif angle == 0 or angle == 360:
		able_to_move = true
		
	if not able_to_move:
		return
		
	if Input.is_action_just_pressed("Move Forward"):
		if angle == 0:
			velocity.z -= 5.0 
		elif angle == 180:
			velocity.z += 5.0 
			
	elif Input.is_action_just_pressed("Move Backward"):
		if angle == 0:
			velocity.z += 5.0  
		elif angle == 180:
			velocity.z -= 5.0  

func handle_camera():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var center_x = DisplayServer.window_get_size().x / 2
	var offset_x = (mouse_pos.x - center_x) * 0.005
	
	var center_y = DisplayServer.window_get_size().y / 2
	var offset_y = -(mouse_pos.y - center_y) * 0.005 #negative because i forgot godot's coordinate system is weird af
	
	if not able_to_move:
		camera.position.z = clamp(lerp(camera.position.x, offset_x, 0.05), -2, 2)
		camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -offset_x * 1.5, 0.05)
		camera.rotation_degrees.x = lerp(camera.rotation_degrees.x, offset_y, 0.05)

		
	elif able_to_move:
		camera.position.z = lerpf(camera.position.x, 0, 0.05)
		camera.rotation_degrees.z = lerpf(camera.rotation_degrees.z, 0, 0.05)
		camera.rotation_degrees.x = lerpf(camera.rotation_degrees.x, 0, 0.05)

	
		

		
	
func _process(delta: float) -> void:
	if velocity.z != 0:
		velocity.z = lerp(velocity.z, 0.0, 0.05)
	elif abs(velocity.z) >= max_velocity_z:
		velocity.z = max_velocity_z
	
	handle_camera()
	move_and_slide()
	

func _on_right_pressed() -> void:
	if able_to_turn:
		target_rotation_y -= 90
		animate_rotation()
	else:
		pass

func animate_rotation() -> void:
	able_to_turn = false
	var tween = get_tree().create_tween()

	tween.tween_property(camera, "rotation_degrees:y", target_rotation_y, 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	able_to_turn = true
