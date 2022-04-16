#Refference is   https://www.youtube.com/watch?v=iSpWZzL2i1o

#this is the tiger player

extends KinematicBody2D

var selected = false;
signal tigerplayerturnfinished
var allowturn = false;



var location
var initial_position
var initial_location
var final_position
var final_location
var goat_position
var goat_location


onready var goat_condition = false
var goat_path



func _ready():
	location =  get_position();
	for i in get_parent().get_parent().gameplay_position:
		if get_parent().get_parent().gameplay_position[i] == location:
			initial_position = i
	goat_path = null




func _physics_process(delta):
		if selected and get_parent().player1==true:
			global_position = lerp(global_position, get_global_mouse_position(),50*delta)
		else:
			global_position = lerp(global_position, location,10*delta)
			
		if($RayCastDown.is_colliding() ):
			if ($RayCastDown.get_collider ( ).get_parent().get_name()== "Tiger"):
				selected = false
			elif($RayCastDown.get_collider ( ).get_parent().get_name()== "Goat"):
					goat_path = $RayCastDown.get_collider ( )
					goat_condition = true
		
		elif($RayCastLeft.is_colliding() ):
			if ($RayCastLeft.get_collider ( ).get_parent().get_name()== "Tiger" ):
				selected = false
			elif($RayCastLeft.get_collider ( ).get_parent().get_name()== "Goat"):
				goat_path = $RayCastLeft.get_collider ( )
				goat_condition = true

		
		elif($RayCastUp.is_colliding() ):
			if ($RayCastUp.get_collider ( ).get_parent().get_name()== "Tiger" ):
				selected = false
			elif($RayCastUp.get_collider ( ).get_parent().get_name()== "Goat"):
				goat_path = $RayCastUp.get_collider ( )
				goat_condition = true
		
		elif($RayCastRight.is_colliding() ):
			if ($RayCastRight.get_collider ( ).get_parent().get_name()== "Tiger" ):
				selected = false
			elif($RayCastRight.get_collider ( ).get_parent().get_name()== "Goat"):
				goat_path = $RayCastRight.get_collider ( )
				goat_condition = true


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false;



func _on_TigerArea_input_event(viewport, event, shape_idx):
	if event.is_action("movement_click") and Input.is_action_just_pressed("movement_click") and not event.is_echo():
		selected = true;
	if event.is_action("movement_click") and Input.is_action_just_released("movement_click") and not event.is_echo():
		selected = false;
		initial_location = get_parent().get_parent().gameplay_position[initial_position]
		final_location = get_parent().get_parent().gameplay_position[final_position] 
		if goat_condition == true:
			var allowed;
			goat_location = goat_path.get_position()
			goat_location.x = round(goat_location.x)
			goat_location.y = round(goat_location.y)
			for i in get_parent().get_parent().gameplay_position:
				if get_parent().get_parent().gameplay_position[i] == goat_location:
					goat_position = i
			for i in get_parent().get_parent().allowed_moves[initial_position]:
				if get_parent().get_parent().gameplay_position[i] == goat_location:
					allowed = true
			#print(allowed)
			if get_parent().get_parent().item_in_zone[final_position][0] == null and allowed ==true:
				if initial_location.x == goat_location.x:
					
					if initial_location.y > goat_location.y: 
						if final_location.x == goat_location.x and final_location.y == goat_location.y-100:
							eat_goat_movement()
						else:
							movement()
							
					else:
						if goat_location.x == final_location.x and final_location.y == goat_location.y+100:
							eat_goat_movement()
						else:
							movement()
						
				elif initial_location.y == goat_location.y:
					
					if initial_location.x > goat_location.x:
						if final_location.x == goat_location.x-100 and goat_location.y ==final_location.y:
							eat_goat_movement()
						else:
							movement()
						
					else:
						if final_location.x == goat_location.x+100 and goat_location.y == final_location.y:
							eat_goat_movement()
						else:
							movement()
						
				else:
					
					if initial_location.x < final_location.x and initial_location.y > final_location.y:
						if final_location.x == goat_location.x+100 and final_location.y == goat_location.y-100:
							eat_goat_movement()
						else:
							movement()
					
					elif initial_location.x < final_location.x and initial_location.y < final_location.y:
						if final_location.x == goat_location.x+100 and final_location.y == goat_location.y+100:
							eat_goat_movement()
						else:
							movement()
					
					elif initial_location.x > final_location.x and initial_location.y > final_location.y:
						if final_location.x == goat_location.x-100 and final_location.y == final_location.y-100:
							eat_goat_movement()
						else:
							movement()
					
					elif initial_location.x < final_location.x and initial_location.y < final_location.y:
						if final_location.x == goat_location.x+100 and final_location.y == goat_location.y+100:
							eat_goat_movement()
						else:
							movement()
					
					else:
						pass
					
			else:
				selected = false
				get_parent().player1 = true
		
		else :
			for i in get_parent().get_parent().allowed_moves[initial_position]:
				if i == final_position:
					get_parent().get_parent().item_in_zone[final_position][0] = "tiger"
					
					get_parent().get_parent().item_in_zone[initial_position][0] = null
					initial_position = final_position
					location = get_parent().get_parent().gameplay_position[final_position]
					get_parent().player1 = false
					emit_signal("tigerplayerturnfinished")
			location = get_parent().get_parent().gameplay_position[initial_position]
			get_parent().player1 = true


func eat_goat_movement():
	goat_path.queue_free()
	goat_condition = false
	get_parent().get_parent().item_in_zone[goat_position][0] = null
	get_parent().get_parent().item_in_zone[initial_position][0] = null
	get_parent().goat_eaten = get_parent().goat_eaten +1
	if get_parent().goat_eaten == 5:
		get_tree().change_scene("res://Main Project/Levels and interface/Tiger won.tscn")
	
	initial_position = final_position
	location = get_parent().get_parent().gameplay_position[final_position]
	get_parent().get_parent().item_in_zone[final_position][0] = "tiger"
	get_parent().player1 = false
	emit_signal("tigerplayerturnfinished")


func movement():
	for i in get_parent().get_parent().allowed_moves[initial_position]:
		if i == final_position:
			get_parent().get_parent().item_in_zone[final_position][0] = "tiger"
				
			get_parent().get_parent().item_in_zone[initial_position][0] = null
			initial_position = final_position
			location = get_parent().get_parent().gameplay_position[final_position]
			get_parent().player1 = false
			emit_signal("tigerplayerturnfinished")
	location = get_parent().get_parent().gameplay_position[initial_position]
	get_parent().player1 = true
