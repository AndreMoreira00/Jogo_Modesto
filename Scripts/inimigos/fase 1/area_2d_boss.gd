extends Area2D
var player: Node2D

var exit = true
var is_attacking = false
@onready var attack_timer: Timer = Timer.new()
@onready var entred_timer: Timer = Timer.new()

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 1.0
	attack_timer.one_shot = true  

	add_child(entred_timer)
	entred_timer.wait_time = 0.5 
	entred_timer.one_shot = true  

func _process(delta: float) -> void:
	if player:
		if player.global_position.x-150 <= global_position.x:
			$AnimatedSprite2D.scale.x = 4.5
		elif player.global_position.x-150 >= global_position.x:
			$AnimatedSprite2D.scale.x = -4.5
			
	if is_attacking and $AnimatedSprite2D.animation != "morrer":
		is_attacking = false
		$AnimatedSprite2D.play("atacar")
		attack_timer.start()
		await attack_timer.timeout
		if player:
			is_attacking = true
	
	if $AnimatedSprite2D.animation != "morrer" and exit and $AnimatedSprite2D.animation == "atacar" and $AnimatedSprite2D.frame == 10:
			$AnimatedSprite2D.play("andar")
			$HitBox/HitBox.disabled = true
	if $AnimatedSprite2D.animation == "dano" and $AnimatedSprite2D.frame == 3:
			$AnimatedSprite2D.play("andar")
			$HitBox/HitBox.disabled = true

func _on_body_entered(body: Node2D) -> void:
	exit = false
	entred_timer.start()
	await entred_timer.timeout
	if body.name == "player"  and exit == false:
		player = body
		is_attacking = true

func _on_body_exited(body: Node2D) -> void:
	exit = true
	if body == player:
		player = null
		is_attacking = false

func _on_frame_changed():
	if $AnimatedSprite2D.animation == "atacar":
		if $AnimatedSprite2D.frame == 4 or $AnimatedSprite2D.frame == 8:
			$HitBox/HitBox.disabled = false
		elif $AnimatedSprite2D.frame == 5 or $AnimatedSprite2D.frame == 9:
			$HitBox/HitBox.disabled = true
		else:
			$HitBox/HitBox.disabled = true

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "atacar":
		is_attacking = false
