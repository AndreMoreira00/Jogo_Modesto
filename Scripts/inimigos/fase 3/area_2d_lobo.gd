extends Area2D
var player: Node2D

var is_attacking = false
@onready var attack_timer: Timer = Timer.new()

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 2.0  
	attack_timer.one_shot = true  

func _process(delta: float) -> void:
	if player:
		if player.global_position.x-150 <= global_position.x:
			$AnimatedSprite2D.scale.x = -1.15  
		elif player.global_position.x-150 >= global_position.x:
			$AnimatedSprite2D.scale.x = 1.15
			
	if is_attacking:
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
		
		if $AnimatedSprite2D.animation != "morrer":
			$AnimatedSprite2D.play("andar")

func _on_frame_changed():
	if $AnimatedSprite2D.frame == 2 and $AnimatedSprite2D.animation == "atacar":
		$HitBox/HitBox.disabled = false
	elif $AnimatedSprite2D.frame == 4 and $AnimatedSprite2D.animation == "atacar":
		$HitBox/HitBox.disabled = true
	else:
		$HitBox/HitBox.disabled = true
