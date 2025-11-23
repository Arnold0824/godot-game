class_name Game
extends Node2D

enum LevelType{
    
    Birth
}

# 对应文件名
const level_type_dict: Dictionary = {
    LevelType.Birth:"birth"
}

var current_level_instance

signal level_loaded

func load_level(level : LevelType):
    var level_path = "res://levels/%s/%s.tscn"%[level_type_dict[level],level_type_dict[level]]
    ResourceManager.load_resource_async(level_path,
        func(scene:Resource):
            current_level_instance = scene.instantiate()
            add_child(current_level_instance)
            level_loaded.emit(),
        func(progress):
            print(progress)
    )
    
    
    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    load_level(LevelType.Birth) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
