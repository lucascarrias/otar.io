extends Node2D


export(PackedScene) var bot;

func _ready():
	var player = get_node("../Player")
	for i in range(5):
		add_bot(player.position.x, player.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("../Player")
	var mesh: MeshInstance2D = player.get_children()[1]
	var bots = get_tree().get_nodes_in_group("Food")
	
	if bots.size() < 5:
		for i in range(5 - bots.size()):
			add_bot(player.position.x * mesh.scale.x, player.position.y * mesh.scale.y)

func add_bot(offset_x, offset_y):
	var b = bot.instance()
	add_child(b)
	randomize()
	b.position.x = rand_range(-(1000 + abs(offset_x)), 1000 + abs(offset_x))
	b.position.y = rand_range(-(1000 + abs(offset_y)), 1000 + abs(offset_y))
