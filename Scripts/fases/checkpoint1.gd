extends Area2D

@onready var checkpoint_position = position

func _on_body_entered(body):
	if body.name == "player":  # Certifique-se de que seja o player
		GameState.current_level = get_tree().get_current_scene().name
		GameState.checkpoint_position = checkpoint_position
		print("Checkpoint salvo:", GameState.current_level, GameState.checkpoint_position)
