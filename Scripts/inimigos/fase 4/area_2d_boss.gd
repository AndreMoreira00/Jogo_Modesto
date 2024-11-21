extends Area2D
var player: Node2D

var exit = true
var is_attacking = false
@onready var attack_timer: Timer = Timer.new()
@onready var entred_timer: Timer = Timer.new()

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 2.0  
	attack_timer.one_shot = true  
	
	add_child(entred_timer)
	entred_timer.wait_time = 0.5 
	entred_timer.one_shot = true  

func _process(delta: float) -> void:
	if player:
		if player.global_position.x-150 <= global_position.x:
			$AnimatedSprite2D.scale.x = -3  
			
	if is_attacking:
		is_attacking = false
		$AnimatedSprite2D.play("atacar")
		attack_timer.start()
		await attack_timer.timeout
		if player:
			is_attacking = true
	
	if $AnimatedSprite2D.animation != "morrer" and exit and $AnimatedSprite2D.animation == "atacar" and $AnimatedSprite2D.frame == 15:
			$AnimatedSprite2D.play("andar")

func _on_body_entered(body: Node2D) -> void:
	exit = false
	entred_timer.start()
	await entred_timer.timeout
	if body.name == "player" and exit == false:
		player = body
		is_attacking = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		exit = true
		player = null
		is_attacking = false

func _on_frame_changed():
	if $AnimatedSprite2D.animation == "atacar":
		if $AnimatedSprite2D.frame == 4 or $AnimatedSprite2D.frame == 12:
			$HitBox/HitBox.disabled = false
		elif $AnimatedSprite2D.frame == 6 or $AnimatedSprite2D.frame == 15:
			$HitBox/HitBox.disabled = true
		else:
			$HitBox/HitBox.disabled = true
