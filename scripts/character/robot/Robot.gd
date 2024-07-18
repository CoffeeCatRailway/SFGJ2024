class_name Robot
extends CharacterBody2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var healthComponent: HealthComponent = $HealthComponent

@onready var moveStateMachine: StateMachine = $MoveStateMachine
@onready var gunStateMachine: StateMachine = $GunStateMachine

@onready var raycast: RayCast2D = $RayCast2D
var rayTarget: Node2D

@export var hitSound: AudioStream

func _ready() -> void:
	moveStateMachine.init(self, $Sprite2D, $AnimationPlayer, $MoveComponent)
	gunStateMachine.init(self, $GunSprite, null, $MoveComponent)
	
	healthComponent.hit.connect(onHit)

func _process(delta: float) -> void:
	if healthComponent.isDead:
		return
	
	moveStateMachine.update(delta)
	gunStateMachine.update(delta)
	
	raycast.look_at(%Player.global_position)
	if raycast.is_colliding() && raycast.get_collider() && raycast.get_collider().get_parent() is Player:
		rayTarget = raycast.get_collider().get_parent()
	if (rayTarget is Player && rayTarget.healthComponent.isDead) || (rayTarget && rayTarget.global_position.distance_to(global_position) > 200.):
		rayTarget = null

func _physics_process(delta: float) -> void:
	if healthComponent.isDead:
		return
	
	moveStateMachine.updatePhysics(delta)
	gunStateMachine.updatePhysics(delta)

func onHit(isDead: bool) -> void:
	Utils.tweenBounce(self)
	
	audio.stream = hitSound
	audio.pitch_scale = .5 if isDead else 1.
	audio.play()
	
	if isDead:
		#await $AudioStreamPlayer2D.finished
		$HitZone.process_mode = Node.PROCESS_MODE_DISABLED
		$Sprite2D/ShardEmitter.shatter()
		await $Sprite2D/ShardEmitter.deleteTimer.timeout
		queue_free()
