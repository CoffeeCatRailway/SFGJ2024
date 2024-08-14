extends CanvasLayer

signal onTransitionFinish

@onready var node: Node2D = $Node2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	node.visible = false
	animPlayer.animation_finished.connect(onAnimationFinish)

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("ui_end"):
		#transition()

func onAnimationFinish(animName: String) -> void:
	#onTransitionFinish.emit()
	match animName:
		"close":
			onTransitionFinish.emit()
			animPlayer.play("open")
		"open":
			node.visible = false

func transition() -> void:
	node.visible = true
	animPlayer.play("close")
