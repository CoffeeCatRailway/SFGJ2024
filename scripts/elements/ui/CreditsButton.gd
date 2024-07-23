extends TextureButton

@onready var sprite: Sprite2D = $Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

@export var mainMenu: MainMenu

func _ready() -> void:
	animPlayer.play("idle")
	
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
	pressed.connect(onPressed)

func onMouseEntered() -> void:
	if !mainMenu.creditsToggle:
		animPlayer.play("hover")

func onMouseExited() -> void:
	if !mainMenu.creditsToggle:
		animPlayer.play("idle")

func onPressed() -> void:
	animPlayer.stop()
	if !mainMenu.creditsToggle:
		sprite.frame_coords = Vector2i(3, 13)
	else:
		animPlayer.play("hover")
