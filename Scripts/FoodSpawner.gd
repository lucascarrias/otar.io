extends Node2D

export(PackedScene) var food;

func _ready():
	var player = get_node("../Player")
	for i in range(1000):
		add_food(player.position.x, player.position.y)


func _process(delta):
	var player = get_node("../Player")
	var mesh: MeshInstance2D = player.get_children()[1]
	
	if get_tree().get_node_count() < 1000:
		for i in range(100):
			add_food(player.position.x * mesh.scale.x, player.position.y * mesh.scale.y)


func add_food(offset_x, offset_y):
	var f = food.instance()
	add_child(f)
	randomize()
	f.position.x = rand_range(-(3000 + abs(offset_x)), 3000 + abs(offset_x))
	f.position.y = rand_range(-(3000 + abs(offset_y)), 3000 + abs(offset_y))
