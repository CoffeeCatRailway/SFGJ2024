class_name Robot
extends CharacterBody2D

@onready var healthComponent: HealthComponent = $HealthComponent

@onready var moveStateMachine: StateMachine = $MoveStateMachine
@onready var gunStateMachine: StateMachine = $GunStateMachine

@onready var raycast: RayCast2D = $RayCast2D
var rayTarget: Node2D

@onready var healthBar: TextureProgressBar = $HealthBar

func _ready() -> void:
	moveStateMachine.init(self, $Sprite2D, $AnimationPlayer, $MoveComponent)
	gunStateMachine.init(self, $GunSprite, null, $MoveComponent)
	
	healthComponent.hit.connect(onHit)
	healthBar.max_value = healthComponent.maxHealth

func _process(delta: float) -> void:
	moveStateMachine.update(delta)
	gunStateMachine.update(delta)
	
	raycast.look_at(%Player.global_position)
	if raycast.is_colliding() && raycast.get_collider() && raycast.get_collider().get_parent() is Player:
		rayTarget = raycast.get_collider().get_parent()
	if rayTarget is Player && rayTarget.healthComponent.isDead:
		rayTarget = null
	
	healthBar.value = healthComponent.health

func _physics_process(delta: float) -> void:
	moveStateMachine.updatePhysics(delta)
	gunStateMachine.updatePhysics(delta)

func onHit(isDead: bool) -> void:
	Utils.tweenBounce(self)
	
	if isDead:
		queue_free()
