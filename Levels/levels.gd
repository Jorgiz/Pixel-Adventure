extends Node2D

var current_level : int


func _ready() -> void:
	var level_number = ""
	
	for i in str(self.name):
		level_number += str(i as int)
	current_level = int(level_number)


func _on_next_level_change_scene() -> void:
	var next_scene = "res://Levels/level_" + str(current_level+1) + ".tscn"
	get_tree().change_scene_to_file(next_scene)
