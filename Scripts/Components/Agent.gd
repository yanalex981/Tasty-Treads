@tool
class_name Agent
extends CharacterBody2D

@export var spritesheet : Texture:
	set(value):
		$sprite.texture = value
		spritesheet = value
