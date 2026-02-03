extends Node

class ScreenPostionResult:
    var position:Vector2
    var canvas_position:Vector2
    var is_on_screen:bool
    func _init(position,canvas_position,is_on_screen) -> void:
        self.position = position
        self.canvas_position = canvas_position
        self.is_on_screen = is_on_screen
        
  
func get_screen_position(node:Node2D) -> ScreenPostionResult:
    var viewport := get_viewport()
    var canvas_position := viewport.canvas_transform * node.global_position
    var viewport_size := viewport.get_visible_rect().size
    
    var normalized := Vector2(canvas_position.x / viewport_size.x,canvas_position.y / viewport_size.y)
    return ScreenPostionResult.new(normalized,canvas_position,(normalized.x > 0 and normalized.x < 1 and  normalized.y > 0 and normalized.y < 1))
