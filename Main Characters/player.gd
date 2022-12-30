extends CharacterBody2D

@export var air_jumps := 1

const SPEED = 100.0
const JUMP_VELOCITY = -220.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jumps_left = air_jumps


func _ready() -> void:
	set_physics_process(false)
	$AnimatedSprite2D.play("Appearing")


func _physics_process(delta: float) -> void:
	_move(delta)
	_animate()


func _move(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	# Handle Jump.
	var jump = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and jump:
		air_jumps_left = air_jumps
		velocity.y = JUMP_VELOCITY
	elif jump and air_jumps_left != 0:
		air_jumps_left -= 1
		velocity.y = JUMP_VELOCITY
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		$AnimatedSprite2D.scale.x = direction # Flips sprite
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*0.1)
	
	move_and_slide()


func _animate() -> void:
	# States:
	var is_idle = is_on_floor() and velocity.x == 0
	var is_running = is_on_floor() and velocity.x != 0
	var is_jumping = velocity.y < 0 and air_jumps_left == air_jumps
	var is_double_jumping = velocity.y < 0 and air_jumps_left != air_jumps
	var is_falling = velocity.y > 0
	
	if is_idle:
		$AnimatedSprite2D.play("Idle")
	elif is_running:
		$AnimatedSprite2D.play("Run")
	elif is_jumping:
		$AnimatedSprite2D.play("Jump")
	elif is_double_jumping:
		$AnimatedSprite2D.play("Double Jump")
	elif is_falling:
		$AnimatedSprite2D.play("Fall")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Appearing":
		$AnimatedSprite2D.play("Idle")
		set_physics_process(true)
