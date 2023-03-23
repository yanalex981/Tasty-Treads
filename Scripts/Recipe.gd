class_name Recipe
extends Resource

enum TaskType {
	GET_INGREDIENTS,
	MIX,
	POUR,
	CUT_COOKIES,
	BAKE,
	COOL,
	SMEAR_ICING,
	ADD_SPRINKLES,
}

@export var name: String
@export var spawn_weighting : int
@export var price : float
@export var recipe_steps : Array[TaskType]
