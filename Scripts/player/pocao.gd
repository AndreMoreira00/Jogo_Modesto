extends Area2D

var is_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_collected:
		return

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		is_collected = true
		body.coletar_pocao()
		$AnimatedSprite2D.play("pegar")
		
func _on_animation_finished():
	is_collected = false
	$".".queue_free()
