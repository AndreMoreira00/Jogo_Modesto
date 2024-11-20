extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -400.0

var vida = 3
var max_stamina = 100
var current_stamina = max_stamina
var stamina_recovery_rate = 10.0 

var is_attacking = false
var is_dead = false
var is_jump = false
var is_dodge = false

var DANO

func _ready():
	# Conectando o sinal de fim de animação ao método
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_ataque_finished"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_dead_finished"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_dodge_finished"))
	$Camera2D/ProgressBar.max_value = max_stamina
	$Camera2D/ProgressBar.value = current_stamina

func _process(delta: float) -> void:
	match vida:
		0:
			$"Camera2D/vidas/1".visible = false
			$"Camera2D/vidas/2".visible = false
			$"Camera2D/vidas/3".visible = false
		1:
			$"Camera2D/vidas/1".visible = true
			$"Camera2D/vidas/2".visible = false
			$"Camera2D/vidas/3".visible = false
		2:
			$"Camera2D/vidas/1".visible = true
			$"Camera2D/vidas/2".visible = true
			$"Camera2D/vidas/3".visible = false
		3:
			$"Camera2D/vidas/1".visible = true
			$"Camera2D/vidas/2".visible = true
			$"Camera2D/vidas/3".visible = true
			
	if vida<= 0:
		is_dead = true
		SPEED = 0
		$AnimatedSprite2D.play("morrer")
	
	if current_stamina < max_stamina:
		current_stamina += 20 * delta
		if current_stamina > max_stamina:
			current_stamina = max_stamina
	
	update_stamina_bar()

func _physics_process(delta: float) -> void:
	# Adiciona gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Pega o estado atual do boneco
	_get_input()
	
	# Lógica de pulo
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
	elif is_on_floor():
		is_jump = false
		
	
	if current_stamina > 0:
		# Lógica de ataque
		if Input.is_action_just_pressed("ataque_fraco") and not is_attacking and current_stamina >= 40:
			DANO = 1
			is_attacking = true
			$Area2D/HitBox.set_deferred("disabled", false)
			$AnimatedSprite2D.play("atacando_fraco")
			$Camera2D/Parallax2D/normal.visible = false
			$Camera2D/Parallax2D/ataque.visible = true
			current_stamina -= 40 
		
		if Input.is_action_just_pressed("ataque_forte") and not is_attacking and current_stamina >= 60:
			DANO = 3
			is_attacking = true
			$Area2D/HitBox.set_deferred("disabled", false)
			$AnimatedSprite2D.play("atacando_forte")
			$Camera2D/Parallax2D/normal.visible = false
			$Camera2D/Parallax2D/ataque.visible = true
			current_stamina -= 60 
		
		if Input.is_action_just_pressed("esquiva") and not is_dodge and current_stamina >= 70:
			is_dodge = true
			$AnimatedSprite2D.play("esquiva")
			$".".collision_layer = 8
			current_stamina -= 70 
	
	
# Troca a animação do player
func _get_input():
	# Se está atacando, evita trocar de animação
	if is_attacking:
		return
	if is_dead:
		return
	if is_dodge:
		return

	var direction = int(Input.is_action_pressed("direita")) - int(Input.is_action_pressed("esquerda"))
	move_and_slide()
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("repouso")
	
	if direction != 0:
		$AnimatedSprite2D.scale.x = direction
		if !is_jump:
			$AnimatedSprite2D.play("andando")
		else:
			$AnimatedSprite2D.play("pular")
			
	if $AnimatedSprite2D.scale.x < 0:
		$Area2D/HitBox.position.x = -34
	else:
		$Area2D/HitBox.position.x = 25
		
# Função para resetar o estado de ataque quando a animação termina
func _on_animation_ataque_finished():
	if $AnimatedSprite2D.animation == "atacando_fraco" or $AnimatedSprite2D.animation == "atacando_forte":
		is_attacking = false
		$Area2D/HitBox.disabled = true
		$Camera2D/Parallax2D/ataque.visible = false
		$Camera2D/Parallax2D/normal.visible = true
		
func _on_animation_dead_finished():
	if $AnimatedSprite2D.animation == "morrer":
		$'.'.queue_free()

func _on_animation_dodge_finished():
	if $AnimatedSprite2D.animation == "esquiva":
		is_dodge = false
		$".".collision_layer = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "inimigo" or body.name == "inimigo_arqueiro" or body.name == "boss":
		body.dano(DANO)

func dano_player(dano):
	vida-=dano
	
func update_stamina_bar():
	# Envia o valor atualizado para a UI
	$Camera2D/ProgressBar.value = current_stamina

func coletar_pocao():
	vida += 1
