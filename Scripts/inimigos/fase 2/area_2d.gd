extends Area2D
var player: Node2D

var is_attacking = false
var exit = true
@onready var attack_timer: Timer = Timer.new()
@onready var entred_timer: Timer = Timer.new()

var special_attack_chance = 20

func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))
	$AnimatedSprite2D2.connect("frame_changed", Callable(self, "_on_special_frame_changed"))
	$AnimatedSprite2D2.connect("animation_finished", Callable(self, "_on_special_animation_finished"))
	
	add_child(attack_timer)
	attack_timer.wait_time = 2.0
	attack_timer.one_shot = true  
	
	add_child(entred_timer)
	entred_timer.wait_time = 0.5
	entred_timer.one_shot = true  
	
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

	if $AnimatedSprite2D.animation != "morrer" and exit:
		if $AnimatedSprite2D.animation == "atacar" and $AnimatedSprite2D.frame == 10:
			$AnimatedSprite2D.play("andar")
			$HitBox_Especial/Collision_Shape_Especial.disabled = true
			$HitBox/HitBox.disabled = true
		elif $AnimatedSprite2D2.animation == "ataque_especial" and $AnimatedSprite2D.frame == 4:
			$AnimatedSprite2D.play("andar")
			$HitBox_Especial/Collision_Shape_Especial.disabled = true
			$HitBox/HitBox.disabled = true
			
func _on_body_entered(body: Node2D) -> void:
	exit = false
	entred_timer.start()
	await entred_timer.timeout
	if body.name == "player" and exit == false:
		player = body
		is_attacking = true

func _on_body_exited(body: Node2D) -> void:
	exit = true
	if body == player:
		player = null
		is_attacking = false

func _on_frame_changed():
	if $AnimatedSprite2D.animation == "atacar":
		if $AnimatedSprite2D.frame == 4:
			$HitBox/HitBox.disabled = false
		elif $AnimatedSprite2D.frame == 6:
			$HitBox/HitBox.disabled = true
			
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "atacar":
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
	else:
		$HitBox/HitBox.disabled = true
		$HitBox_Especial/Collision_Shape_Especial.disabled = true
