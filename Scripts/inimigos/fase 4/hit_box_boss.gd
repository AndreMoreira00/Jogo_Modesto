extends Area2D

var dano = 1

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.dano_player(dano)
