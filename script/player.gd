extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("anim")
@onready var auxiliar: AnimationPlayer = get_node("auxiliarAnim")
@onready var area: CollisionShape2D = get_node("area/collsion_area")
@onready var texture: Sprite2D = get_node("texture")

@export var health: int = 10
@export var move_speed: float = 256.0
@export var damage: int = 1

var atacando: bool = true
var morte: bool = false

func _physics_process(_delta: float) -> void:
	if (atacando == false or 
		morte 
		):
		return
		
	move()
	anima()
	attack_play()
	
func move() -> void:
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()
		
func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_rigth"), 
		Input.get_axis("move_up", "move_down")
	).normalized()

func anima()  -> void:
	if velocity.x > 0:
		texture.flip_h = false
		area.position.x = 58
	
	if velocity.x < 0:
		texture.flip_h = true
		area.position.x = -58
	
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	animation.play("idle")	

func attack_play() -> void:
	if Input.is_action_just_pressed("attack") and atacando:
		atacando = false
		animation.play("attack")
		

func _on_anim_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack":
			atacando = true
		"death":
			get_tree().reload_current_scene()
	
func _on_area_body_entered(body) -> void:
	body.update_health(damage)
	
func update_health(value: int)-> void:
	health -= value
	if health <= 0:
		morte = true
		animation.play("death")
		area.set_deferred("disabled", true)
		return
		
	auxiliar.play("hit")
		
		
	
	
	
	
	
	
