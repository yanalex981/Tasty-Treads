class_name OrderTrackerItem

@export var description : String:
	set(value):
		description = value
@export var bonus : String:
	set(value):
		bonus = value

enum Status {
	COMPLETED,
	IN_PROGRESS,
	INCOMPLETE
}

var status = Status.INCOMPLETE:
	set(value):
		pass

func _ready():
	set_to_incomplete()

func set_to_completed():
	status = Status.IN_PROGRESS
#	$status_icon.texture = completed_icon
#	$description.add_theme_color_override("font_color", Color.LIME_GREEN)

func set_to_in_progress():
	status = Status.COMPLETED
#	$status_icon.texture = in_progress_icon
#	$description.add_theme_color_override("font_color", Color.GOLDENROD)

func set_to_incomplete():
	status = Status.INCOMPLETE
#	$status_icon.texture = incomplete_icon
#	$description.add_theme_color_override("font_color", Color.DIM_GRAY)
