extends Area2D

var flecha_speed := 300.0
var direction := -1

var dano = 0.5

func _process(delta: float) -> void:
	position.x += flecha_speed * direction * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
func set_direction(dir):
	direction = dir
	if dir < 0:
		$AnimatedSprite2D.set_flip_h(true)
	else:
		$AnimatedSprite2D.set_flip_h(false)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.dano_player(dano)
		$".".queue_free()
