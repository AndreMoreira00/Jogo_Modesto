extends CharacterBody2D

var move_direction = -1
var distance_traveled = 0.0  

var vida = 10.0
var is_dead = false

var ExplosionScene = preload("res://Cenas/bomba/bomba.tscn")

func _ready():
	$Area2D/AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if $Area2D/AnimatedSprite2D.animation == "dano":
		$Area2D/AnimatedSprite2D.play("andar");

func dano(DANO):
	vida-=DANO
	if vida<= 0:
		is_dead = true
		$Area2D/AnimatedSprite2D.play("morrer")
		get_parent().add_child(ExplosionScene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED))
	else:
		$Area2D/AnimatedSprite2D.play("dano")
		

func _on_animation_finished():
	if $Area2D/AnimatedSprite2D.animation == "morrer":
		is_dead = false
		$CollisionShape2D.disabled = true
		$Area2D/HitBox/HitBox.disabled = true
