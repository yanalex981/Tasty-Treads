extends Node2D

@export var upgraded : bool = false : set = set_upgraded
@export var testing : bool = false : set = set_testing

@onready var item_position_list = $Fridge/ValidItemPositions
@onready var ingredients = $IngredientsList
@onready var progress_label = $UI/ProgressLabel
@onready var total_label = $UI/TotalLabel
@onready var end_display = $UI/EndUI

@onready var arm = $RobotHand
const UP_SPEED : int = 800

var good_items : Array = [] : set = set_good_items
var bad_items : Array = [] : set = set_bad_items

var num_good_grabbed : int = 0
var bad_grabbed : bool = false # tracks whether a bad ingredient was grabbed

var success : bool = false
signal game_ended(results)

func _ready():
	if (upgraded):
		arm.set_speed(UP_SPEED)
	
	# use for testing in-scene
#	if (testing):
#		var good = ['Eggs', "Flour", 'Butter']
#		var bad = ['FishHead', 'Bottle']
#		start(good, bad)
	

func set_upgraded(status):
	upgraded = status

func _process(_delta):	
	# check if all the good ingredients are grabbed
	if num_good_grabbed == good_items.size():
		# show the game is done 
		end_display.show()
		get_tree().paused = true
		
		# evaluate: if a single bad item was grabbed, it is a failure
		if !bad_grabbed:
			success = true
		else:
			success = false
		
#		print(success)
		emit_signal("game_ended", success)
		
		# close the game
		await get_tree().create_timer(1.0).timeout
		queue_free()
		

# place the given ingredients
func start(good_ingredients, bad_ingredients):
	set_good_items(good_ingredients)
	set_bad_items(bad_ingredients)
	place_random()
	
	# update UI text
	total_label.text = str(good_ingredients.size())


func set_good_items(given_items):
	good_items = given_items

func set_bad_items(given_items):
	bad_items = given_items

# randomly place given items using a list of markers
func place_random():
	var positions = item_position_list.get_children()
	var items_to_place = good_items + bad_items
	positions.shuffle()

	for i in range(items_to_place.size()):
		var marker = positions[i]
		var item_name = items_to_place[i]
		
		var cur_item = ingredients.get_node(item_name)
		cur_item.global_position = marker.global_position

func increase_good():
	num_good_grabbed += 1
	#print(num_good_grabbed)
	progress_label.text = str(num_good_grabbed)

func set_bad():
	bad_grabbed = true

func set_testing(status : bool):
	testing = status

