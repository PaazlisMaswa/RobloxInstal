if not game:IsLoaded() then game.Loaded:Wait() end

local function Missing(t,v,f)
	return type(v)==t and v or f
end

setclipboard=Missing("function",setclipboard,function(text) warn(text) end)

local Services={}

for i,servieName in ipairs({"Workspace","Players","UserInputService","RunService","ReplicatedFirst","ReplicatedStorage","SoundService","Lighting","Teams","InsertService","StarterGui","StarterPack","HttpService"}) do
	if not Services[servieName] then
		local success,service=pcall(game.GetService,game,servieName)
		if success and service then
			Services[servieName]=service
		end
	end
end

local Workspace,Players,UserInputService,RunService,ReplicatedFirst,ReplicatedStorage,SoundService,Lighting,Teams,InsertService,StarterGui,StarterPack,HttpService=Services["Workspace"],Services["Players"],Services["UserInputService"],Services["RunService"],Services["ReplicatedFirst"],Services["ReplicatedStorage"],Services["SoundService"],Services["Lighting"],Services["Teams"],Services["InsertService"],Services["StarterGui"],Services["StarterPack"],Services["HttpService"]

local Util={}
do
	function Util.MakeShortInstance(instance)
		local newFolder=Instance.new("Folder") 
		newFolder.Parent=instance.Parent 
		for i,v in ipairs(instance:GetChildren()) do 
			local chilren=v:GetChildren() 
			if #chilren==1 then 
				chilren[1].Parent=newFolder 
				v:Destroy() 
			else 
				v.Parent=newFolder 
			end 
		end 
		for i,v in ipairs(newFolder:GetChildren()) do 
			v.Parent=instance 
		end 
		if #instance:GetChildren()==1 then 
			local v=instance:GetChildren()[1] 
			v.Parent=instance.Parent 
			instance:Destroy() 
			instance=v 
		end 
		newFolder:Destroy() 
		newFolder=nil 
		return instance
	end

	function Util.CopyInstance(className,instance,properties)
		local newInstance=Instance.new(className)  
		local i=1  
		for j,k in pairs(properties) do  
			local v=properties[i] 
			if v then 
				i=i+1 
				local success=pcall(function() return newInstance[v] end)
				if success then  
					newInstance[v]=instance[v] 
				end 
			end 
		end 
		return newInstance
	end

	function Util.ConvertMeshPartToSpecialMesh(instance)
		local properties={"Name","Anchored","Locked","CanCollide","Transparency","Color","Material","Reflectance","CFrame","BackSurface","BottomSurface","FrontSurface","LeftSurface","RightSurface","TopSurface","Size"}
		if instance:IsA("MeshPart") then
			local part=Instance.new("Part")
			for i,v in ipairs(properties) do if pcall(function() return part[v] end) then part[v]=instance[v] end end
			local specialMesh=Instance.new("SpecialMesh")
			specialMesh.Name="SpecialMesh"
			specialMesh.MeshType=Enum.MeshType.FileMesh
			specialMesh.MeshId=instance.MeshId
			specialMesh.TextureId=instance.TextureID
			specialMesh.Scale=(1/instance.MeshSize)*instance.ExtentsSize
			specialMesh.Parent=part
			part.Parent=instance.Parent
			local t={}
			for j,k in ipairs(instance:GetDescendants()) do if not k:IsA("SurfaceAppearance") then k.Parent=part else table.insert(t,k) end end
			if next(t) then for i,v in ipairs(t) do if not v:IsA("SurfaceAppearance") then v.Parent=part table.remove(t,i) end end end
			if next(t) then for i,v in ipairs(t) do v:Destroy() end end
			instance:Destroy()
		end
	end

	function Util.Changed(value,func)
		coroutine.create(coroutine.create(function()
			local v1,v2=value(),value() 

			while true do 
				if v1~=v2 then 
					v2=v1 v1=v2 
					local v3=func(v1) 
					if v3 and typeof(v3)==typeof(v1) then 
						v2=v3 v1=v3 
					end 
				end 
				v1=value() 
				task.wait() 
			end
		end))
	end

	function Util.IsSomethings(needles,match)
		for i,v in ipairs(needles) do if match(v)==true then return true end end return false
	end

	function Util.IsAs(instance,classNames)
		return Util.IsSomethings(classNames,function(v) return instance:IsA(v) end)
	end

	function Util.IsStrings(s1,s2)
		return Util.IsSomethings(s2,function(v) return s1==v end)
	end

	function Util.GetLines(s)
		local lastBreak=0

		local function NextLine()
			if lastBreak==#s then return nil end

			local line
			local nextBreak=string.find(s,"\n",lastBreak + 1)			

			if nextBreak then
				line=s:sub(lastBreak + 1,nextBreak - 1)
				lastBreak=nextBreak
			else
				line=s:sub(lastBreak + 1,#s)
				lastBreak=#s
			end

			return line
		end

		return NextLine
	end

	function Util.GetAncestorsAndSelf(instance)
		local current=nil

		local function NextParent()
			if not current then current=instance else current=current.Parent end return current
		end

		return NextParent
	end

	function Util.GetProperties(t)
		local i=0
		local function NextProperty() i=i+1 if t[i] then return t[i],t[t[i]],i end end
		return NextProperty
	end

	function Util.GetInstanceProperty(instance,propertys,func)
		for i,v in ipairs(propertys) do 
			local success=pcall(function() return instance[v] end)
			if success then
				pcall(func,typeof(instance[v]),instance[v],v,i)
			end 
		end 
	end

	function Util.CreateVariable(instance:Instance,variables:{[Instance]:string},name:string?)
		local currentName=type(name)=="string" and name or instance.Name

		-- Remove symbols
		local nameWithoutSymbols=""
		for v in string.gmatch(currentName,"[%w_]") do nameWithoutSymbols=nameWithoutSymbols..v end

		-- Check for string
		local baseName=""
		if #nameWithoutSymbols==0 then
			baseName=instance.ClassName
		elseif string.find(string.sub(nameWithoutSymbols,1,1),"%d") then
			baseName="_"..nameWithoutSymbols
		else
			baseName=nameWithoutSymbols
		end

		-- Check for original name
		local isOriginal=true
		for i,v in pairs(variables) do if v==baseName then isOriginal=false break end end
		if isOriginal then variables[instance]=baseName return end

		-- Check for duplicate name
		local count=1
		local isDuplicate=false
		while true do
			isDuplicate=false
			local mainBaseName=baseName.."_"..tostring(count)
			for i,v in pairs(variables) do if v==mainBaseName then isDuplicate=true break end end
			count=count+1
			if not isDuplicate then variables[instance]=mainBaseName return end
			task.wait()
		end
	end

	function Util.GetVisualInstance(instance)
		local newInstance=instance:Clone() 
		newInstance=Util.MakeShortInstance(newInstance) 
		task.delay(2,function() 
			newInstance:Destroy() 
			newInstance=nil 
		end) 
		return newInstance
	end

	function Util.CopyInstanceWith(t,parent,match,valueClasses)
		for j,k in ipairs(t) do 
			for i,v in ipairs(k:GetDescendants()) do 
				if match(v) then 
					RunService.Stepped:Wait() 
					local nv=Util.CopyInstance(v.ClassName,v,valueClasses[v.ClassName]) 
					nv.Parent=parent 
				end 
			end 
		end
	end
end

local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer.PlayerGui or LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts=LocalPlayer.PlayerScripts
local Mouse=LocalPlayer:GetMouse()
local SaveMouseIcon=Mouse.Icon

local UI=require(game.ReplicatedStorage.Shared.PaazlisUI)

local Window=UI:CreateWindow()


Window:SetTitle("Download")

-- UI
local Status,Loader,ContinueButton,MainButton,MainToggle,ResetButton,DestroyButton,TextBox,SelectorButton,AddButton,InitializeButton,InstalButton

local Outliner=Instance.new("SelectionBox")
Outliner.Name="Selection"
Outliner.Color3=Color3.fromRGB(25,153,255)
Outliner.LineThickness=0.1
Outliner.SurfaceColor3=Color3.fromRGB(255,255,255)
Outliner.SurfaceTransparency=1
Outliner.Transparency=0
Outliner.Adornee=nil
Outliner.Visible=false
Outliner.Parent=UI.Gui

local MainButton;

local CONSTRAINT_PROPERTY=[[
Attachment
	bool Archivable
	string Name
	Object Parent
	bool Visible
	Vector3 Position
	Vector3 Orientation
SpringConstraint
	bool Archivable
	string Name
	Object Parent
	number Coils
	BrickColor Color
	number Radius
	number Thickness
	bool Visible
	bool Enabled
	Object Attachment0
	Object Attachment1
	number Damping
	number FreeLength
	bool LimitsEnabled
	number MaxLength
	number MaxLength
	number MaxForce
	number Stiffness
Weld
	bool Archivable
	string Name
	Object Parent
	CFrame C0
	CFrame C1
	Object Part0
	Object Part1
	bool Enabled
WeldConstraint
	bool Archivable
	string Name
	Object Parent
	Object Part0
	Object Part1
	bool Enabled
]]

local GUI_PROPERTY=[[
ScreenGui
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ LayerCollector ]
	bool Enabled
	ZIndexBehavior ZIndexBehavior
-	[ ScreenGui ]
	int DisplayOrder
	bool ResetOnSpawn
BillboardGui
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ LayerCollector ]
	bool Enabled
	ZIndexBehavior ZIndexBehavior
-	[ BillboardGui ]
	bool Active
	Object Adornee
	bool AlwaysOnTop
	Vector3 ExtentsOffset
	Vector3 ExtentsOffsetWorldSpace
	float LightInfluence
	float MaxDistance
	Object PlayerToHideFrom
	UDim2 Size
	Vector2 SizeOffset
	Vector3 StudsOffset
	Vector3 StudsOffsetWorldSpace
Frame
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ Frame ]
	FrameStyle Style
