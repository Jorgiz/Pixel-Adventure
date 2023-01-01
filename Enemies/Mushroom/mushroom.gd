extends CharacterBody2D

@export var speed := 70.0

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")
var side: int


func _ready() -> void:
	randomize()
	# Choose a random side
	match randi() % 2:
		0: # Left
			side = -1
		1:  # Right
			side = 1
			$AnimatedSprite2D.flip_h = true
	
	$AnimatedSprite2D.play("Run")


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = side * speed
	
	move_and_slide()
	
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
		set_physics_process(false)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Idle":
		set_physics_process(true)
		side = -side
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		$AnimatedSprite2D.play("Run")
