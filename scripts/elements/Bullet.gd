class_name Bullet
extends Area2D

var COLOR_GREEN: Color = Color.hex(0xb4db61)
var COLOR_PURPLE: Color = Color.hex(0xc361db)

@export var speed: float = 200.
@export var damage: int = 10

var direction: Vector2 = Vector2.ZERO
var isPurple: bool = false:
	set(value):
		isPurple = value
		$Sprite2D.frame_coords.x = 14 if isPurple else 15
		$PointLight2D.color = COLOR_PURPLE if isPurple else COLOR_GREEN

func _ready() -> void:
	isPurple = false
	get_tree().create_timer(2.).timeout.connect(hit)

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	hit()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HitZone" && area.has_node("../HealthComponent"):
		hit(area.get_node("../HealthComponent"))

func setDirection(dir: Vector2) -> void:
	direction = dir
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))

func hit(target: HealthComponent = null) -> void:
	$Sprite2D.frame_coords.y = 4
	#direction = Vector2.ZERO
	direction *= .1
	
	if target:
		target.damage(damage)
	
	await get_tree().create_timer(.05).timeout
	queue_free()
