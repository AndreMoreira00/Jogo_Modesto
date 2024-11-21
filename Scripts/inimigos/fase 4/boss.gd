extends CharacterBody2D

var move_direction = -1
var distance_traveled = 0.0  

var vida = 3
var is_dead = false

func _ready():
	$Area2D/AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func dano(DANO):
	vida-=DANO
	if vida<= 0:
		is_dead = true
		$Area2D/AnimatedSprite2D.play("morrer")
	else:
		$Area2D/AnimatedSprite2D.play("dano")

func _on_animation_finished():
	if $Area2D/AnimatedSprite2D.animation == "morrer":
		is_dead = false
		$CollisionShape2D.disabled = true
		$Area2D/HitBox/HitBox.disabled = true