ImageButton
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ GuiButton ]
	bool AutoButtonColor
	bool Modal
	bool Selected
	ButtonStyle Style
-	[ ImageButton ]
	Content Image
	Color3 ImageColor3
	Vector2 ImageRectOffset
	Vector2 ImageRectSize
	float ImageTransparency
	ScaleType ScaleType
	Rect2D SliceCenter
	float SliceScale
	UDim2 TileSize
ImageLabel
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ ImageLabel ]
	Content Image
	Color3 ImageColor3
	Vector2 ImageRectOffset
	Vector2 ImageRectSize
	float ImageTransparency
	ScaleType ScaleType
	Rect2D SliceCenter
	float SliceScale
	UDim2 TileSize
ScrollingFrame
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ ScrollingFrame ]
	Content BottomImage
	Vector2 CanvasPosition
	UDim2 CanvasSize
	ScrollBarInset HorizontalScrollBarInset
	Content MidImage
	int ScrollBarThickness
	bool ScrollingEnabled
	Content TopImage
	ScrollBarInset VerticalScrollBarInset
	VerticalScrollBarPosition VerticalScrollBarPosition
SurfaceGui
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ LayerCollector ]
	bool Enabled
	ZIndexBehavior ZIndexBehavior
-	[ SurfaceGui ]
	bool Active
	Object Adornee
	bool AlwaysOnTop
	Vector2 CanvasSize
	NormalId Face
	float LightInfluence
	float ToolPunchThroughDistance
	float ZOffset
TextBox
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ TextBox ]
	bool ClearTextOnFocus
	Font Font
	float LineHeight
	bool MultiLine
	Color3 PlaceholderColor3
	string PlaceholderText
	bool ShowNativeInput
	string Text
	Color3 TextColor3
	bool TextScaled
	float TextSize
	Color3 TextStrokeColor3
	float TextStrokeTransparency
	float TextTransparency
	bool TextWrapped
	TextXAlignment TextXAlignment
	TextYAlignment TextYAlignment
TextButton
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ GuiButton ]
	bool AutoButtonColor
	bool Modal
	bool Selected
	ButtonStyle Style
-	[ TextButton ]
	Font Font
	float LineHeight
	string Text
	Color3 TextColor3
	bool TextScaled
	float TextSize
	Color3 TextStrokeColor3
	float TextStrokeTransparency
	float TextTransparency
	bool TextWrapped
	TextXAlignment TextXAlignment
	TextYAlignment TextYAlignment
TextLabel
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ GuiObject ]
	bool Active
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	float BackgroundTransparency
	Color3 BorderColor3
	int BorderSizePixel
	bool ClipsDescendants
	bool Draggable
	int LayoutOrder
	Object NextSelectionDown
	Object NextSelectionLeft
	Object NextSelectionRight
	Object NextSelectionUp
	UDim2 Position
	float Rotation
	bool Selectable
	Object SelectionImageObject
	UDim2 Size
	SizeConstraint SizeConstraint
	bool Visible
	int ZIndex
-	[ TextLabel ]
	Font Font
	float LineHeight
	string Text
	Color3 TextColor3
	bool TextScaled
	float TextSize
	Color3 TextStrokeColor3
	float TextStrokeTransparency
	float TextTransparency
	bool TextWrapped
	TextXAlignment TextXAlignment
	TextYAlignment TextYAlignment
UIAspectRatioConstraint
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIAspectRatioConstraint ]
	float AspectRatio
	AspectType AspectType
	DominantAxis DominantAxis
UIGridLayout
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIGridStyleLayout ]
	FillDirection FillDirection
	HorizontalAlignment HorizontalAlignment
	SortOrder SortOrder
	VerticalAlignment VerticalAlignment
-	[ UIGridLayout ]
	UDim2 CellPadding
	UDim2 CellSize
	int FillDirectionMaxCells
	StartCorner StartCorner
UIListLayout
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIGridStyleLayout ]
	FillDirection FillDirection
	HorizontalAlignment HorizontalAlignment
	SortOrder SortOrder
	VerticalAlignment VerticalAlignment
-	[ UIListLayout ]
	UDim Padding
UIPadding
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIPadding ]
	UDim PaddingBottom
	UDim PaddingLeft
	UDim PaddingRight
	UDim PaddingTop
UIPageLayout
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIGridStyleLayout ]
	FillDirection FillDirection
	HorizontalAlignment HorizontalAlignment
	SortOrder SortOrder
	VerticalAlignment VerticalAlignment
-	[ UIPageLayout ]
	bool Animated
	bool Circular
	EasingDirection EasingDirection
	EasingStyle EasingStyle
	bool GamepadInputEnabled
	UDim Padding
	bool ScrollWheelInputEnabled
	bool TouchInputEnabled
	float TweenTime
UIScale
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIScale ]
	float Scale
UISizeConstraint
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UISizeConstraint ]
	Vector2 MaxSize
	Vector2 MinSize
UITableLayout
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UIGridStyleLayout ]
	FillDirection FillDirection
	HorizontalAlignment HorizontalAlignment
	SortOrder SortOrder
	VerticalAlignment VerticalAlignment
-	[ UITableLayout ]
	bool FillEmptySpaceColumns
	bool FillEmptySpaceRows
	TableMajorAxis MajorAxis
	UDim2 Padding
UITextSizeConstraint
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ UITextSizeConstraint ]
	int MaxTextSize
	int MinTextSize
Configuration
	bool Archivable
	string Name
	Object Parent
ViewportFrame
	Color3 Ambient
	Color3 LightColor
	Vector3 LightDirection
	Object SelectionImageObject
	float BackgroundTransparency
	Vector2 AnchorPoint
	Color3 BackgroundColor3
	int BorderSizePixel
	Color3 BorderColor3
	Object CurrentCamera
	int LayoutOrder
	string Name
	Object Parent
	UDim2 Position
	int Rotation
	bool Visible
	int ZIndex
	bool ClipsDescendants
	Color3 ImageColor3
	float ImageTransparency
UIGradient
	ColorSequence Color
	Vector2 Offset
	int Rotation
	NumberSequence Transparency
	string Name
	Object Parent
	bool Archivable
UICorner
	UDim CornerRadius
	string Name
	Object Parent
	bool Archivable
UIStroke
	ApplyStrokeMode ApplyStrokeMode
	Color3 Color
	LineJoinMode LineJoinMode
	number Thickness
	number Transparency
	bool Enabled
	string Name
	Object Parent
	bool Archivable
]]

local BUILDING_PROPERTY=[[
SpecialMesh
	bool Archivable
	string Name
	Object Parent
	string MeshId
	MeshType MeshType
	string TextureId
	Vector3 Scale
	Vector3 Offset
	Color3 VertexColor
WedgePart
	bool Archivable
	string Name
	Object Parent
	BrickColor BrickColor
	Color3 Color
	Material Material
	number Reflectance
	number Transparency
	Vector3 Size
	Vector3 Position
	Vector3 Rotation
	bool CanCollide
	bool Anchored
	PhysicalProperties CustomPhysicalProperties
CornerWedgePart
	bool Archivable
	string Name
	Object Parent
	BrickColor BrickColor
	Color3 Color
	Material Material
	number Reflectance
	number Transparency
	Vector3 Size
	Vector3 Position
	Vector3 Rotation
	bool CanCollide
	bool Anchored
	PhysicalProperties CustomPhysicalProperties
TrussPart
	bool Archivable
	string Name
	Object Parent
	BrickColor BrickColor
	Color3 Color
	Material Material
	number Reflectance
	number Transparency
	Vector3 Size
	Vector3 Position
	Vector3 Rotation
	bool CanCollide
	bool Anchored
	PhysicalProperties CustomPhysicalProperties
	Style Style
Part
	bool Archivable
	string Name
	Object Parent
	Color3 Color
	Material Material
	number Reflectance
	number Transparency
	Vector3 Size
	Vector3 Position
	Vector3 Rotation
	bool CanCollide
	bool Anchored
	PhysicalProperties CustomPhysicalProperties
	PartType Shape
]]

