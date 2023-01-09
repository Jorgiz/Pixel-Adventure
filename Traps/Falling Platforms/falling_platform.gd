extends CharacterBody2D

var character: CharacterBody2D
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var triggered: bool = false
var process_locked: bool = false
var acceleration := Vector2.ZERO

@onready var initial_position = self.position


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	for i in range(character.get_slide_collision_count()):
		var collider = character.get_slide_collision(i).get_collider()
		if collider == self:
			process_locked = true
			$AnimationPlayer.play("Warning")
	
	if triggered:
		acceleration.y += gravity * (delta**2)
		position += acceleration


func reset():
	acceleration = Vector2.ZERO
	$AnimationPlayer.play("On")
	set_physics_process(false)
	triggered = false
	$CollisionShape2D.disabled = false
	self.position = initial_position
	process_locked = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	character = body as CharacterBody2D
	if character.is_in_group("player"):
		set_physics_process(true)


func _on_player_detector_body_exited(body: Node2D) -> void:
	if not process_locked:
		set_physics_process(false)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Warning":
		$CollisionShape2D.disabled = true
		$Timer.start()
		triggered = true


func _on_timer_timeout() -> void:
	reset()
