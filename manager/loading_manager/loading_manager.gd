extends Node
@export var loading :ColorRect
@export var animation_player:AnimationPlayer

var is_loading := false
func enter(center:Vector2,invert:bool=false,callback: Callable =func():pass):
    is_loading = true
    loading.material.set('shader_parameter/is_active',invert)
    loading.material.set('shader_parameter/center_point',center)
    animation_player.play('enter')
    await  animation_player.animation_finished
    callback.call()
    
func leave(center:Vector2,invert:bool=false,callback: Callable =func():pass):
    loading.material.set('shader_parameter/center_point',center)
    animation_player.play('leave')
    await  animation_player.animation_finished
    is_loading = true
    callback.call()
    
    
    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
