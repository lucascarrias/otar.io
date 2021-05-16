extends Area2D

func _ready():
	randomize()
	$MeshInstance2D.modulate = Color8(rand_range(0, 255), rand_range(0,255), 255);

