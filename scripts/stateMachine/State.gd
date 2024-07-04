class_name State
extends Node

## Hold refernce to parent object so it can be controlled by the state
var parent: CharacterBody2D
var sprite: Sprite2D
var animPlayer: AnimationPlayer
var moveComponent: MoveComponent

func enter() -> void:
	pass

func update(_delta: float) -> State:
	return null

func updatePhysics(_delta: float) -> State:
	return null

func exit() -> void:
	pass
