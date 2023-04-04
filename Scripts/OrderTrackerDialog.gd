class_name OrderTrackerDialog
extends VBoxContainer

@export var completed_icon : Texture:
	set(value):
		completed_icon = value
		_render_ui()
@export var in_progress_icon : Texture:
	set(value):
		in_progress_icon = value
		_render_ui()
@export var incomplete_icon : Texture:
	set(value):
		incomplete_icon = value
		_render_ui()

var order : Recipe = null:
	set(value):
		order = value
		_render_ui()

var progress : int = 0:
	set(value):
		progress = value
		_render_ui()

func _clear_grid():
	for item in $items_grid.get_children():
		item.queue_free()

func _get_description(task : Recipe.TaskType):
	match task:
		Recipe.TaskType.GET_INGREDIENTS:
			return "Get ingredients"
		Recipe.TaskType.MIX:
			return "Mix ingredients"
		Recipe.TaskType.POUR:
			return "Pour batter"
		Recipe.TaskType.CUT_COOKIES:
			return "Cut cookies"
		Recipe.TaskType.BAKE:
			return "Oven bake"
		Recipe.TaskType.COOL:
			return "Supersonic cooling"
		Recipe.TaskType.SMEAR_ICING:
			return "Smear icing"
		Recipe.TaskType.ADD_SPRINKLES:
			return "Sprinkle sprinkles"
		_:
			return ""

func _add_completed_row(description, bonus):
	var status_icon = TextureRect.new()
	status_icon.texture = completed_icon
	var desc_label = Label.new()
	desc_label.text = description
	desc_label.add_theme_color_override("font_color", Color.LIME_GREEN)
	var bonus_label = Label.new()
	
	$items_grid.add_child(status_icon)
	$items_grid.add_child(desc_label)
	$items_grid.add_child(bonus_label)

func _add_in_progress_row(description, bonus):
	var status_icon = TextureRect.new()
	status_icon.texture = in_progress_icon
	var desc_label = Label.new()
	desc_label.text = description
	desc_label.add_theme_color_override("font_color", Color.GOLDENROD)
	var bonus_label = Label.new()
	
	$items_grid.add_child(status_icon)
	$items_grid.add_child(desc_label)
	$items_grid.add_child(bonus_label)

func _add_incomplete_row(description, bonus):
	var status_icon = TextureRect.new()
	status_icon.texture = incomplete_icon
	var desc_label = Label.new()
	desc_label.text = description
	desc_label.add_theme_color_override("font_color", Color.DIM_GRAY)
	var bonus_label = Label.new()
	
	$items_grid.add_child(status_icon)
	$items_grid.add_child(desc_label)
	$items_grid.add_child(bonus_label)

func _render_ui():
	if order == null:
		$title_label.text = "Your next order is ready to be picked up!"
		_clear_grid()
		return
	
	$title_label.text = order.name
	_clear_grid()
	for step in order.recipe_steps.size():
		var task = order.recipe_steps[step]
		var description = _get_description(task)
		var bonus = ""
		if step < progress:
			_add_completed_row(description, bonus)
		elif step == progress:
			_add_in_progress_row(description, bonus)
		else:
			_add_incomplete_row(description, bonus)
