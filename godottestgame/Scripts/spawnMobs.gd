extends Node3D

@export var mob_scene: PackedScene

func _ready():
	$userInterface/retry.hide()

func _on_mob_timer_timeout():

	
	
	var mob = mob_scene.instantiate()
	mob.squashed.connect($userInterface/scoreLabel._on_mob_squashed.bind())

	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")

	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	

	add_child(mob)


func _on_player_hit() -> void:
	$userInterface/retry.show()
	$mobTimer.stop()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $userInterface/retry.visible:
		get_tree().reload_current_scene()
