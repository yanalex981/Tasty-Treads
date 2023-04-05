class_name Player
extends CharacterBody2D

var earnings : int = 0
var tips : int = 0:
	set(value):
		tips = 0 if value < 0 else value

@export var enabled : bool = true
