class_name Game
extends Node2D

enum LevelType{
    
    Birth
}

# 对应文件名
const level_type_dict: Dictionary = {
    LevelType.Birth:"birth"
}

enum Season{
    Spring,
    Summer,
    Fall,
    Winter
    
}

var season_dict:Dictionary = {
    Season.Spring : "spring",
    Season.Summer : "summer",
    Season.Fall : "fall",
    Season.Winter : "winter",
}
var current_level_instance
@export var camera:Camera
@export var character:Character

signal level_loaded

func _enter_tree() -> void:
   GameManager.game = self
   
func _exit_tree() -> void:
    GameManager.game = null

func load_level(level : LevelType):
    var level_path = "res://levels/%s/%s.tscn"%[level_type_dict[level],level_type_dict[level]]
    ResourceManager.load_resource_async(level_path,
        func(scene:Resource):
            current_level_instance = scene.instantiate()
            add_child(current_level_instance)
            camera.set_limit()
            camera.set_follow_target(character)
            level_loaded.emit(),
        func(progress):
            print(progress),
    )
    

    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    #print("loading....")
    load_level(LevelType.Birth) # Replace with function body.
    

## 获取某个节点（含子节点）下面所有的 TileMapLayer
func get_all_tilemap_layers(root: Node) -> Array[TileMapLayer]:
    var result: Array[TileMapLayer] = []

    # 保险起见，先判空
    if root == null:
        return result

    _collect_tilemap_layers(root, result)
    return result


## 递归收集函数（内部使用）
func _collect_tilemap_layers(node: Node, result: Array[TileMapLayer]) -> void:
    if node == null:
        return

    # 遍历当前节点的所有子节点
    for child in node.get_children():
        # 先确保 child 不为 null
        if child == null:
            continue

        # 如果是 TileMapLayer，就加入结果数组
        if child is TileMapLayer:
            result.append(child)
        # 继续递归遍历它的子节点
        _collect_tilemap_layers(child, result)
         
func switch_season(season:Season):
    var tilemap_layers:Array[TileMapLayer] = []
    #collect_tilemap_layers(current_level_instance,tilemap_layers)
    for child in get_all_tilemap_layers(current_level_instance):
        if child is TileMapLayer and child.get_meta("seasonal"):
            tilemap_layers.append(child)
    var tileset:Resource = ResourceManager.load_resource("res://used/tileset/%s/%s.tres" % [season_dict[season],season_dict[season]])
    for tilemap in tilemap_layers:
        tilemap.tile_set = tileset
    
func switch_season_with_anim(season:Season):
    LoadingManager.enter(Vector2(0.5,0.5),false,
    func():
        switch_season(season)
        LoadingManager.leave(Vector2(0.5,0.5),false)
    )
    
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
#    print(LoadingManager.loading.material.get('shader_parameter/progress'))
    if not Engine.has_singleton("ImGuiAPI"):
        return
    var imgui: Object = Engine.get_singleton("ImGuiAPI")

    # 2. 每帧绘制 ImGui 窗口 + 按钮
    imgui.Begin("Debug")
    if imgui.Button("Spring"):
        print("Spring clicked")
        switch_season_with_anim(Season.Spring)

    if imgui.Button("Summer"):
        print("Summer clicked")
        switch_season_with_anim(Season.Summer)

    if imgui.Button("Fall"):
        print("Fall clicked")
        switch_season_with_anim(Season.Fall)

    if imgui.Button("Winter"):
        print("Winter clicked")
        switch_season_with_anim(Season.Winter)

    imgui.End()