local REFERENCE_PROPERTY=[[
Tool
	bool Archivable
	string Name
	Object Parent
	string ToolTip
	string TextureId
	Object PrimaryPart
	bool CanBeDropped
	bool ManualActivationOnly
	bool RequiresHandle
	bool Enabled
Beam
	bool Archivable
	string Name
	Object Parent
	ColorSequence Color
	bool Enabled
	number LightEmission
	number LightInfluence
	string Texture
	number TextureLength
	TextureMode TextureMode
	number TextureSpeed
	NumberSequence Transparency
	number ZOffset
	number CurveSize0
	number CurveSize1
	bool FaceCamera
	number Segments
	number Width0
	number Width1
Trail
	bool Archivable
	string Name
	Object Parent
	ColorSequence Color
	bool FaceCamera
	number LightEmission
	number LightInfluence
	string Texture
	number TextureLength
	TextureMode TextureMode
	NumberSequence Transparency
	bool Enabled
	number Lifetime
	number MaxLength
	number MinLength
	number WidthScale
Team
	bool Archivable
	string Name
	Object Parent
	BrickColor TeamColor
BindableEvent
	bool Archivable
	string Name
	Object Parent
BindableFunction
	bool Archivable
	string Name
	Object Parent
RemoteEvent
	bool Archivable
	string Name
	Object Parent
UnreliableRemoteEvent
	bool Archivable
	string Name
	Object Parent
RemoteFunction
	bool Archivable
	string Name
	Object Parent
Configuration
	bool Archivable
	string Name
	Object Parent
Folder
	bool Archivable
	string Name
	Object Parent
Model
	bool Archivable
	string Name
	Object Parent
	Object PrimaryPart
BoolValue
	bool Archivable
	string Name
	Object Parent
	bool Value
StringValue
	bool Archivable
	string Name
	Object Parent
	string Value
NumberValue
	bool Archivable
	string Name
	Object Parent
	number Value
FloatValue
	bool Archivable
	string Name
	Object Parent
	float Value
IntValue
	bool Archivable
	string Name
	Object Parent
	int Value
ObjectValue
	bool Archivable
	string Name
	Object Parent
	Object Value
Vector2Value
	bool Archivable
	string Name
	Object Parent
	Vector2 Value
Vector3Value
	bool Archivable
	string Name
	Object Parent
	Vector3 Value
Vector4Value
	bool Archivable
	string Name
	Object Parent
	Vector4 Value
CFrameValue
	bool Archivable
	string Name
	Object Parent
	CFrame Value
Color3Value
	bool Archivable
	string Name
	Object Parent
	Color3 Value
BrickColorValue
	bool Archivable
	string Name
	Object Parent
	BrickColor Value
Texture
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ Texture ]
	Color3 Color3
	number OffsetStudsU
	number OffsetStudsV
	number StudsPerTileU
	number StudsPerTileV
	string Texture
	number Transparency
	number ZIndex
	NormalId Face
Decal
-	[ Instance ]
	bool Archivable
	string Name
	Object Parent
-	[ Decal ]
	NormalId Face
	Color3 Color3
	string Texture
Sound
	bool Archivable
	string Name
	Object Parent
	string SoundId
	bool Looped
	bool Playing
	number Volume
	number RollOffMaxDistance
	number RollOffMinDistance
	RollOffMode RollOffMode
	bool PlaybackRegionsEnabled
	number PlaybackSpeed
	number TimePosition
Sky
	bool Archivable
	string Name
	Object Parent
	bool CelestialBodiesShown
	number MoonAngularSize
	string MoonTextureId
	string SkyboxBk
	string SkyboxDn
	string SkyboxFt
	string SkyboxLf
	string SkyboxRt
	string SkyboxUp
	number StarCount
	number SunAngularSize
	string SunTextureId
ColorCorrectionEffect
	bool Archivable
	string Name
	Object Parent
	bool Enabled
	number Brightness
	number Contrast
	number Saturation
	Color3 TintColor
BlurEffect
	bool Archivable
	string Name
	Object Parent
	bool Enabled
	number Size
SunRaysEffect
	bool Archivable
	string Name
	Object Parent
	bool Enabled
	number Intensity
	number Spread
DepthOfFieldEffect
	bool Archivable
	string Name
	Object Parent
	bool Enabled
	number FarIntensity
	number FocusDistance
	number InFocusRadius
	number NearIntensity
BloomEffect
	bool Archivable
	string Name
	Object Parent
	bool Enabled
	number Intensity
	number Size
	number Threshold
Atmosphere
	bool Archivable
	string Name
	Object Parent
	number Density
	number Offset
	Color3 Color
	Color3 Decay
	number Glare
]] .. BUILDING_PROPERTY .. GUI_PROPERTY .. CONSTRAINT_PROPERTY

