extends Node2D

var size: float = 1.0


func _process(delta):
	$MeshInstance2D.scale.x = lerp($MeshInstance2D.scale.x, size, 0.1)
	$MeshInstance2D.scale.y = lerp($MeshInstance2D.scale.y, size, 0.1)
	
	var target_group = get_tree().get_nodes_in_group("Food")
	var distance_away = self.global_transform.origin.distance_to(target_group[0].global_transform.origin)
	var return_node = target_group[0]
	for index in target_group.size():
		var distance = self.global_transform.origin.distance_to(target_group[index].global_transform.origin)
		if distance < distance_away:
			distance_away = distance
			return_node = target_group[index]
	
	_walk_to_food(return_node)
	
	var foods = get_tree().get_nodes_in_group("Food")

	for food in foods:
		if $MeshInstance2D/Area2D.overlaps_area(food):
			food.queue_free()
			size += 0.05

func _walk_to_food(food):
	if self.global_position.x <= food.global_position.x:
		position.x += 7
	if self.global_position.x >= food.global_position.x:
		position.x -= 7
		
	if self.global_position.y <= food.global_position.y:
		position.y += 7
	if self.global_position.y >= food.global_position.y:
		position.y -= 7
