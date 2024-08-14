extends Node2D

var camPos: Vector2 = Vector2.ZERO

#var mouseAngle: float = 0.

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#mouseAngle = event.velocity.angle() #lerp(mouseAngle, event.relative.angle(), .5)

func _process(_delta: float) -> void:
	$PointLight2D.global_position.x = floorf(get_global_mouse_position().x)
	$PointLight2D.global_position.y = floorf(get_global_mouse_position().y)
	
	$Camera2D.global_position = camPos * 192. + (Vector2.ONE * 96.)
	
	#$PointLight2D.rotation = mouseAngle - PI / 2.
	#$PointLight2D.rotation = lerpf($PointLight2D.rotation, mouseAngle - PI / 2., .25)
	
	if Input.is_action_just_pressed("move_right"):
		camPos.x += 1.
	elif Input.is_action_just_pressed("move_left"):
		camPos.x -= 1.
