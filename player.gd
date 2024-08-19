extends CharacterBody3D

@export var speed = 6
@export var gravity = 30
@export var jump  = 10
@export var debug = false
var is_in_scale_zone = false
var target_velocity = Vector3.ZERO
var double_jump = false

func _physics_process(_delta: float) -> void:
	#set direction to zero at beginning of frame so we can add or subtract one depending on keys held
	#to get 8 way movement
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		if !$Node3D/Footstepsound.playing and is_on_floor():
			$Node3D/Footstepsound.pitch_scale = (1.25 / scale.y)
			$Node3D/Footstepsound.play()
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
		if !$Node3D/Footstepsound.playing and is_on_floor():
			$Node3D/Footstepsound.pitch_scale = (1.25 / scale.y)
			$Node3D/Footstepsound.play()
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		if !$Node3D/Footstepsound.playing and is_on_floor():
			$Node3D/Footstepsound.pitch_scale = (1.25 / scale.y)
			$Node3D/Footstepsound.play()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		if !$Node3D/Footstepsound.playing and is_on_floor():
			$Node3D/Footstepsound.pitch_scale = (1.25 /scale.y)
			$Node3D/Footstepsound.play()
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			target_velocity.y = jump * basis.get_scale().y
			$Node3D/Jumpsound.pitch_scale = 0.75
			$Node3D/Jumpsound.play()
		elif double_jump == true:
			target_velocity.y = jump * basis.get_scale().y
			double_jump = false
			$Node3D/Jumpsound.pitch_scale = 1.25
			$Node3D/Jumpsound.play()
	#debug input. only works if debug mode is enabled on player in inspector
	if debug == true or is_in_scale_zone == true:
		if Input.is_action_pressed("debug_scale_up"):
			if scale <= Vector3(2,2,2):
				scale += Vector3(_delta, _delta, _delta)	
		if Input.is_action_pressed("debug_scale_down"):
			if scale >= Vector3(0,0,0):
				scale -= Vector3(_delta, _delta, _delta)
	
	#normalize so player doesnt move quicker diagonally
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	#set players velocity, multiplied by scale
	target_velocity.x = direction.x * speed * basis.get_scale().y
	target_velocity.z = direction.z * speed * basis.get_scale().y
	
	if not is_on_floor():
		#gravity
		if basis.get_scale().y < 0.7:
			target_velocity.y -= (gravity - 7) * basis.get_scale().y * _delta
		else:
			target_velocity.y -= gravity * basis.get_scale().y * _delta
	else: double_jump = true #set double jump to true if player is on the ground
	
	if is_on_ceiling():
		target_velocity.y = -0.1
	
	#move
	velocity = target_velocity
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("oof")
	gravity = -11
	speed = 0
	jump = 0
	$Node3D/Lavadeath.play()
	#$Node3D/Sizzle.pitch_scale = 0.6
	$Node3D/HitHurt.play()
	$Node3D/Sizzle.play()
	$Node3D/Scream.volume_db = 0.5
	$Node3D/Scream.pitch_scale = 0.9
	$Node3D/Scream.play()
	await get_tree().create_timer(1).timeout
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true
