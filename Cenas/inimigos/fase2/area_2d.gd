extends Area2D

var player: Node2D
var is_attacking = false

@onready var attack_timer: Timer = Timer.new()

var special_attack_chance = 20

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	$AnimatedSprite2D2.connect("frame_changed", Callable(self, "_on_special_frame_changed"))
	$AnimatedSprite2D2.connect("animation_finished", Callable(self, "_on_special_animation_finished"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 2
	attack_timer.one_shot = true  
	
	$AnimatedSprite2D2.visible = false

func _process(delta: float) -> void:
	if player:
		if player.global_position.x - 150 <= global_position.x:
			$AnimatedSprite2D.scale.x = 1.75
		elif player.global_position.x - 150 >= global_position.x:
			$AnimatedSprite2D.scale.x = -1.75
			
	if is_attacking and $AnimatedSprite2D.animation != "morrer":
		is_attacking = false
		
		if randi() % 100 < special_attack_chance:
			$AnimatedSprite2D.play("special") 
			$AnimatedSprite2D2.visible = true
			$AnimatedSprite2D2.play("ataque_especial")  
		else:
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
	if $AnimatedSprite2D.animation in ["atacar", "special"]:
		if $AnimatedSprite2D.frame == 4:
			$HitBox/HitBox.disabled = false
		elif $AnimatedSprite2D.frame == 6:
			$HitBox/HitBox.disabled = true
		else:
			$HitBox/HitBox.disabled = true

func _on_animation_finished():
	if $AnimatedSprite2D.animation in ["atacar", "special"]:
		is_attacking = false
		
		if $AnimatedSprite2D.animation == "special":
			$AnimatedSprite2D2.visible = false
			$AnimatedSprite2D2.stop()

func _on_special_frame_changed():
	if $AnimatedSprite2D2.animation == "ataque_especial":
		if $AnimatedSprite2D2.frame == 4: 
			$HitBox_Especial/Collision_Shape_Especial.disabled = false
		else:
			$HitBox_Especial/Collision_Shape_Especial.disabled = true

func _on_special_animation_finished():
	if $AnimatedSprite2D2.animation == "ataque_especial":
		is_attacking = false
		$AnimatedSprite2D2.visible = false
		$AnimatedSprite2D2.stop()
