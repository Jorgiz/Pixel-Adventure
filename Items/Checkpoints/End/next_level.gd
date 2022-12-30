extends Area2D

signal change_scene

func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("Pressed")


func _on_body_entered(_body: Node2D) -> void:
	$PressJump.visible = true
	set_process(true)


func _on_body_exited(_body: Node2D) -> void:
	$PressJump.visible = false
	set_process(false)


func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("change_scene")
