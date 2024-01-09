extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://scene/attack_enimy.tscn")
const OFFSET: Vector2 = Vector2(0, 31)

@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var anim_auxiliar: AnimationPlayer = get_node("auxiliarEnimy")
@onready var texture: Sprite2D = get_node("texture")

var morte: bool = false
var player_ref: CharacterBody2D = null

@export var health: int = 3
@export var move_speed: float = 192.0
@export var distance_enimy: float = 60.0

func _physics_process(_delta: float) -> void:
	if morte:
		return
		
	if player_ref == null or player_ref.morte:
		velocity = Vector2.ZERO
		animate()
		return
		
	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)
	
	if distance < distance_enimy:
		anim.play("attack")
		return
		
	velocity = direction * move_speed
	move_and_slide()
	animate()

func _on_detecion_body_entered(body):
	player_ref = body


func _on_detecion_body_exited(_body):
	player_ref = null
	
	
func  spaw_enimy() -> void:
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = OFFSET
	add_child(attack_area)
	
	
	
func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
	if velocity.x < 0:
		texture.flip_h = true
		
	if velocity != Vector2.ZERO:
		anim.play("run")
		return
	anim.play("idle")
	
func update_health(value: int)-> void:
	health -= value
	if health <= 0:
		morte = true
		anim.play("death")
		return
		
	anim_auxiliar.play("hit")
		

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		queue_free()
