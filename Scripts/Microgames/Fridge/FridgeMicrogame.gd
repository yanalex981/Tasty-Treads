extends Node2D

@onready var item_position_list = $Fridge/ValidItemPositions
@onready var ingredients = $IngredientsList
@onready var progress_label = $UI/ProgressLabel
@onready var total_label = $UI/TotalLabel
@onready var end_display = $UI/EndUI

var good_items = [] : set = set_good_items
var bad_items = [] : set = set_bad_items

var total_items = 0
var num_good_grabbed = 0
var num_bad_grabbed = 0
var score : int = 0

signal game_ended(results)

func _ready():
	# testing 
#	var good = ['Eggs', "Flour", 'Butter']
#	var bad = ['FishHead', 'Bottle']
#	start(good, bad)
	pass

func _process(_delta):
	# check if all the good ingredients are grabbed
	if num_good_grabbed == total_items:
		# show the game is done 
		end_display.show()
		
		# evaluate score
		var penalty = num_bad_grabbed * 0.5
		@warning_ignore("narrowing_conversion")
		score = ((num_good_grabbed - penalty) / num_good_grabbed) * 100
		# print(score)
		emit_signal("game_ended", score)
		
		# close the game
		await get_tree().create_timer(1.0).timeout
		queue_free()
		

# place the given ingredients
func start(good_ingredients, bad_ingredients):
	set_good_items(good_ingredients)
	set_bad_items(bad_ingredients)
	place_random()
	
	total_items = good_ingredients.size()
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

func increase_bad():
	num_bad_grabbed += 1
	#print(num_bad_grabbed)

