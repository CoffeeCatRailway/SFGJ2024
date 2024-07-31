extends PointLight2D

@export var frequency: float = .15
@export var energyMultiplier: float = 11.

var noiseTex: NoiseTexture2D
var timePassed: float = 0.

func _ready() -> void:
	randomize()
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi() % 10
	noise.frequency = frequency
	
	noiseTex = NoiseTexture2D.new()
	noiseTex.width = 50
	noiseTex.height = 50
	noiseTex.noise = noise

func _process(delta: float) -> void:
	timePassed += delta
	
	var sampledNoise: float = noiseTex.noise.get_noise_1d(timePassed)
	sampledNoise = absf(sampledNoise)
	
	energy = sampledNoise * energyMultiplier
