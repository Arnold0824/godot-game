extends Node


func load_resource(path:String):
    if not ResourceLoader.exists(path): return null
    var resource := ResourceLoader.load(path)
    return resource
    
    
func load_resource_async(path:String,callback:Callable,progress:Callable):
    if not ResourceLoader.exists(path): return null
    var loading_progress: Array[float] = []
    ResourceLoader.load_threaded_request(path)
    while 1:
        print('loading!!!')
        var status = ResourceLoader.load_threaded_get_status(path,loading_progress)
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            var resource = ResourceLoader.load_threaded_get(path)
            callback.call(resource)
            break
        elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            progress.call(loading_progress)
        elif status == ResourceLoader.THREAD_LOAD_FAILED:
            print('failed loading resource!')
            break
        await get_tree().process_frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("success load autoload!") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
