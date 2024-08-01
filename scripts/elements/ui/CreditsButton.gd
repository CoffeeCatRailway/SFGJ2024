extends Button

@onready var sprite: Sprite2D = $Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

@export var mainMenu: MainMenu

var focusTop: NodePath
var focusNext: NodePath
var focusPrevious: NodePath

func _ready() -> void:
	focusTop = focus_neighbor_top
	focusNext = focus_next
	focusPrevious = focus_previous
	
	animPlayer.play("idle")
	
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
	focus_entered.connect(onMouseEntered)
	focus_exited.connect(onMouseExited)
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
		focus_neighbor_top = NodePath("")
		focus_next = NodePath("")
		focus_previous = NodePath("")
	else:
		animPlayer.play("hover")
		focus_neighbor_top = focusTop
		focus_next = focusNext
		focus_previous = focusPrevious
