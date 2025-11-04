local UI=loadstring(game:GetObjects("rbxassetid://92993655011671")[1].Source)()

local Window=UI:CreateWindow()

Window:SetTitle("Test Panel")

Window:AddContext({
	Type="TextLabel",
	Name="Text Here"
})

Window:AddContext({
	Type="Button",
	Name="Example",
	Callback=function()
		warn("Example Pressed")
	end
})

Window:AddContext({
	Type="Button",
	Name="Simple",
	Callback=function()
		warn("Simple Pressed")
	end
})

Window:AddContext({
	Type="Switch",
	Name="Sample",
	Callback=function(active)
		warn("Sample Switched:",active)
	end
})

Window:AddContext({
	Type="TextBox",
	Name="Index Type",
	Callback=function(text)
		warn("Index Type:",text)
	end
})

Window:AddContext({
	Type="Selector",
	Name="Option 1",
	Options={"Option 1","Option 2","Option 3"},
	Callback=function(key,value)
		warn("Index Type:",key,value)
	end
})