local SafeData={}
do
	-- Normal --
	SafeData["bool"]=function(value) return tostring(value) end
	SafeData["boolean"]=SafeData["bool"]
	SafeData["float"]=function(value) return ("%.3f"):format(value) end
	SafeData["int"]=SafeData["bool"]
	SafeData["number"]=SafeData["bool"]
	SafeData["string"]=function(value) return "\'"..value:gsub("[\"\\]","\\%1"):gsub("\n","\\\\n").."\'" end
	-- Enum --
	SafeData["EnumItem"]=function(value,name) return "DATA_ERROR" end
	SafeData["TextureMode"]=SafeData["bool"]
	SafeData["LineJoinMode"]=SafeData["bool"]
	SafeData["ApplyStrokeMode"]=SafeData["bool"]
	SafeData["Style"]=SafeData["bool"]
	SafeData["MeshType"]=SafeData["bool"]
	SafeData["Material"]=SafeData["bool"]
	SafeData["PartType"]=SafeData["bool"]
	SafeData["RollOffMode"]=SafeData["bool"]
	SafeData["AspectType"]=SafeData["bool"]
	SafeData["ButtonStyle"]=SafeData["bool"]
	SafeData["Content"]=SafeData["string"]
	SafeData["DominantAxis"]=SafeData["bool"]
	SafeData["EasingDirection"]=SafeData["bool"]
	SafeData["EasingStyle"]=SafeData["bool"]
	SafeData["FillDirection"]=SafeData["bool"]
	SafeData["Font"]=SafeData["bool"]
	SafeData["FrameStyle"]=SafeData["bool"]
	SafeData["HorizontalAlignment"]=SafeData["bool"]
	SafeData["NormalId"]=SafeData["bool"]
	SafeData["ScaleType"]=SafeData["bool"]
	SafeData["ScrollBarInset"]=SafeData["bool"]
	SafeData["SizeConstraint"]=SafeData["bool"]
	SafeData["SortOrder"]=SafeData["bool"]
	SafeData["StartCorner"]=SafeData["bool"]
	SafeData["TableMajorAxis"]=SafeData["bool"]
	SafeData["TextXAlignment"]=SafeData["bool"]
	SafeData["TextYAlignment"]=SafeData["bool"]
	SafeData["VerticalAlignment"]=SafeData["bool"]
	SafeData["VerticalScrollBarPosition"]=SafeData["bool"]
	SafeData["ZIndexBehavior"]=SafeData["bool"]
	SafeData["InlineAlignment"]=SafeData["bool"]
	-- Object --
	SafeData["Object"]=function(value)
		local hierarchy=""
		local previousObjectUsedBrackets=true

		for object in Util.GetAncestorsAndSelf(value) do
			local safeName=""
			local shouldUseBrackets=false
			local currentHierarchy=""

			if #object.Name==0 then
				shouldUseBrackets=true
			else
				if object.Name:match("[%a_ ]+")~=object.Name then
					shouldUseBrackets=true
				end
			end

			if shouldUseBrackets then
				safeName=object.Name:gsub("[\"\\]","\\%1"):gsub("\n","\\\\n")
			end

			if object==game and previousObjectUsedBrackets then
				hierarchy="game"..hierarchy
				break
			elseif object==game and not previousObjectUsedBrackets then
				if hierarchy=="StarterGui" then
					currentHierarchy="game.StarterGui"
				elseif hierarchy=="PlayerGui" then
					currentHierarchy="game.StarterGui"
				elseif hierarchy=="workspace" then
					currentHierarchy="workspace"
				else
					currentHierarchy=hierarchy
				end
				hierarchy=currentHierarchy
				break
			elseif shouldUseBrackets and previousObjectUsedBrackets then
				previousObjectUsedBrackets=true
				hierarchy="[\""..safeName.."\"]"..hierarchy
			elseif shouldUseBrackets and not previousObjectUsedBrackets then
				previousObjectUsedBrackets=true
				hierarchy="[\""..safeName.."\"]".."."..hierarchy
			elseif (not shouldUseBrackets) and previousObjectUsedBrackets then
				previousObjectUsedBrackets=false
				hierarchy=object.Name..hierarchy
			elseif (not shouldUseBrackets) and (not previousObjectUsedBrackets) then
				previousObjectUsedBrackets=false
				if object==StarterGui or hierarchy=="StarterGui" then
					currentHierarchy="game.StarterGui"
				elseif object==game.Players.LocalPlayer.PlayerGui or hierarchy=="PlayerGui" then
					currentHierarchy="game.StarterGui"
				elseif object==workspace or hierarchy=="workspace" then
					currentHierarchy="workspace"
				else
					currentHierarchy=object.Name.."."..hierarchy
				end
				hierarchy=currentHierarchy
			end
		end

		return hierarchy
	end
	-- UserData --
	SafeData['PhysicalProperties']=function(value)
		return ("PhysicalProperties.new(%.3f,%.3f,%.3f,%.3f,%.3f)"):format(value.Density,value.Friction,value.Elasticity,value.FrictionWeight,value.ElasticityWeight);
	end
	SafeData["Rect2D"]=function(value)
		return "Rect.new("..tostring(value):gsub("\n",""):gsub(" ","")..")"
	end
	SafeData["BrickColor"]=function(value)
		return ("BrickColor.new(%d,%d,%d)"):format(value.r*255,value.g*255,value.b*255);
	end
	SafeData["Color3"]=function(value)
		return ("Color3.fromRGB(%d,%d,%d)"):format(value.R*255,value.G*255,value.B*255);
	end
	SafeData["UDim"]=function(value)
		return "UDim.new("..tostring(value):gsub("\n",""):gsub(" ","")..")"
	end
	SafeData["UDim2"]=function(value)
		return "UDim2.new("..tostring(value.X):gsub("\n",""):gsub(" ","")..","..tostring(value.Y):gsub("\n",""):gsub(" ","")..")"
	end
	SafeData["Vector2"]=function(value)
		return ("Vector2.new(%.3f,%.3f)"):format(value.X,value.Y)
	end
	SafeData["Vector3"]=function(value)
		return ("Vector3.new(%.3f,%.3f,%.3f)"):format(value.X,value.Y,value.Z)
	end
	SafeData["Vector4"]=function(value)
		return ("Vector4.new(%.3f,%.3f,%.3f,%.3f)"):format(value.X,value.Y,value.Z,value.W or value.A);
	end
	SafeData["CFrame"]=function(value)
		return "CFrame.new("..tostring(value):gsub("\n",""):gsub(" ","")..")"
	end
	-- Sequence --
	SafeData["ColorSequenceKeypoint"]=function(value:ColorSequenceKeypoint)
		return ("ColorSequenceKeypoint.new(%.2f,%s)"):format(value.Time,SafeData["Color3"](value.Value));
	end
	SafeData["NumberSequenceKeypoint"]=function(value)
		return ("NumberSequenceKeypoint.new(%.2f,%.2f)"):format(value.Time,value.Value)
	end
	SafeData["FloatSequenceKeypoint"]=function(value)
		return ("FloatSequenceKeypoint.new(%.2f,%.2f)"):format(value.Time,value.Value)
	end
	SafeData["ColorSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  table.insert(t,SafeData["ColorSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("ColorSequence.new({%s})"):format(s)
	end
	SafeData["NumberSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  table.insert(t,SafeData["NumberSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("NumberSequence.new({%s})"):format(s);
	end
	SafeData["FloatSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  table.insert(t,SafeData["FloatSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("FloatSequence.new({%s})"):format(s);
	end
end


local RegisteredClasses={}
local ObjectClasses={}
local RegisteredGUIClasses={}
local GUIClasses={}

local GrabTypeList={"None","Building","Gui","Lighting","Sound","Tool","Icon","Team","Event","Texture","Decal","Beam","Trail","GuiIcon","Name","GuiColor","PartColor","MouseIcon","GiveWalkSpeed","GiveJump"}
local BannedGrabTypeList={"None","DestroyThis","GiveWalkSpeed","GiveJump","Continue"}
local GrabTypeData={}
local BuildingData={}
local GuiData={}
local ToolData={}
local MouseIconData={}
local ScrollConnections={}

local GrabType=GrabTypeList[1]
local InstalTarget=nil
local BuildingTarget=nil
local GuiTarget=nil
local ToolTarget=nil

local CanContinue=false
local Debounce=false
local IsInput=false
local PlayerGuiAdded

local CurrentChooseIndex=1
local MaxBuildingIndex=0
local BuildingIndex=0

local GrabberModel

-- Create Object Class --
local function CreateClasses(property)
	local currentClass,templateObject,classList,registeredList=nil,nil,{},{}
	for line in Util.GetLines(property) do
		if string.sub(line,1,1)~="-" then
			local continue=false

			if string.sub(line,1,1)=="	" then
				if templateObject then
					local space=string.find(line," ")
					if not tonumber(space) then return end

					local datatype=string.sub(line,2,space-1)
					local property=string.sub(line,space+1,#line)

					if SafeData[datatype]==nil then
						warn("Minimalist Object Grabber: ","Unhandled data type \""..datatype.."\" "..currentClass.."."..property.." will be ignored.")
						continue=true
					end

					if not pcall(function() return templateObject[property] end) then
						warn("Minimalist Object Grabber: ","Unknown property "..currentClass.."."..property.." will be ignored.")
						continue=true
					end
					--
					if not continue then
						classList[currentClass][property]={
							DataType=datatype,
							DefaultValue=templateObject[property]
						}
						table.insert(classList[currentClass],property)
					end
				end
			else
				if templateObject then templateObject:Destroy() templateObject=nil end
				currentClass=nil

				if not pcall(function() Instance.new(line):Destroy() end) then
					warn("Minimalist Object Grabber: ","Unknown class \""..line.."\" will be ignored.")
					continue=true
				end

				if not continue then
					currentClass=line
					table.insert(registeredList,line)
					templateObject=Instance.new(currentClass)
					classList[currentClass]={}
				end
			end
		end
	end
	if templateObject then
		templateObject:Destroy()
		templateObject=nil
	end
	currentClass=nil
	return classList,registeredList
end

do
	ObjectClasses,RegisteredClasses=CreateClasses(REFERENCE_PROPERTY)
	GUIClasses,RegisteredGUIClasses=CreateClasses(GUI_PROPERTY)
	REFERENCE_PROPERTY=nil
	GUI_PROPERTY=nil
end

--local function UpdateScrollFrameGui(v)
--	local length=#v:GetDescendants()+1
--	if GrabType=="Gui" then
--		if v.Name==Gui.Name then return end
--		local cloneButton=TemplateButton:Clone()
--		cloneButton.Visible=true
--		cloneButton.Name=v.Name
--		cloneButton.Text=table.find(GuiData,v) and v.Name.." "..tostring(length).." Object".." (Insert)" or v.Name.." "..tostring(length).." Object"
--		cloneButton.Parent=ScrollingFrame
--		ScrollConnections[v]=cloneButton.MouseButton1Click:Connect(function()
--			GuiTarget=v
--			if not table.find(GrabTypeData,GrabType) then table.insert(GrabTypeData,GrabType) end
--			if not table.find(GuiData,GuiTarget) then table.insert(GuiData,GuiTarget) else table.remove(GuiData,table.find(GuiData,GuiTarget)) warn("Guiremoved") GuiTarget=nil end
--			if not next(GuiData) then table.remove(GrabTypeData,table.find(GrabTypeData,GrabType)) end
--			cloneButton.Text=table.find(GuiData,v) and v.Name.." "..tostring(length).." Object".." (Insert)" or v.Name.." "..tostring(length).." Object"
--		end)
--	end
--end

local function SetStatus(mode,...)
	if mode==1 then
		local message,duration,saveText=...
		if type(message)~="string" then return end
		Status.Text=message
		task.wait(tonumber(duration) or 2)
		if saveText then Status.Text=saveText else Status.Text="Status" end
	elseif mode==2 then
		local current,max=...
		if current==-1 then
			--BarFrame.Size=UDim2.new(1,0,1,0)
			Loader.Text="("..max.."/"..max..") 100%"
		elseif current==-2 then
			--BarFrame.Size=UDim2.new(0,0,1,0)
			Loader.Text="(0/0) 0%"
		else
			local percentage=(1/max)*current
			if current==0 or max==0 then percentage=1 end
			if percentage>=1 then
				if current==0 and max==0 then percentage=0 else percentage=100 end
				--BarFrame.Size=UDim2.new(1,0,1,0)
				Loader.Text="("..max.."/"..max..") "..tostring(percentage).."%"	
			else
				--BarFrame.Size=UDim2.new(percentage,0,1,0)
				Loader.Text="("..current.."/"..max..") "..string.format("%.2f",percentage*100).."%"	
			end
		end
	end
end

local function SetUpdate(mode,...)
	if mode==1 then
		GrabTypeData={}
		GrabType=GrabTypeList[1]
		CurrentChooseIndex=1
		BuildingData={}
		BuildingTarget=nil
		InstalTarget=nil
		GuiData={}
		GuiTarget=nil
		ToolData={}
		ToolTarget=nil
		MouseIconData={}
		if SelectorButton and SelectorButton.Parent then
			SelectorButton.Value=GrabTypeList[1]
		end
		if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
		if Window.Parent then
			Status.Text="Status"
			Loader.Text="(0/0) 0%"
		end
		SetUpdate(2)
		SetUpdate(3)
	elseif mode==2 then
		local target=...
		if Outliner.Parent then
			Outliner.Adornee=target
			Outliner.Visible=target~=nil
			Outliner.Parent=target~=nil and workspace or UI.Gui
		end
	elseif mode==3 then
		if Status and Status.Parent and not Debounce then
			Status.Text="Status"
		end

		if GrabType~="Building" then SetUpdate(2) end

		if PlayerGuiAdded then
			PlayerGuiAdded:Disconnect() 
			PlayerGuiAdded=nil
		end

		if TextBox and TextBox.Parent then
			local visible=(GrabType=="Building" or GrabType=="GiveWalkSpeed" or GrabType=="GiveJump")
			TextBox.Template.Visible=visible

			if GrabType=="Building" then
				TextBox.PlaceholderText="Building Index"
			elseif GrabType=="GiveWalkSpeed" then
				TextBox.PlaceholderText="WalkSpeed"
			elseif GrabType=="GiveJump" then
				TextBox.PlaceholderText="JumpHeight"
			else
				TextBox.Text=""
			end
		end

		if MainLabel and MainLabel.Parent then
			if GrabType=="Building" then
				MainLabel.Text="Max Building Index: " .. tostring(MaxBuildingIndex)
			elseif GrabType=="Gui" then
				local originText=`Use dex/explorer and Add StringValue and named "InstalGui" in PlayerGui`
				MainLabel.Text=originText

				PlayerGuiAdded=PlayerGui.DescendantAdded:Connect(function(child:Instance)
					if child:IsA("StringValue") and child.Name=="InstalGui" then
						local success=false

						local value=child.Parent
						if value then 
							success=true
							if value:IsA("ScreenGui") then
								GuiTarget=value
							elseif value.Parent==PlayerGui then
								for i,v in ipairs(PlayerGui:GetChildren()) do
									if v:IsA("ScreenGui") and not table.find(GuiData,v) then
										table.insert(GuiData,v)
									end
								end
							else
								success=false
							end
						end

						local nextText=""

						if not success then
							local s=if value then `"{value.ClassName}", "{value.Name}"` else "nil"
							nextText=`Failed to added gui (ScreenGui or PlayerGui expected, got {s})`
						else
							nextText="Successfully"
						end

						if MainLabel and MainLabel.Parent then
							MainLabel.Text=nextText
							task.wait(2)
							if MainLabel and MainLabel.Parent and MainLabel.Text==nextText then
								MainLabel.Text=originText
							end
						end
					end
				end)
			else
				MainLabel.Text=""
			end

			MainLabel.TextScaled=GrabType=="Gui"
			MainLabel.Template.Visible=GrabType=="Building" or GrabType=="Gui"
		end
	end
end

local function GetGrabData(mode)
	warn("GetGrabData",mode)
	mode=tostring(mode)
	Status.Text=mode
	task.wait(2)
	local newModel=Instance.new("Model") newModel.Name=mode
	local newStringValue=Instance.new("StringValue")
	local s=""
	local sCount=0
	local needle=nil
	local list,explorers,needles={},{},{}
	if mode=="Event" then
		Util.CopyInstanceWith({Workspace,ReplicatedStorage,ReplicatedFirst},newModel,function(v) if Util.IsAs(v,{"RemoteEvent","RemoteFunction","BindableEvent","BindableFunction","UnreliableRemoteEvent"}) then needle=v.Name.."_"..v.ClassName if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Sound" then
		explorers={Workspace,ReplicatedStorage,SoundService,LocalPlayer}
		Util.CopyInstanceWith(explorers,newModel,function(v) if v:IsA("Sound") then needle=tostring(v.SoundId) if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
		if #newModel:GetDescendants()>=215 then Status.Text=mode newModel:ClearAllChildren() task.wait(2) newStringValue.Name=mode.."___SCRIPTING" for j,k in ipairs(explorers) do for i,v in ipairs(k:GetDescendants()) do if v:IsA("Sound") then needle=tostring(v.SoundId) if not table.find(list,needle) then table.insert(list,needle) RunService.Stepped:Wait() Status.Text=mode..": "..needle s=s..needle..";" sCount=sCount+1 if sCount>=60 then sCount=0 s=s.."\n" end end end end end end
	elseif mode=="Lighting" then
		local newLighting=Instance.new("Model")
		newLighting.Name="Lighting"
		newLighting.Parent=newModel

		local newAmbient=Instance.new("Color3Value")
		newAmbient.Name="Ambient"
		newAmbient.Value=Lighting.Ambient
		newAmbient.Parent=newLighting

		local newBrightness=Instance.new("NumberValue")
		newBrightness.Name="Brightness"
		newBrightness.Value=Lighting.Brightness
		newBrightness.Parent=newLighting

		local newColorShift_Bottom=Instance.new("Color3Value")
		newColorShift_Bottom.Name="ColorShift_Bottom"
		newColorShift_Bottom.Value=Lighting.ColorShift_Bottom
		newColorShift_Bottom.Parent=newLighting

		local newColorShift_Top=Instance.new("Color3Value")
		newColorShift_Top.Name="ColorShift_Top"
		newColorShift_Top.Value=Lighting.ColorShift_Top
		newColorShift_Top.Parent=newLighting

		local newEnvironmentDiffuseScale=Instance.new("NumberValue")
		newEnvironmentDiffuseScale.Name="EnvironmentDiffuseScale"
		newEnvironmentDiffuseScale.Value=Lighting.EnvironmentDiffuseScale
		newEnvironmentDiffuseScale.Parent=newLighting

		local newEnvironmentSpecularScale=Instance.new("NumberValue")
		newEnvironmentSpecularScale.Name="EnvironmentSpecularScale"
		newEnvironmentSpecularScale.Value=Lighting.EnvironmentSpecularScale
		newEnvironmentSpecularScale.Parent=newLighting

		local newGlobalShadows=Instance.new("BoolValue")
		newGlobalShadows.Name="GlobalShadows"
		newGlobalShadows.Value=Lighting.GlobalShadows
		newGlobalShadows.Parent=newLighting

		local newOutdoorAmbient=Instance.new("Color3Value")
		newOutdoorAmbient.Name="OutdoorAmbient"
		newOutdoorAmbient.Value=Lighting.OutdoorAmbient
		newOutdoorAmbient.Parent=newLighting

		local newShadowSoftness=Instance.new("NumberValue")
		newShadowSoftness.Name="ShadowSoftness"
		newShadowSoftness.Value=Lighting.ShadowSoftness
		newShadowSoftness.Parent=newLighting

		local newClockTime=Instance.new("NumberValue")
		newClockTime.Name="ClockTime"
		newClockTime.Value=Lighting.ClockTime
		newClockTime.Parent=newLighting

		local newGeographicLatitude=Instance.new("NumberValue")
		newGeographicLatitude.Name="GeographicLatitude"
		newGeographicLatitude.Value=Lighting.GeographicLatitude
		newGeographicLatitude.Parent=newLighting

		local newExposureCompensation=Instance.new("NumberValue")
		newExposureCompensation.Name="ExposureCompensation"
		newExposureCompensation.Value=Lighting.ExposureCompensation
		newExposureCompensation.Parent=newLighting

		Status.Text=mode..": "..newLighting.Name
		task.wait(2)

		Util.CopyInstanceWith({Lighting},newModel,function(v) if Util.IsAs(v,{"Sky","BloomEffect","ColorCorrectionEffect","SunRaysEffect","Atmosphere","BlurEffect"}) then Status.Text=mode..": "..v.Name return true end return false end,ObjectClasses)
	elseif mode=="Team" then
		Util.CopyInstanceWith({game.Teams},newModel,function(v) if v:IsA("Team") then needle=v.Name.."_"..tostring(v.TeamColor) if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Texture" then
		Util.CopyInstanceWith({Workspace,ReplicatedStorage},newModel,function(v) if v:IsA("Texture") then needle=v.Texture if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Decal" then
		Util.CopyInstanceWith({Workspace,ReplicatedStorage},newModel,function(v) if v:IsA("Decal") then needle=v.Texture if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Trail" then
		Util.CopyInstanceWith({Workspace,ReplicatedStorage},newModel,function(v) if v:IsA("Trail") then needle=v.Texture if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Beam" then
		Util.CopyInstanceWith({Workspace,ReplicatedStorage},newModel,function(v) if v:IsA("Beam") then needle=v.Texture if not table.find(list,needle) then table.insert(list,needle) Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="GuiColor" then
		newStringValue.Name="Gui___SCRIPTING".."Color___SCRIPTING" for j,k in ipairs({PlayerGui,ReplicatedStorage}) do for i,v in ipairs(k:GetDescendants()) do if Util.IsAs(v,{"ScreenGui","Frame","ImageLabel","TextLabel","ImageButton","TextButton","ScrollingFrame","TextBox"}) then Util.GetInstanceProperty(v,{"BackgroundColor3","ImageColor3","BorderColor3","Color","Color3","Value","BrickColor"},function(dataType,propertyValue) if dataType=="Color3" or dataType=="BrickColor" then needle=dataType.."_"..tostring(propertyValue) if table.find(list,needle) then return end table.insert(list,needle) RunService.Stepped:Wait() Status.Text=mode..": "..tostring(propertyValue) sCount=sCount+1 if dataType=="BrickColor" then s=s..tostring(propertyValue)..";" else s=s..SafeData["Color3"](propertyValue)..";" end if sCount>=60 then sCount=0 s=s.."\n" end end end) end end end
	elseif mode=="PartColor" then
		newStringValue.Name="Part___SCRIPTING".."Color___SCRIPTING" 
		for i,v in ipairs(Workspace:GetDescendants()) do 
			if v:IsA("BasePart") then 
				Util.GetInstanceProperty(v,{"BackgroundColor3","ImageColor3","BorderColor3","Color","Color3","Value","BrickColor"},function(dataType,propertyValue) 
					if dataType=="Color3" or dataType=="BrickColor" then needle=dataType.."_"..tostring(propertyValue) if table.find(list,needle) then return end table.insert(list,needle) RunService.Stepped:Wait() Status.Text=mode..": "..tostring(propertyValue) sCount=sCount+1 if dataType=="BrickColor" then s=s..tostring(propertyValue)..";" else s=s..SafeData["Color3"](propertyValue)..";" end if sCount>=60 then sCount=0 s=s.."\n" end end 
				end) 
			end 
		end
	elseif mode=="Name"  then
		newStringValue.Name=mode.."___SCRIPTING" 
		for j,k in ipairs({Workspace,ReplicatedStorage,Players,Teams,ReplicatedFirst,StarterPack}) do 
			for i,v in ipairs(k:GetDescendants()) do  
				Util.GetInstanceProperty(v,{"Name","Value","Message","Text","Print","DisplayName"},function(dataType,propertyValue,propertyName) 
					if dataType=="string" then local nameFilter="" for v in string.gmatch(propertyValue,"[%w]") do if not Util.IsStrings(v,{"1","2","3","4","5","6","7","8","9","0"}) then nameFilter=nameFilter..v end end if #nameFilter==0 then return end if v.ClassName==nameFilter then return end local newInstance=Instance.new(v.ClassName) if pcall(function() return newInstance[propertyName] end) and newInstance[propertyName]==nameFilter then newInstance:Destroy() return end newInstance:Destroy() if table.find(list,nameFilter) then return end table.insert(list,nameFilter) RunService.Stepped:Wait() Status.Text=mode..": "..nameFilter s=s..nameFilter..";" sCount=sCount+1 if sCount>=60 then sCount=0 s=s.."\n" end end 
				end) 
			end 
		end
	elseif mode=="MouseIcon" then
		if next(MouseIconData) then newStringValue.Name=mode.."___SCRIPTING" for i,v in ipairs(MouseIconData) do RunService.Stepped:Wait() task.wait(0.1) Status.Text=mode..": "..v s=s..v..";" sCount+=1 if sCount>=50 then sCount=0 s=s.."\n" end end end
	elseif mode=="Icon" then
		newStringValue.Name=mode.."___SCRIPTING" for j,k in ipairs({Workspace,ReplicatedStorage,PlayerGui,Teams,ReplicatedFirst}) do for i,v in ipairs(k:GetDescendants()) do Util.GetInstanceProperty(v,{"Texture","Icon","TextureId","Image","HoverImage"},function(dataType,propertyValue) if dataType=="string" then needle=propertyValue if table.find(list,needle) then return end table.insert(list,needle) RunService.Stepped:Wait() task.wait(0.1) Status.Text=mode..": "..needle sCount+=1 s=s..needle..";" if sCount>=60 then sCount=0 s=s.."\n" end end end) end end
	elseif mode=="GuiIcon" then
		newStringValue.Name="Gui___SCRIPTING".."Icon___SCRIPTING" for i,v in ipairs(PlayerGui:GetDescendants()) do Util.GetInstanceProperty(v,{"Texture","Icon","TextureId","Image","HoverImage"},function(dataType,propertyValue) if dataType=="string" then needle=propertyValue if table.find(list,needle) then return end table.insert(list,needle) RunService.Stepped:Wait() task.wait(0.1) Status.Text=mode..": "..needle sCount+=1 s=s..needle..";" if sCount>=60 then sCount=0 s=s.."\n" end end end) end
	elseif mode=="Tool" then
		if not next(ToolData) then  
			local descendants=ReplicatedStorage:GetDescendants()
			for i,v in ipairs(descendants) do 
				if v.ClassName=="Tool" then 
					Status.Text=mode
					table.insert(ToolData,v:Clone()) 
				else 

					Status.Text="Fail "..v.Name 
				end 
			end 
		end
		if next(ToolData) then for i,v in ipairs(ToolData) do if v and v.Parent==nil then RunService.Stepped:Wait() Status.Text=mode..": "..v.Name v.Parent=newModel end end end
		ToolTarget=nil
	elseif mode=="Gui" then
		if GuiTarget and not table.find(GuiData,GuiTarget) then table.insert(GuiData,GuiTarget) end GuiTarget=nil
		if next(GuiData) then for i,v in ipairs(GuiData) do RunService.Stepped:Wait() task.wait(0.1) local cv=v:Clone() if cv and cv.Parent==nil then Status.Text=mode..": "..cv.Name cv.Parent=newModel end end end
	elseif mode=="Building" then
		if BuildingTarget and not table.find(BuildingData,BuildingTarget) then table.insert(BuildingData,BuildingTarget) end BuildingTarget=nil
		if next(BuildingData) then for i,v in ipairs(BuildingData) do RunService.Stepped:Wait() task.wait(0.1) local cv=v:Clone() if cv and cv.Parent==nil then RunService.Stepped:Wait() Status.Text=mode..": "..cv.Name cv.Parent=newModel  end end end
	else
		return nil
	end
	if #s==0 then newStringValue:Destroy() newStringValue=nil else newStringValue.Parent=newModel newStringValue.Value=s end
	if not next(newModel:GetChildren()) then
		Status.Text=mode.." Has Empty"
		newModel:Destroy()
		newModel=nil
		task.wait(2)
	end
	s="" sCount=0 needle=nil list,explorers,needles={},{},{}
	return newModel
end

local function Initilized()
	warn("Initilized")
	--SetUpdate(2)

	if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end


	-- Insert instance by grab type
	local newModel=Instance.new("Model")
	newModel.Name="GrabberModel"

	local newGrabModel=nil
	if next(GrabTypeData) then
		for i,m in ipairs(GrabTypeData) do RunService.Stepped:Wait() newGrabModel=GetGrabData(m) if newGrabModel then newGrabModel.Parent=newModel end end
	elseif GrabType then
		newGrabModel=GetGrabData(GrabType)
		if newGrabModel then newGrabModel.Parent=newModel end
	end

	if newModel and next(newModel:GetChildren()) then
		local length=#newModel:GetDescendants()+1
		if length>=215 then Status.Text="Dangerous!" else Status.Text="Grab "..tostring(length).." Object" end
		task.wait(2)
		GrabberModel=newModel
		InstalTarget=newModel

		Status.Text="Successfully"
	else
		Status.Text="An Error Occured"
	end
end

local function Cleaning(instance,match,func)
	local children=instance:GetChildren() 
	for i=1,#children,1 do 
		local v=children[i] 
		if v then 
			RunService.Stepped:Wait() 
			func(v) 
			local actionMode=match(v) 
			if actionMode~="Continue" and actionMode==false then 
				for j,k in ipairs(v:GetChildren()) do 
					pcall(function() 
						k.Parent=v.Parent 
						return k 
					end) 
				end 
				local accept=0 
				repeat accept=accept+1 task.wait(1) until not next(v:GetChildren()) or accept>=60 or match(v)=="Continue" 
				v:Destroy() 
			end 
			if v.Parent and next(v:GetChildren()) then Cleaning(v,match,func) end 
		end 
	end
end

local function Starting(instance,func)
	warn("Starting",instance.Name)

	local selections={}
	local count,length=1,1

	for j,k in ipairs({instance:FindFirstChild("Building"),instance:FindFirstChild("Tool")}) do
		if k then
			selections=k:GetDescendants() length=#selections
			for i,v in ipairs(selections) do  
				if v:IsA("MeshPart") then 
					RunService.Stepped:Wait() 
					if CanContinue then CanContinue=false continue end 
					Util.ConvertMeshPartToSpecialMesh(v) 
				end 
				func(i,v,length) 
			end 
			selections=k:GetDescendants() length=#selections
			func(length,nil,length)
			task.wait(2)
		end
	end

	local guiModel=instance:FindFirstChild("Gui")
	if guiModel then
		selections=guiModel:GetDescendants() length=#selections
		warn("Cleaning")
		Cleaning(guiModel,function(v) if CanContinue then CanContinue=false return "Continue" end return Util.IsStrings(v.ClassName,RegisteredGUIClasses) end,function(v) count=count+1 func(count,v,length) end)
		selections=guiModel:GetDescendants() length=#selections
		func(length,nil,length)
		task.wait(2)
	end

	selections=instance:GetDescendants() length=#selections count=0
	warn("Cleaning")
	Cleaning(instance,function(v) if CanContinue then CanContinue=false return "Continue" end return Util.IsStrings(v.ClassName,RegisteredClasses) end,function(v) count=count+1 func(count,v,length) end)
	selections=instance:GetDescendants() length=#selections
	func(length,nil,length)
	task.wait(2)

	Util.MakeShortInstance(instance)
end

local function Creating(instance,func)
	warn("Creating",instance.Name)
	local selections,mainSelections,variables,objectives,advencedVariables,count={},{},{},{},{},0
	selections=instance:GetDescendants()
	for i,v in ipairs(selections) do
		RunService.Stepped:Wait()
		if Util.IsStrings(v.ClassName,RegisteredClasses) then 
			count=count+1
			Util.CreateVariable(v,variables)
			objectives[variables[v]]=v
			if #selections>=215 then v.Name="" end
			advencedVariables[v]=string.format("%s[\'%s\']","V",count)
			table.insert(mainSelections,v)
		end
		func(i,v,#selections)
	end
	func(#mainSelections,nil,#mainSelections) task.wait(2)
	return mainSelections,variables,objectives,advencedVariables
end

local function Process(selections,variables,objectives,targets,parentTarget,func)
	local isLimit=#selections>=215
	local text="local V={}"
	local textProperty=""
	local textInstance=""
	local isNextProperty=false
	local isInstance=true
	if not isLimit then text=text.."\n\n" end
	for i,v in ipairs(selections) do
		if v then
			RunService.Stepped:Wait()
			isNextProperty=false
			local variable,class=variables[v],v.ClassName
			isInstance=true
			if i~=1 then if not isLimit then textInstance=textInstance.."\n" end end
			if v:IsA("StringValue") and Util.IsStrings(v.Name,{"Sound___SCRIPTING","Image___SCRIPTING","Icon___SCRIPTING","Gui___SCRIPTINGIcon___SCRIPTING","Gui___SCRIPTINGColor___SCRIPTING","Part___SCRIPTINGColor___SCRIPTING","Name___SCRIPTING","MouseIcon___SCRIPTING"}) then
				if v.Name=="Image___SCRIPTING" then 
					variable="Image" 
				elseif v.Name=="Icon___SCRIPTING" then 
					variable="Icon" 
				elseif v.Name=="Gui___SCRIPTINGIcon___SCRIPTING" then 
					variable="GuiIcon" 
				elseif v.Name=="Gui___SCRIPTINGColor___SCRIPTING" then 
					variable="GuiColor" 
				elseif v.Name=="Part___SCRIPTINGColor___SCRIPTING" then 
					variable="PartColor" 
				elseif v.Name=="Name___SCRIPTING" then 
					variable="Name" 
				elseif v.Name=="Sound___SCRIPTING" then 
					variable="Sound" 
				elseif v.Name=="MouseIcon___SCRIPTING" then 
					variable="MouseIcon" 
				end
				textInstance=textInstance..string.format("local %s=[[\n%s\n]]",variable,v.Value)..";"
				isInstance=false
			end
			if isInstance then
				textInstance=textInstance..string.format("%s=Instance.new(\'%s\')",variable,class)..";"
				if i~=1 then if not isLimit then textProperty=textProperty.."\n" end end
				local needle,debounces=nil,{}
				for propertyName,property in Util.GetProperties(ObjectClasses[v.ClassName]) do
					local s,propertyValue=pcall(function() return v[propertyName] end)
					if not s or not propertyValue then continue end
					RunService.Stepped:Wait()
					if property.DefaultValue==propertyValue then continue end
					if property.DataType=="string" and #propertyValue==0 then continue end
					if isLimit then if (property.DataType=="CFrame" or property.DataType=="PhysicalProperties") then continue end end
					needle=property.DataType.."_"..propertyName 
					if debounces[needle] then continue end debounces[needle]=true
					isNextProperty=false
					if Util.IsStrings(property.DataType,{"number","float","int","short"}) then if tonumber(propertyValue) then isNextProperty=true if propertyValue>=math.huge then textProperty=textProperty..string.format("%s.%s=%s",variable,propertyName,"math.huge")..";" elseif propertyValue<=-math.huge then textProperty=textProperty..string.format("%s.%s=%s",variable,propertyName,"-math.huge")..";" else isNextProperty=false end end end
					if property.DataType=="Object" then if propertyName=="Parent" and v.Parent==parentTarget then isNextProperty=true textProperty=textProperty .. string.format("%s.%s=%s",variable,"Parent","workspace")..";" end end
					if not isNextProperty then
						if property.DataType=="Object" then
							if variables[propertyValue] then
								textProperty=textProperty .. string.format("%s.%s=%s",variable,propertyName,variables[propertyValue])..";"
							else
								warn("[InstalObject]: PROCESS FAILED: ","Object",v.Name,v.ClassName.."."..tostring(propertyName),tostring(objectives[targets[propertyValue]]))
								if not Util.IsSomethings({"Part","Attachment"},function(v) return string.find(propertyName,v) end) then
									textProperty=textProperty .. string.format("%s.%s=%s",variable,propertyName,"workspace")..";"
								end
							end
						else
							textProperty=textProperty .. string.format("%s.%s=%s",variable,propertyName,SafeData[property.DataType](propertyValue))..";"
						end
						isNextProperty=true
					end
					if not isLimit then textProperty=textProperty.."\n" end
				end
			end
			func(i,v,#selections)
		end
	end
	func(#selections,nil,#selections)
	task.wait(2)
	return text..textInstance..textProperty
end

local function Convert(instance)
	--if instance.Name~="GrabberModel" then return nil end
	CanContinue=false

	local cloneInstance=instance:Clone()
	local visualInstance=Util.GetVisualInstance(instance)
	local objectName=visualInstance.Name

	local newInstance=Instance.new("Model")
	newInstance.Name="InstalModel"
	cloneInstance.Parent=newInstance
	newInstance.Parent=workspace

	---- Initialize --
	--Status.Text="Starting For "..objectName
	--Starting(cloneInstance,function(i,v,length) SetStatus(2,i,length) end)
	--task.wait(2)

	--if #newInstance:GetDescendants()>=215 then
	--	SetStatus(1,"Dangerous!",2,Status.Text)
	--end

	-- Creating --
	Status.Text="Create For "..objectName
	local mainSelections,variables,objectives,advencedVariables=Creating(newInstance,function(i,v,length) SetStatus(2,i,length) end)
	task.wait(2)

	-- Process --
	Status.Text="Process For "..objectName
	local text=Process(mainSelections,advencedVariables,objectives,variables,newInstance,function(i,v,length) SetStatus(2,i,length) end)
	task.wait(2)

	--visualInstance:Destroy() visualInstance=nil 
	newInstance:Destroy() newInstance=nil Status.Text="Complete" CanContinue=false
	task.wait(2)
	return text
end

local function Initialize()
	if Debounce then return end
	Debounce=true
	Status.Text="Initialize"
	task.wait(2)
	Initilized()
	task.wait(2)
	Status.Text="Status"
	Debounce=false
end

local function Instal()
	Status.Text="Instal" 
	SetUpdate(2) 
	task.wait(2)
	if not InstalTarget and not Debounce then
		if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
		local newModel=Instance.new("Model")
		newModel.Name="GrabberModel"
		if BuildingTarget and not table.find(BuildingData,BuildingTarget) then table.insert(BuildingData,BuildingTarget) end 
		BuildingTarget=nil
		if next(BuildingData) then
			local buildingModel=Instance.new("Model") buildingModel.Name="Building" buildingModel.Parent=newModel
			for i,v in ipairs(BuildingData) do local cloneBuilding=v:Clone() cloneBuilding.Parent=buildingModel end
		end
		if GuiTarget and not table.find(GuiData,GuiTarget) then table.insert(GuiData,GuiTarget) end 
		GuiTarget=nil
		if next(GuiData) then
			local guiModel=Instance.new("Model") guiModel.Name="Gui" guiModel.Parent=newModel
			for i,v in ipairs(GuiData) do local cloneGui=v:Clone() cloneGui.Parent=guiModel end
		end
		if ToolTarget then
			local toolModel=Instance.new("Model") toolModel.Name="Tool" toolModel.Parent=newModel
			local cloneTool=ToolTarget:Clone() cloneTool.Parent=toolModel
		end
		ToolTarget=nil
		if next(newModel:GetChildren()) then
			GrabberModel=newModel
			InstalTarget=newModel
		else
			newModel:Destroy()
		end
	end
	if not InstalTarget then SetStatus(1,"Target Has Empty") return end
	if Debounce then return end
	Debounce=true
	if ContinueButton and ContinueButton.Parent then
		ContinueButton.Template.Visible=true
	end
	local success,result=pcall(function() return Convert(InstalTarget) end)
	if not Parent then return end
	if success and result then
		setclipboard(result)
		Status.Text="Copied To Clipboard!"
	else
		Status.Text="An Error Occured"
		warn(result)
	end
	task.wait(10)
	Status.Text="Status"
	Loader.Text="(0/0) 0%"
	if ContinueButton and ContinueButton.Parent then
		ContinueButton.Template.Visible=false
	end
	if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
	InstalTarget=nil
	SetUpdate(1)
	task.wait(2)
	Debounce=false
end

---- Character --
local CharacterAdded,CharacterToolAdded
do
	local function OnCharacterToolAdded(character)
		if CharacterToolAdded then
			CharacterToolAdded:Disconnect() 
			CharacterToolAdded=nil
		end
		CharacterToolAdded=character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then ToolTarget=child end
		end)
	end

	OnCharacterToolAdded(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
	CharacterAdded=LocalPlayer.CharacterAdded:Connect(OnCharacterToolAdded)
end

---- Grab Building --
local MouseButton1Down
do
	MouseButton1Down=Mouse.Button1Down:Connect(function()
		if not IsInput and GrabType=="Building" then 
			local target=Mouse.Target
			if target then
				MaxBuildingIndex=0
				local previus=target.Parent
				while previus~=workspace do
					MaxBuildingIndex=MaxBuildingIndex+1 
					if BuildingIndex~=0 and MaxBuildingIndex>=BuildingIndex and previus~=workspace then break end
					if target.Parent~=workspace then
						previus=target.Parent
						target=target.Parent
					else
						break
					end
				end
				if Window.Parent then
					MainLabel.Text="Max Building Index: " .. tostring(MaxBuildingIndex)
					Status.Text=target.Name.." | "..target.ClassName.." | "..tostring(#target:GetChildren())
				end
				SetUpdate(2,target)
				BuildingTarget=target
			else
				MaxBuildingIndex=0
				if Window.Parent then
					MainLabel.Text="0"
					Status.Text="Status"
				end
				SetUpdate(2)
				BuildingTarget=nil
			end
		end
	end)
end


local function Add()
	if Util.IsStrings(GrabType,BannedGrabTypeList) then 
		SetStatus(1,"An Error Occured") 
		return 
	end
	if GrabType=="Building" then
		if not BuildingTarget then 
			SetStatus(1,"Building Target Has Empty") 
			return 
		end
		if table.find(BuildingData,BuildingTarget) then 
			BuildingTarget=nil 
			--SetUpdate(2) 
			SetStatus(1,"Building Already Added") 
			--SetUpdate(2) 
			return 
		end
		table.insert(BuildingData,BuildingTarget) BuildingTarget=nil 
		--SetUpdate(2) 
		if not table.find(GrabTypeData,GrabType) then table.insert(GrabTypeData,GrabType) end
	elseif GrabType=="MouseIcon" then
		local newMouse=LocalPlayer:GetMouse()
		local mouseIconTarget=newMouse.Icon
		if not mouseIconTarget or #tostring(mouseIconTarget)==0 then SetStatus(1,"MouseIcon Target Has Empty") return end
		if table.find(MouseIconData,mouseIconTarget) then 
			SetStatus(1,"MouseIcon Already Added") 
			return 
		end
		table.insert(MouseIconData,mouseIconTarget) 
		if not table.find(GrabTypeData,GrabType) then table.insert(GrabTypeData,GrabType) end
	elseif GrabType=="Tool" then
		local character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local toolTargets={}
		for i,v in ipairs(character:GetChildren()) do if v:IsA("Tool") then table.insert(toolTargets,v) end end
		if not next(toolTargets) then SetStatus(1,"Tool Target Has Empty") return end
		for i,v in ipairs(toolTargets) do table.insert(ToolData,v:Clone()) end
		toolTargets={}
		if not table.find(GrabTypeData,GrabType) then table.insert(GrabTypeData,GrabType) end
	elseif GrabType=="Gui" then
		if GuiTarget then
			local found=table.find(GuiData,GuiTarget)
			if not found then
				table.insert(GuiData,GuiTarget)
			else
				SetStatus(1,"Gui Already Added")
			end
		else
			SetStatus(1,"Gui Target Has Empty") 
		end
	else
		if table.find(GrabTypeData,GrabType) then SetStatus(1,"Already Added") return end table.insert(GrabTypeData,GrabType)
	end
	SetStatus(1,"Successfully")
end

local function Reset()
	SetUpdate(1)
end

local function Destroy()
	Parent=nil
	Window:Destroy()
	if PlayerGuiAdded then
		PlayerGuiAdded:Disconnect() 
		PlayerGuiAdded=nil
	end
	if MouseButton1Down then
		MouseButton1Down:Disconnect() 
		MouseButton1Down=nil
	end	
	if CharacterAdded then
		CharacterAdded:Disconnect() 
		CharacterAdded=nil
	end	
	if CharacterToolAdded then
		CharacterToolAdded:Disconnect() 
		CharacterToolAdded=nil
	end	
	SetUpdate(1)
end

Status=Window:AddContext({
	Type="TextLabel",
	Name="Status",
})

Loader=Window:AddContext({
	Type="TextLabel",
	Name="(0/0) 0%",
})

-- Selector UI --
SelectorButton=Window:AddContext({
	Type="Selector",
	Options=GrabTypeList,
	Value=GrabTypeList[1],
	NoCap=true,
	Callback=function(value,key)
		GrabType=value
		SetUpdate(3)
	end,
})

MainLabel=Window:AddContext({
	Type="TextLabel",
	Name="",
})

MainLabel.Template.Visible=false

-- TextBox UI --
TextBox=Window:AddContext({
	Type="TextBox",
	PlaceholderText="Type here",
	Callback=function(text)
		local amount=tonumber(text)
		if amount then
			if GrabType=="Building" then 
				BuildingIndex=amount
			elseif GrabType=="GiveWalkSpeed" or GrabType=="GiveJump" then
				local character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				if character then 
					for i,v in ipairs(character:GetChildren()) do 
						if v:IsA("Humanoid") then 
							if GrabType=="GiveWalkSpeed" then 
								v.WalkSpeed=amount
							else v.UseJumpPower=true 
								v.JumpPower=amount 
							end 
						end 
					end 
				end
			end
		else
			TextBox.Text="Please enter the number"
			task.wait(2)
			TextBox.Text=""
		end
	end,
})
TextBox.Template.Visible=false


-- Add UI --
AddButton=Window:AddContext({
	Type="TextButton",
	Name="Add",
	Options=GrabTypeList,
	Callback=Add,
})

---- Initialize UI --
InitializeButton=Window:AddContext({
	Type="TextButton",
	Name="Initialize",
	Callback=Initialize,
})

--[Grab UI]--
InstalButton=Window:AddContext({
	Type="TextButton",
	Name="Instal",
	Callback=Instal,
})

InstalButton.BackgroundColor3=Color3.fromRGB(134,212,127)

-- Destroy UI
ContinueButton=Window:AddContext({
	Type="TextButton",
	Name="Continue",
	Callback=function()
		CanContinue=true
	end,
})

ContinueButton.BackgroundColor3=Color3.fromRGB(170,255,127)
ContinueButton.Template.Visible=false

-- Reset UI --
ResetButton=Window:AddContext({
	Type="TextButton",
	Name="Reset",
	Callback=Reset,
})

ResetButton.BackgroundColor3=Color3.fromRGB(255,89,89)

-- Destroy UI
DestroyButton=Window:AddContext({
	Type="TextButton",
	Name="Destroy",
	Callback=Destroy,
})

DestroyButton.BackgroundColor3=Color3.fromRGB(255,124,16)
