extends Node2D

func _ready():
	$AnimatedSprite2D.play("bomba")  # Nome da animação
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_explosion_finished"))

func _on_explosion_finished(_anim_name):
	queue_free() 
