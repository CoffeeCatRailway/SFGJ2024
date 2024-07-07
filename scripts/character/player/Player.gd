class_name Player
extends CharacterBody2D

@onready var healthComponent: HealthComponent = $HealthComponent
@onready var staminaComponent: StaminaComponent = $StaminaComponent

@onready var moveStateMachine: StateMachine = $MoveStateMachine
@onready var gunStateMachine: StateMachine = $GunStateMachine

@export var hitSound: AudioStream

func _ready() -> void:
	moveStateMachine.init(self, $PlayerSprite, $AnimationPlayer, $MoveComponent)
	gunStateMachine.init(self, $GunSprite, null, $MoveComponent)
	
	healthComponent.hit.connect(onHit)

func _process(delta: float) -> void:
	moveStateMachine.update(delta)
	if !healthComponent.isDead:
		gunStateMachine.update(delta)

func _physics_process(delta: float) -> void:
	moveStateMachine.updatePhysics(delta)
	if !healthComponent.isDead:
		gunStateMachine.updatePhysics(delta)

#var tween: Tween
func onHit(isDead: bool) -> void:
	#if tween:
		#tween.kill()
	#tween = get_tree().create_tween().bind_node(self)
	#tween.tween_property(self, "scale", Vector2(.8, 1.4), .04)
	#tween.tween_property(self, "scale", Vector2.ONE, .04)
	Utils.tweenBounce(self)
	
	$AudioStreamPlayer2D.stream = hitSound
	$AudioStreamPlayer2D.pitch_scale = .75 if isDead else 1.
	$AudioStreamPlayer2D.play()
	
	if isDead:
		print("Dead")
		#queue_free()
