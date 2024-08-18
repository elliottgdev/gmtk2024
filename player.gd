extends CharacterBody3D

@export var speed = 20
@export var gravity = 75
@export var jump  = 30
@export var debug = false
var is_in_scale_zone = false
var target_velocity = Vector3.ZERO
var double_jump = false

func _physics_process(delta: float) -> void:
	#set direction to zero at beginning of frame so we can add or subtract one depending on keys held
	#to get 8 way movement
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			target_velocity.y = jump * basis.get_scale().y
		elif double_jump == true:
			target_velocity.y = jump * basis.get_scale().y
			double_jump = false
	#debug input. only works if debug mode is enabled on player in inspector
	if debug == true or is_in_scale_zone == true:
		if Input.is_action_pressed("debug_scale_up"):
			scale += Vector3(delta, delta, delta)
		if Input.is_action_pressed("debug_scale_down"):
			scale -= Vector3(delta, delta, delta)
	
	#normalize so player doesnt move quicker diagonally
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	#set players velocity, multiplied by scale
	target_velocity.x = direction.x * speed * basis.get_scale().y
	target_velocity.z = direction.z * speed * basis.get_scale().y
	
	if not is_on_floor():
		#gravity
		target_velocity.y -= gravity * basis.get_scale().y * delta
	else: double_jump = true #set double jump to true if player is on the ground
	
	#move
	velocity = target_velocity
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("oof")
