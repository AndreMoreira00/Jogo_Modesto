extends CharacterBody2D

var SPEED = 300.0
var LEFT_DISTANCE = 3 * SPEED 
var RIGHT_DISTANCE = 3 * SPEED  

var move_direction = -1
var distance_traveled = 0.0  

var vida = 5.0
var is_dead = false

func _ready():
	$Area2D/AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if $Area2D/AnimatedSprite2D.animation == "andar" and is_dead == false:
		patrol(delta)
		move_and_slide()

func patrol(delta: float) -> void:
	velocity.x = move_direction * SPEED
	distance_traveled += SPEED * delta 
	
	if (move_direction == -1 and distance_traveled >= LEFT_DISTANCE) or (move_direction == 1 and distance_traveled >= RIGHT_DISTANCE):
		move_direction *= -1  
		distance_traveled = 0  
		$Area2D/AnimatedSprite2D.scale.x = move_direction * 2

func dano(DANO):
	vida-=DANO
	if vida<= 0.0:
		is_dead = true
		$Area2D/AnimatedSprite2D.play("morrer")
		SPEED = 0
	else:
		$Area2D/AnimatedSprite2D.play("dano")

func _on_animation_finished():
	if $Area2D/AnimatedSprite2D.animation == "morrer":
		is_dead = false
		$'.'.queue_free()
