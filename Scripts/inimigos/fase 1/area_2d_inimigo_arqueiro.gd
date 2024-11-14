extends Area2D

# Variável para armazenar a referência ao player
var player: Node2D

# Função chamada a cada frame
func _process(delta: float) -> void:
	# Verifica se o player está na área de colisão
	if player:
		# Compara a posição para virar o personagem corretamente
		if player.global_position.x-150 <= global_position.x:
			$AnimatedSprite2D.scale.x = 1  # Vira para a esquerda
		elif player.global_position.x-150 >= global_position.x:
			$AnimatedSprite2D.scale.x = -1  # Vira para a direita

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
