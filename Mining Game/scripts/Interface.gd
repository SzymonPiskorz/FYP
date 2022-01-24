extends RichTextLabel

export var tokens : bool

func _update_ui(amount):
	if tokens:
		self.text = "\n Tokens Collected: "+ String(amount)
	else:
		self.text = "\n Health: "+ String(amount)+"/10"
