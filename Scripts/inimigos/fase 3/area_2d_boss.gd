extends Area2D
var player: Node2D

var lado = 'l'
var is_attacking = false
@onready var attack_timer: Timer = Timer.new()

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 3
	attack_timer.one_shot = true  

func _process(delta: float) -> void:
	if player:
		if player.global_position.x-150 <= global_position.x:
			$AnimatedSprite2D.scale.x = -2
			$HitBox/HitBox.position.x = - 130
			lado = 'l'
		elif player.global_position.x-150 >= global_position.x:
			$AnimatedSprite2D.scale.x = 2
			$HitBox/HitBox.position.x = + 120
			lado = 'r'
			
	if is_attacking and $AnimatedSprite2D.animation != "morrer":
		is_attacking = false
		$AnimatedSprite2D.play("atacar")
		attack_timer.start()
		await attack_timer.timeout
		if player:
			is_attacking = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		is_attacking = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_attacking = false
		$HitBox/HitBox.disabled = true
		if $AnimatedSprite2D.animation != "morrer":
			$AnimatedSprite2D.play("andar")
			if lado == 'l':
				$AnimatedSprite2D.scale.x *= 1
			else:
				$AnimatedSprite2D.scale.x *= -1
		

func _on_frame_changed():
	if $AnimatedSprite2D.animation == "atacar":
		if $AnimatedSprite2D.frame == 5 or $AnimatedSprite2D.frame == 13:
			$HitBox/HitBox.disabled = false
		elif $AnimatedSprite2D.frame == 6 or $AnimatedSprite2D.frame == 14:
			$HitBox/HitBox.disabled = true
		else:
			$HitBox/HitBox.disabled = true

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "atacar":
		is_attacking = false
