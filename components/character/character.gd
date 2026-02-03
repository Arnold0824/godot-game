extends CharacterBody2D
class_name Character

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction: Vector2 = Vector2.ZERO
var is_run: bool = false

@export var animation_tree: AnimationTree
@export var graphics: Node2D

func _process(delta):
    get_input_values()
    

func get_input_values():
    if not is_interactable() or LoadingManager.is_loading:
        direction = Vector2.ZERO
        return
    direction = Input.get_vector('left', 'right', 'up', 'down', )
    is_run = Input.is_action_pressed('run')

func is_interactable():
    return current_action_state == ActionState.Default


func _physics_process(delta: float) -> void:
    movement()
    set_action_state()
    set_face_direction()
    set_movement_state()
    transform_graphics_scale()
    move_and_slide()
    
    
#region movement    
@export_group("movement")
@export var walk_speed: float = 3.0
@export var run_speed: float = 6.0

enum ActionState {
    Default, # 默认状态
    
}

const ACTION_STATE = {
    ActionState.Default: "default"
    
}

enum MovementState {
    Idle = -1,
    Walk,
    Run
}

const MOVEMENT_STATE = {
    MovementState.Idle: 'idle',
    MovementState.Walk: 'walk',
    MovementState.Run: 'run',
}
enum FaceDirection {
    Forward = -1,
    Backward,
    Parallel
}
const FACE_DIRECTION = {
    FaceDirection.Forward: 'forward',
    FaceDirection.Backward: 'backward',
    FaceDirection.Parallel: 'parallel',
}

var current_action_state: ActionState = ActionState.Default
var current_face_direction: FaceDirection = FaceDirection.Forward
var current_movement_state: MovementState = MovementState.Idle

func movement():
    if not is_interactable() or LoadingManager.is_loading:
        velocity = Vector2.ZERO
        return
    velocity = direction * (walk_speed if not is_run else run_speed) * 40

func transform_graphics_scale():
    if !is_zero_approx(direction.x):
        graphics.scale.x = 1 if direction.x > 0 else -1

func set_action_state():
    current_action_state = ActionState.Default

func set_face_direction():
    if !direction.is_zero_approx():
        if !is_zero_approx(direction.x):
            current_face_direction = FaceDirection.Parallel
        else:
            current_face_direction = FaceDirection.Forward if direction.y > 0 else FaceDirection.Backward
func set_movement_state():
    if direction.is_zero_approx():
        current_movement_state = MovementState.Idle
    else:
        current_movement_state = MovementState.Run if is_run else MovementState.Walk
        
    
#endregion
