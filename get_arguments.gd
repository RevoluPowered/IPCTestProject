extends Node

@export var TextEditor : TextEdit
@export var SomethingCool : RichTextLabel
var URLDataBuffer = ""


func _on_url_received( url ):
	print("URL:", url)
	URLDataBuffer += url + "\n"
	if url.contains("DoSomethingCool"):
		SomethingCool.visible = !SomethingCool.visible
		pass
# Called when the node enters the scene tree for the first time.
func _ready():
	OS.register_protocol("godotapp")
	for arg in OS.get_cmdline_args():
		print("Argument: ", arg)
			
		if(arg.contains("app://")):
			var SplitHostnameAndArguments = arg.split("?")
			if(SplitHostnameAndArguments.size()): ## this is for URI handlers
				var SplitArguments = SplitHostnameAndArguments[1].split("&")
				#TextEditor.text += "Argument Input to splitter: " + SplitHostnameAndArguments[0] + "|Split|" + SplitHostnameAndArguments[1] + "\n"
				TextEditor.text += "App Name: " + SplitHostnameAndArguments[0] + "\n"
				for actual_args in SplitArguments:
					TextEditor.text += actual_args.uri_decode() + "\n"
			else:
				TextEditor.text = "Error URI doesn't contain args"
		else:
			TextEditor.text = ""
			
	AppProtocol.connect("on_url_received", _on_url_received)

var num = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num += delta
	TextEditor.text = "Time: " + str(floor(num)) + "\n"
	TextEditor.text += URLDataBuffer
	AppProtocol.poll_server()
	pass
