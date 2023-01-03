extends CharacterBody2D

@export var speed := 100
@onready var animation = $AnimatedSprite2D
@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var side: int
var life := randi() % 5 + 1
var hitted := false


func _ready() -> void:
	side = pick_random_side()
	velocity.x = speed * side
	animation.play("Run")


func _physics_process(delta: float) -> void:
	if not hitted:
		_move(delta)


func pick_random_side() -> int:
	if randi() % 2 == 0:
		return -1
		
	animation.scale.x = -1
	return 1


func _move(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.x == 0:
		_flip()
	
	move_and_slide()


func _flip() -> void:
	side *= -1
	animation.play("Idle")


func _hitted() -> void:
	hitted = true
	life -= 1
	animation.play("Hit")


func _on_animated_sprite_2d_animation_finished() -> void:
	match animation.animation:
		"Idle":
			velocity.x = side * speed
			animation.scale.x = -side
			animation.play("Run")
			
		"Hit":
			if life != 0:
				hitted = false
				animation.play("Run")
				return
				
			queue_free()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hitbox"):
		_hitted()
