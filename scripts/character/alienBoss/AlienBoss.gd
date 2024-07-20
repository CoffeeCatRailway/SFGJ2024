class_name AlienBoss
extends CharacterBody2D

@onready var healthComponent: HealthComponent = $HealthComponent

@onready var moveStateMachine: StateMachine = $MoveStateMachine
#@onready var gunStateMachine: StateMachine = $GunStateMachine

@onready var eyeSprite: Sprite2D = $Sprite2D/EyeSprite
@onready var targeterComponent: TargeterComponent = $TargeterComponent

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var hitSound: AudioStream

@export var scrpt: GDScript

func _ready() -> void:
	moveStateMachine.init(self, $Sprite2D, $AnimationPlayer, null)
	#gunStateMachine.init(self, $GunSprite, null, null)
	
	healthComponent.hit.connect(onHit)

func _process(delta: float) -> void:
	if healthComponent.isDead:
		return
	
	moveStateMachine.update(delta)
	#gunStateMachine.update(delta)
	
	$Sprite2D.flip_h = global_position.x < %Player.global_position.x
	
	targeterComponent.look_at(%Player.global_position)
	
	if targeterComponent.target:
		eyeSprite.position.x = 2.5 if $Sprite2D.flip_h else -2.5
		
		var angle: float = eyeSprite.global_position.direction_to(targeterComponent.target.global_position).angle()
		eyeSprite.offset.x = clampf(cos(angle), -.5, .5)
		eyeSprite.offset.y = clampf(sin(angle), -.5, .5)

func _physics_process(delta: float) -> void:
	if healthComponent.isDead:
		return
	
	moveStateMachine.updatePhysics(delta)
	#gunStateMachine.updatePhysics(delta)

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
		EndGameMenu.winMenu()
		#queue_free()
