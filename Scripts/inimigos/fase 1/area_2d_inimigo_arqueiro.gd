extends Area2D

# Variável para armazenar a referência ao player
var player: Node2D
const flecha_scene = preload("res://Cenas/inimigos/fase1/flecha.tscn")

@onready var posicao_flecha = $posicao_flecha
@onready var flecha_cooldown = $flecha_cooldown

# Função chamada a cada frame
func _process(delta: float) -> void:
	# Verifica se o player está na área de colisão
	if player:
		# Compara a posição para virar o personagem corretamente
		if player.global_position.x-270 <= global_position.x:
			$AnimatedSprite2D.scale.x = 1  # Vira para a esquerda
			if sign(posicao_flecha.position.x) == 1:
				posicao_flecha.position.x *= -1
		elif player.global_position.x-270 >= global_position.x:
			$AnimatedSprite2D.scale.x = -1  # Vira para a direita
			if sign(posicao_flecha.position.x) == -1:
				posicao_flecha.position.x *= -1
		
		if flecha_cooldown.is_stopped() and $AnimatedSprite2D.animation == "atacar" and $AnimatedSprite2D.frame == 12:
			shoot_flecha()
# Função chamada ao detectar uma entrada de colisão
func _on_body_entered(body: Node2D) -> void:
	# Verifica se o corpo colidido é o "player"
	if body.name == "player":
		# Armazena a referência ao player
		player = body
		# Reproduz a animação de ataque
		$AnimatedSprite2D.play("atacar")

# Função chamada ao sair de uma colisão
func _on_body_exited(body: Node2D) -> void:
	# Verifica se o corpo que saiu da colisão é o "player"
	if body == player:
		# Limpa a referência ao player
		player = null
		# Reproduz a animação de andar
		$AnimatedSprite2D.play("andar")
	
func shoot_flecha():
	var flecha_instance = flecha_scene.instantiate()
	if sign(posicao_flecha.position.x) == 1:
		flecha_instance.set_direction(1)
	else:
		flecha_instance.set_direction(-1)
	add_child(flecha_instance)
	posicao_flecha.global_position = posicao_flecha.global_position
	flecha_cooldown.start()
