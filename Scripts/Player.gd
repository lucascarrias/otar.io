extends Node2D

var POWER_UPS = ["speed", "expansion"]
var can_use = false
var selected_power_up
var is_powerup_off = true
var used = false;

var power_speed: int = 1;

var size: float;
var zoom: float;

var t = Timer.new();
var time_to_use_power_up = Timer.new()

func _ready():
	randomize()
	time_to_use_power_up.wait_time = 30
	time_to_use_power_up.connect("timeout", self, "on_can_use_power_up")
	add_child(time_to_use_power_up)
	time_to_use_power_up.start()
	
	self.size = 1.0
	self.zoom = 1.0
	
	$MeshInstance2D.modulate = Color8(rand_range(0, 255), rand_range(0,255), 255);
	self.selected_power_up = POWER_UPS[randi() % len(POWER_UPS)]

func _process(delta):
	$MeshInstance2D.scale.x = lerp($MeshInstance2D.scale.x, size, 0.1)
	$MeshInstance2D.scale.y = lerp($MeshInstance2D.scale.y, size, 0.1)
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x, zoom, 0.1)
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y, zoom, 0.1)
	
	read_input()
	
	var foods = get_tree().get_nodes_in_group("Food")
	var bots = get_tree().get_nodes_in_group("Bot")

	for food in foods:
		if $MeshInstance2D/Area2D.overlaps_area(food):
			food.queue_free()
			size += 0.05
			zoom += 0.05
			
		food.scale.x = self.size * 0.08
		food.scale.y = self.size * 0.08
		
	for bot in bots:
		if $MeshInstance2D/Area2D.overlaps_area(bot):
			if bot.get_parent().get_parent().size <= self.size:
				bot.get_parent().get_parent().queue_free()
				size += 0.2
				zoom += 0.2
			else:
				get_tree().quit(0)


func read_input():
	if Input.is_action_pressed("ui_right"): position.x += 7 * power_speed
	if Input.is_action_pressed("ui_left"): position.x -= 7 * power_speed 
	if Input.is_action_pressed("ui_down"): position.y += 7 * power_speed
	if Input.is_action_pressed("ui_up"): position.y -= 7 * power_speed
	
	if Input.is_action_just_pressed("ui_accept") and is_powerup_off and can_use: turn_on_power_up()
	
func turn_on_power_up():
	is_powerup_off = false
	
	if selected_power_up == "speed":
		power_speed = 3
		t.wait_time = 5
		t.connect("timeout", self, "on_speed_timeout")
		add_child(t)
		t.start()
		
	if selected_power_up == "expansion":
		if not used:
			self.size *= 2
			self.zoom *= 2 
			used = true
			
	can_use = false
	time_to_use_power_up.start()


func on_speed_timeout():
	is_powerup_off = true
	power_speed = 1
	

func on_can_use_power_up():
	can_use = true
