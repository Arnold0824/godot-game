class_name AnimationState
extends Node2D

@onready var character: Character = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func _physics_process(delta: float) -> void:
    set_animation_tree_state()


func set_animation_tree_state():
    set_loop()


func set_loop():
    character.animation_tree.set("parameters/movement_state/blend_position", character.current_action_state)
    character.animation_tree.set("parameters/movement_state/%s/%s/blend_amount" % [character.current_action_state,
        character.ACTION_STATE[character.current_action_state]], character.current_movement_state)
    character.animation_tree.set("parameters/movement_state/%s/%s/blend_amount" % [character.current_action_state,
        character.MOVEMENT_STATE[character.current_movement_state]], character.current_face_direction)
