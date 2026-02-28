-- Created by @Paazlis
local PLUGIN_NAME="Instal Object"
local VERSION="2.2.3"
local MAX_CAP=300

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

local Tabler=loadstring(game:HttpGet('https://raw.githubusercontent.com/PaazlisMaswa/RobloxTabler/refs/heads/main/Tabler.luau'))()
local Instancer=loadstring(game:HttpGet('https://raw.githubusercontent.com/PaazlisMaswa/RobloxInstancer/refs/heads/main/Instancer.luau'))()
local Strs=loadstring(game:HttpGet('https://raw.githubusercontent.com/PaazlisMaswa/RobloxStrs/refs/heads/main/Strs.luau'))()
local UI=loadstring(game:HttpGet('https://raw.githubusercontent.com/PaazlisMaswa/PaazlisUI/refs/heads/main/panel.lua'))()

local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local Mouse=LocalPlayer:GetMouse()
local SaveMouseIcon=Mouse.Icon

local Window=UI:CreateWindow()

Window:SetTitle("Download")

local IsStrings,GetLines,ToNumberString,GetProperties,IsAs,CopyInstanceWith,GetInstanceProperty,CreateVariable,ConvertMeshPartToSpecialMesh,GetAncestorsAndSelf=
	Strs.IsStrings,Strs.GetLines,Strs.ToNumberString,
	Tabler.GetProperties,
	Instancer.IsAs,Instancer.CopyInstanceWith,Instancer.GetInstanceProperty,Instancer.CreateVariable,Instancer.ConvertMeshPartToSpecialMesh,Instancer.GetAncestorsAndSelf

local MathHuge,MathFloor,MathMax,StringFormat,StringSplit,StringSub,StringFind,StringGmatch,TableInsert,TableConcat,Color3FromRGB,InstanceNew=math.huge,math.floor,math.max,string.format,string.split,string.sub,string.find,string.gmatch,table.insert,table.concat,Color3.fromRGB,Instance.new

-- UI
local Status,Loader,ContinueButton,ResetButton,DestroyButton,TextBox,SelectorButton,AddButton,InitializeButton,InstalButton

local Outliner=InstanceNew("SelectionBox")
Outliner.Name="Selection"
Outliner.Color3=Color3.fromRGB(25,153,255)
Outliner.LineThickness=0.1
Outliner.SurfaceColor3=Color3.fromRGB(255,255,255)
Outliner.SurfaceTransparency=1
Outliner.Transparency=0
Outliner.Adornee=nil
Outliner.Visible=false
Outliner.Parent=UI.Gui

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

function ToNumberString(x:number,maxFloat:number?)
	maxFloat=if type(maxFloat)=="number" and maxFloat>0 then maxFloat else 10
	if x==MathFloor(x) then return tostring(MathFloor(x)) end
	local s=StringFormat("%."..maxFloat.."f",x)
	s=s:gsub("%.?0+$", "")
	return s
end

local LocalData={
	["Color3"]={
		["Prefix"]="fromRGB",
		["Value"]="Color3.fromRGB"
	},
	["Vector2"]={
		["Prefix"]="V2",
		["Value"]="Vector2.new"
	},
	["Vector3"]={ 
		["Prefix"]="V3",
		["Value"]="Vector3.new"
	},
	["Vector4"]={ 
		["Prefix"]="V4",
		["Value"]="Vector4.new"
	},
	["CFrame"]={
		["Prefix"]="CF",
		["Value"]="CFrame.new"
	},
	["UDim2"]={
		["Prefix"]="UD2",
		["Value"]="UDim2.new"
	},
	["UDim"]={
		["Prefix"]="UD",
		["Value"]="UDim.new"
	},
	["BrickColor"]={
		["Prefix"]="BC",
		["Value"]="BrickColor.new"
	},
	["Rect2D"]={
		["Prefix"]="R2D",
		["Value"]="Rect.new"
	},
	["PhysicalProperties"]={
		["Prefix"]="PhyProp",
		["Value"]="PhysicalProperties.new"
	},
	["ColorSequenceKeypoint"]={
		["Prefix"]="CSeqKey",
		["Value"]="ColorSequenceKeypoint.new"
	},
	["NumberSequenceKeypoint"]={
		["Prefix"]="NSeqKey",
		["Value"]="NumberSequenceKeypoint.new"
	},
	["FloatSequenceKeypoint"]={
		["Prefix"]="FSeqKey",
		["Value"]="FloatSequenceKeypoint.new"
	},
	["ColorSequence"]={
		["Prefix"]="CSeq",
		["Value"]="ColorSequence.new"
	},
	["NumberSequence"]={
		["Prefix"]="NSeq",
		["Value"]="NumberSequence.new"
	},
	["FloatSequence"]={
		["Prefix"]="FSeq",
		["Value"]="FloatSequence.new"
	}
}

local SafeData={}
do
	-- Normal --
	SafeData["bool"]=function(value) return tostring(value) end
	SafeData["boolean"]=SafeData["bool"]
	SafeData["float"]=function(value) return ToNumberString(value,2) end
	SafeData["int"]=function(value) return tostring(MathFloor(value)) end
	SafeData["number"]=function(value) return ToNumberString(value,3) end
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

		for object in GetAncestorsAndSelf(value) do
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
				elseif object==PlayerGui or hierarchy=="PlayerGui" then
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
		return ("PhyProp(%.3f,%.3f,%.3f,%.3f,%.3f)"):format(value.Density,value.Friction,value.Elasticity,value.FrictionWeight,value.ElasticityWeight);
	end
	SafeData["Rect2D"]=function(value)
		return "R2D("..tostring(value):gsub("\n",""):gsub(" ","")..")"
	end
	SafeData["BrickColor"]=function(value)
		return ("BC(%d,%d,%d)"):format(value.r*255,value.g*255,value.b*255);
	end
	SafeData["Color3"]=function(value)
		return ("fromRGB(%d,%d,%d)"):format(value.R*255,value.G*255,value.B*255);
	end
	SafeData["UDim"]=function(value)
		local list={value.Scale,value.Offset}
		local results={}
		for i,x in ipairs(list)  do
			results[i]=ToNumberString(x,3)
		end
		local s=TableConcat(results,",")
		return "UD("..s..")"
	end
	SafeData["UDim2"]=function(value)
		local results={}
		local xList=StringSplit(tostring(value.X):gsub("\n",""):gsub(" ",""),",")
		for i,v in ipairs(xList)  do
			TableInsert(results,ToNumberString(v,3))
		end
		local yList=StringSplit(tostring(value.Y):gsub("\n",""):gsub(" ",""),",")
		for i,v in ipairs(yList)  do
			TableInsert(results,ToNumberString(v,3))
		end
		local s=TableConcat(results,",")
		return "UD2("..s..")"
	end
	SafeData["Vector2"]=function(value)
		local list={value.X,value.Y}
		local results={}
		for i,x in ipairs(list)  do
			results[i]=ToNumberString(x,3)
		end
		local s=TableConcat(results,",")
		return "V2("..s..")"
	end
	SafeData["Vector3"]=function(value)
		local list={value.X,value.Y,value.Z}
		local results={}
		for i,x in ipairs(list)  do
			results[i]=ToNumberString(x,3)
		end
		local s=TableConcat(results,",")
		return "V3("..s..")"
	end
	SafeData["Vector4"]=function(value)
		local list={value.X,value.Y,value.Z,value.W or value.A}
		local results={}
		for i,x in ipairs(list)  do
			results[i]=ToNumberString(x,3)
		end
		local s=TableConcat(results,",")
		return "V4("..s..")"
	end
	SafeData["CFrame"]=function(value)
		local list=StringSplit(tostring(value):gsub("\n",""):gsub(" ",""),",")
		local results={}
		for i,x in ipairs(list)  do
			results[i]=ToNumberString(x,3)
		end
		local s=TableConcat(results,",")
		return "CF("..s..")"
	end
	-- Sequence --
	SafeData["ColorSequenceKeypoint"]=function(value:ColorSequenceKeypoint)
		return ("CSeqKey(%.2f,%s)"):format(value.Time,SafeData["Color3"](value.Value));
	end
	SafeData["NumberSequenceKeypoint"]=function(value)
		return ("NSeqKey(%.2f,%.2f)"):format(value.Time,value.Value)
	end
	SafeData["FloatSequenceKeypoint"]=function(value)
		return ("FSeqKey(%.2f,%.2f)"):format(value.Time,value.Value)
	end
	SafeData["ColorSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  TableInsert(t,SafeData["ColorSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("CSeq({%s})"):format(s)
	end
	SafeData["NumberSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  TableInsert(t,SafeData["NumberSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("NSeq({%s})"):format(s);
	end
	SafeData["FloatSequence"]=function(value)
		local t={}
		for i,v in ipairs(value.Keypoints) do  TableInsert(t,SafeData["FloatSequenceKeypoint"](v)..(i<=#value.Keypoints-1 and "," or "")) end
		local s=""
		for i,v in ipairs(t) do s=s..v end
		return ("FSeq({%s})"):format(s);
	end
end

local RegisteredClasses,ObjectClasses,RegisteredGUIClasses,GUIClasses={},{},{},{}

local ExplorerData={
	["Event"]={Workspace,ReplicatedStorage,ReplicatedFirst},
	["Sound"]={Workspace,ReplicatedStorage,SoundService,LocalPlayer},
	["Lighting"]={Lighting},
	["GuiColor"]={PlayerGui,ReplicatedStorage},
	["Effect"]={Workspace,ReplicatedStorage},
	["Name"]={Workspace,ReplicatedStorage,Players,Teams,ReplicatedFirst,StarterPack},
	["Icon"]={Workspace,ReplicatedStorage,PlayerGui,Teams,ReplicatedFirst}
}

local NumericList,EventClasses,LightingClasses,UIClasses,ColorProperties,TextProperties,UIColorProperties=
	{"1","2","3","4","5","6","7","8","9","0"},
	{"RemoteEvent","RemoteFunction","BindableEvent","BindableFunction","UnreliableRemoteEvent"},
	{"Sky","BloomEffect","ColorCorrectionEffect","SunRaysEffect","Atmosphere","BlurEffect"},
	{"ScreenGui","Frame","ImageLabel","TextLabel","ImageButton","TextButton","ScrollingFrame","TextBox"},
	{"BackgroundColor3","ImageColor3","BorderColor3","Color","Color3","Value","BrickColor"},
	{"Name","Value","Message","Text","Print","DisplayName"},
	{"BackgroundColor3","ImageColor3","BorderColor3","Color","Color3","Value","BrickColor"}

local GrabTypeList={"None","Building","Gui","Lighting","Sound","Tool","Icon","Team","Event","Texture","Decal","Beam","Trail","GuiIcon","Name","GuiColor","PartColor","MouseIcon","GiveWalkSpeed","GiveJump"}
local BannedGrabTypeList={"None","DestroyThis","GiveWalkSpeed","GiveJump","Continue"}
local GrabTypeData={}
local BuildingData={}
local GuiData={}
local ToolData={}
local MouseIconData={}
local InstalData={}
local ScrollConnections={}
local Cache={}

local GrabType=GrabTypeList[1]

local LastStatus=""
local BuildingTarget=nil
local GuiTarget=nil
local ToolTarget=nil
local InstalTarget=nil

local Destroyed=false
local CanContinue=false
local Debounce=false
local IsInput=false
local PlayerGuiAdded

local CurrentChooseIndex=1
local BuildingIndex=0
local TotalBuilding=0

local GrabberModel

-- Create Object Class --
function CreateClasses(property)
	local currentClass,templateObject,classList,registeredList=nil,nil,{},{}
	for line in GetLines(property) do
		if StringSub(line,1,1)~="-" then
			local continue=false

			if StringSub(line,1,1)=="	" then
				if templateObject then
					local space=StringFind(line," ")
					if not tonumber(space) then return end

					local datatype=StringSub(line,2,space-1)
					local property=StringSub(line,space+1,#line)

					if SafeData[datatype]==nil then
						warn("["..PLUGIN_NAME.."]: ","Unhandled data type \""..datatype.."\" "..currentClass.."."..property.." will be ignored.")
						continue=true
					end

					if not pcall(function() return templateObject[property] end) then
						warn("["..PLUGIN_NAME.."]: ","Unknown property "..currentClass.."."..property.." will be ignored.")
						continue=true
					end
					--
					if not continue then
						classList[currentClass][property]={
							DataType=datatype,
							DefaultValue=templateObject[property]
						}
						TableInsert(classList[currentClass],property)
					end
				end
			else
				if templateObject then templateObject:Destroy() templateObject=nil end
				currentClass=nil

				if not pcall(function() InstanceNew(line):Destroy() end) then
					warn("["..PLUGIN_NAME.."]: ","Unknown class \""..line.."\" will be ignored.")
					continue=true
				end

				if not continue then
					currentClass=line
					TableInsert(registeredList,line)
					templateObject=InstanceNew(currentClass)
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

ObjectClasses,RegisteredClasses=CreateClasses(REFERENCE_PROPERTY)
GUIClasses,RegisteredGUIClasses=CreateClasses(GUI_PROPERTY)
REFERENCE_PROPERTY=nil
GUI_PROPERTY=nil

local Module={}

function Module:SetStatus(mode,...)
	if mode==1 or mode==0 then
		local message,cooldown=...
		if type(message)~="string" then return end
		LastStatus=message
		Status.Text=message
		if mode==0 then return end
		if cooldown then task.wait(tonumber(cooldown) or 2) end
		if Status.Text==LastStatus then
			Status.Text="Status"
		end
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
				Loader.Text="("..current.."/"..max..") "..StringFormat("%.2f",percentage*100).."%"	
			end
		end
	end
end

function Module:SetUpdate(mode,...)
	if mode==1 then
		GrabTypeData={}
		GrabType=GrabTypeList[1]
		CurrentChooseIndex=1
		BuildingData={}
		BuildingTarget=nil
		InstalData={}
		InstalTarget=nil
		GuiData={}
		GuiTarget=nil
		ToolData={}
		ToolTarget=nil
		MouseIconData={}
		if PlayerGuiAdded then PlayerGuiAdded:Disconnect() PlayerGuiAdded=nil end
		if SelectorButton and SelectorButton.Parent then
			SelectorButton.Value=GrabTypeList[1]
		end
		if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
		if Window.Parent then
			Status.Text="Status"
			Loader.Text="(0/0) 0%"
		end
		self:SetUpdate(2)
		self:SetUpdate(3)
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

		if GrabType~="Building" then self:SetUpdate(2) end

		if PlayerGuiAdded then PlayerGuiAdded:Disconnect() PlayerGuiAdded=nil end

		if TextBox and TextBox.Parent then
			local visible=(GrabType=="Building" or GrabType=="GiveWalkSpeed" or GrabType=="GiveJump")
			TextBox.Template.Visible=visible

			if GrabType=="Building" then
				TextBox.PlaceholderText="Total Building"
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
				MainLabel.Text="Building Index: " .. tostring(BuildingIndex)
			elseif GrabType=="Gui" then
				local originText=`Use dex/explorer and Add StringValue and named "InstalGui" to any ScreenGui in PlayerGui`
				MainLabel.Text=originText
				PlayerGuiAdded=PlayerGui.DescendantAdded:Connect(function(child:Instance)
					if child:IsA("StringValue") and child.Name=="InstalGui" then
						local success=false
						local value=child.Parent
						if value then 
							if value:IsA("ScreenGui") then
								GuiTarget=value
								success=true
							else
								success=false
							end
						end
						if success then
							child:Destroy()
						end
						local nextText=not success and "An Error Occured" or "Successfully"
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

function Module:GetGrabData(mode)
	mode=tostring(mode)
	Status.Text=mode
	task.wait(2)
	
	local newModel=InstanceNew("Model") 
	newModel.Name=mode
	
	local s,sLen,maxSLen="",0,50
	local needle=nil
	local actives,needles,explorers={},{},ExplorerData[mode] or {}
	
	if mode=="Texture" or mode=="Effect" or mode=="Decal" or mode=="Trail" or mode=="Beam" then
		explorers=ExplorerData["Effect"]
	end

	if mode=="Event" then
		CopyInstanceWith(explorers,newModel,function(v) 
			if IsAs(v,EventClasses) then 
				needle=v.Name.."_"..v.ClassName
				if not actives[needle] then 
					actives[needle]=true 
					Status.Text=mode..": "..v.Name 
					return true 
				end 
			end 
			return false 
		end,ObjectClasses)
	elseif mode=="Sound" then
		local soundIds={}
		CopyInstanceWith(explorers,newModel,function(v) 
			if v.ClassName=="Sound" then 
				local name=v.Name
				needle=tostring(v.SoundId) 
				if not actives[needle] then 
					actives[needle]=true
					Status.Text=mode..": "..name
					TableInsert(soundIds,{name,needle})
					return true
				end 
			end 
			return false 
		end,ObjectClasses)
		
		if #soundIds>=200 then 
			Status.Text="Dangerous!"
			task.wait(2)
			Status.Text=""
			newModel:ClearAllChildren()
			s="\n local SoundIds={"
			for i,v in ipairs(soundIds) do
				RunService.Stepped:Wait() 
				Status.Text=mode..": "..v[2]
				if i==#soundIds then 
					s=s.."{'"..v[1].."'"..",".."'"..v[2].."'}"
				else 
					s=s.."{'"..v[1].."'"..",".."'"..v[2].."'},"
				end 
				sLen=(sLen+1)%maxSLen 
				if sLen==0 then s=s.."\n" end  
			end
			s=s.."}\n"
			s=s.. [[for i,v in ipairs(SoundIds) do local nv=e('Sound') nv.Name=v[1] nv.SoundId=v[2] nv.Parent=%s end]] .."\n"
		end
		soundIds={}
	elseif mode=="Lighting" then
		local newLighting=InstanceNew("Model")
		newLighting.Name="Lighting"
		newLighting.Parent=newModel
		
		local newAmbient=InstanceNew("Color3Value")
		newAmbient.Name="Ambient"
		newAmbient.Value=Lighting.Ambient
		newAmbient.Parent=newLighting

		local newBrightness=InstanceNew("NumberValue")
		newBrightness.Name="Brightness"
		newBrightness.Value=Lighting.Brightness
		newBrightness.Parent=newLighting

		local newColorShift_Bottom=InstanceNew("Color3Value")
		newColorShift_Bottom.Name="ColorShift_Bottom"
		newColorShift_Bottom.Value=Lighting.ColorShift_Bottom
		newColorShift_Bottom.Parent=newLighting

		local newColorShift_Top=InstanceNew("Color3Value")
		newColorShift_Top.Name="ColorShift_Top"
		newColorShift_Top.Value=Lighting.ColorShift_Top
		newColorShift_Top.Parent=newLighting

		local newEnvironmentDiffuseScale=InstanceNew("NumberValue")
		newEnvironmentDiffuseScale.Name="EnvironmentDiffuseScale"
		newEnvironmentDiffuseScale.Value=Lighting.EnvironmentDiffuseScale
		newEnvironmentDiffuseScale.Parent=newLighting

		local newEnvironmentSpecularScale=InstanceNew("NumberValue")
		newEnvironmentSpecularScale.Name="EnvironmentSpecularScale"
		newEnvironmentSpecularScale.Value=Lighting.EnvironmentSpecularScale
		newEnvironmentSpecularScale.Parent=newLighting

		local newGlobalShadows=InstanceNew("BoolValue")
		newGlobalShadows.Name="GlobalShadows"
		newGlobalShadows.Value=Lighting.GlobalShadows
		newGlobalShadows.Parent=newLighting

		local newOutdoorAmbient=InstanceNew("Color3Value")
		newOutdoorAmbient.Name="OutdoorAmbient"
		newOutdoorAmbient.Value=Lighting.OutdoorAmbient
		newOutdoorAmbient.Parent=newLighting

		local newShadowSoftness=InstanceNew("NumberValue")
		newShadowSoftness.Name="ShadowSoftness"
		newShadowSoftness.Value=Lighting.ShadowSoftness
		newShadowSoftness.Parent=newLighting

		local newClockTime=InstanceNew("NumberValue")
		newClockTime.Name="ClockTime"
		newClockTime.Value=Lighting.ClockTime
		newClockTime.Parent=newLighting

		local newGeographicLatitude=InstanceNew("NumberValue")
		newGeographicLatitude.Name="GeographicLatitude"
		newGeographicLatitude.Value=Lighting.GeographicLatitude
		newGeographicLatitude.Parent=newLighting

		local newExposureCompensation=InstanceNew("NumberValue")
		newExposureCompensation.Name="ExposureCompensation"
		newExposureCompensation.Value=Lighting.ExposureCompensation
		newExposureCompensation.Parent=newLighting

		Status.Text=mode..": "..newLighting.Name
		task.wait(2)

		CopyInstanceWith(explorers,newModel,function(v) 
			if IsAs(v,LightingClasses) then 
				Status.Text=mode..": "..v.Name 
				return true
			end 
			return false 
		end,ObjectClasses)
	elseif mode=="Team" then
		CopyInstanceWith({Teams},newModel,function(v) 
			if v.ClassName=="Team" then 
				needle=v.Name.."_"..tostring(v.TeamColor) 
				if not actives[needle] then 
					actives[needle]=true
					Status.Text=mode..": "..v.Name 
					return true 
				end 
			end 
			return false 
		end,ObjectClasses)
	elseif mode=="Texture" then
		CopyInstanceWith(explorers,newModel,function(v) if v.ClassName=="Texture" then needle=v.Texture if not actives[needle] then actives[needle]=true Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Decal" then
		CopyInstanceWith(explorers,newModel,function(v) if v.ClassName=="Decal" then needle=v.Texture if not actives[needle] then actives[needle]=true Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Trail" then
		CopyInstanceWith(explorers,newModel,function(v) if v.ClassName=="Trail" then needle=v.Texture if not actives[needle] then actives[needle]=true Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="Beam" then
		CopyInstanceWith(explorers,newModel,function(v) if v.ClassName=="Beam" then needle=v.Texture if not actives[needle] then actives[needle]=true Status.Text=mode..": "..v.Name return true end end return false end,ObjectClasses)
	elseif mode=="GuiColor" then
		for j,k in ipairs(explorers) do for i,v in ipairs(k:GetDescendants()) do if IsAs(v,UIClasses) then GetInstanceProperty(v,UIColorProperties,function(dataType,propertyValue) if dataType=="Color3" or dataType=="BrickColor" then needle=dataType.."_"..tostring(propertyValue) if not actives[needle] then actives[needle]=true Status.Text=mode..": "..tostring(propertyValue) if dataType=="BrickColor" then s=s..tostring(propertyValue)..";" else s=s..SafeData["Color3"](propertyValue)..";" end if sLen>=maxSLen then s=s.."\n" end sLen=(sLen+1) % maxSLen RunService.Stepped:Wait() end end end) end end end
	elseif mode=="PartColor" then
		for i,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then GetInstanceProperty(v,ColorProperties,function(dataType,propertyValue) if dataType=="Color3" or dataType=="BrickColor" then needle=dataType.."_"..tostring(propertyValue) if not actives[needle] then actives[needle]=true Status.Text=mode..": "..tostring(propertyValue) if dataType=="BrickColor" then s=s..tostring(propertyValue)..";" else s=s..SafeData["Color3"](propertyValue)..";" end if sLen>=maxSLen then s=s.."\n" end sLen=(sLen+1) % maxSLen RunService.Stepped:Wait() end end end) end end
	elseif mode=="Name"  then
		for j,k in ipairs(explorers) do for i,v in ipairs(k:GetDescendants()) do GetInstanceProperty(v,TextProperties,function(dataType,propertyValue,propertyName) if dataType=="string" then local nameFilter="" for v in StringGmatch(propertyValue,"[%w]") do if not IsStrings(v,NumericList) then nameFilter=nameFilter..v end end if #nameFilter==0 then return end local isA=false pcall(function() isA=v:IsA(nameFilter) end) if isA or #nameFilter==0 then return end local newInstance=InstanceNew(v.ClassName) local instanceValue=nil pcall(function() instanceValue=newInstance[propertyName] end) if instanceValue and instanceValue==nameFilter then newInstance:Destroy() return end if not actives[nameFilter] then actives[nameFilter]=true Status.Text=mode..": "..nameFilter s=s..nameFilter..";" if sLen>=maxSLen then s=s.."\n" end sLen=(sLen+1)%maxSLen RunService.Stepped:Wait() end end end) end  end
	elseif mode=="MouseIcon" then
		if next(MouseIconData) then for v,k in pairs(MouseIconData) do Status.Text=mode..": "..v s=s..v..";" if sLen>=maxSLen then s=s.."\n" end sLen=(sLen+1)%maxSLen RunService.Stepped:Wait() end end
	elseif mode=="Icon" then
		for j,k in ipairs(explorers) do for i,v in ipairs(k:GetDescendants()) do GetInstanceProperty(v,{"Texture","Icon","TextureId","Image","HoverImage"},function(dataType,propertyValue) if dataType=="string" then needle=propertyValue if not actives[needle] then actives[needle]=true s=s..needle..";" if sLen>=maxSLen then s=s.."\n" end  sLen=(sLen+1) % maxSLen RunService.Stepped:Wait() end end end) end end
	elseif mode=="GuiIcon" then
		for i,v in ipairs(PlayerGui:GetDescendants()) do GetInstanceProperty(v,{"Texture","Icon","TextureId","Image","HoverImage"},function(dataType,propertyValue) if dataType=="string" then needle=propertyValue if not actives[needle] then actives[needle]=true s=s..needle..";" if sLen>=maxSLen then s=s.."\n" end sLen=(sLen+1) % maxSLen RunService.Stepped:Wait() end end end) end
	elseif mode=="Tool" then
		if not next(ToolData) then  for i,v in ipairs(ReplicatedStorage:GetDescendants()) do if v.ClassName=="Tool" then Status.Text=mode TableInsert(ToolData,v:Clone()) RunService.Stepped:Wait() end end end
		ToolTarget=nil
		if next(ToolData) then for i,v in ipairs(ToolData) do if v and v.Parent==nil then Status.Text=mode..": "..v.Name v.Parent=newModel RunService.Stepped:Wait() end end end
	elseif mode=="Gui" then
		if GuiTarget and not GuiData[GuiTarget] then GuiData[GuiTarget]=true end 
		GuiTarget=nil
		if next(GuiData) then for v,k in pairs(GuiData) do local cv=v:Clone() if cv and cv.Parent==nil then Status.Text=mode..": "..cv.Name cv.Parent=newModel end RunService.Stepped:Wait() end end
	elseif mode=="Building" then
		if BuildingTarget and not BuildingData[BuildingTarget] then BuildingData[BuildingTarget]=true end 
		BuildingTarget=nil 
		if next(BuildingData) then for v,k in pairs(BuildingData) do local cv=v:Clone() if cv and cv.Parent==nil then Status.Text=mode..": "..cv.Name cv.Parent=newModel end RunService.Stepped:Wait() end end
	else
		return false,nil
	end
	
	local isModel=false
	local modelChildren=newModel:GetChildren()
	
	if #s>0 then
		warn(s)
		local ns=mode~="Sound" and `local {mode}s=[[{s}]]` or s
		if #ns>=2000 then
			LastStatus="This "..mode.." string is too long! and "..tostring(#ns)
			Status.Text=LastStatus
			task.wait(2)
		end
		if mode=="Name" or mode=="PartColor" or mode=="GuiColor" or mode=="Icon" or mode=="GuiIcon" then
			newModel:Destroy()
			newModel=nil
		end
		InstalData[mode]={ns}
		isModel=false
	elseif #s<=0 and not next(modelChildren) then
		self:SetStatus(0,mode.." Has Empty")
		newModel:Destroy()
		newModel=nil
		task.wait(2)
	else
		isModel=true
	end
	s="" sLen=0 needle=nil actives,explorers,needles={},{},{}
	return isModel,newModel
end

function Module:Initialize()
	if Debounce then return end
	Debounce=true
	Status.Text="Initialize"
	task.wait(2)
	
	self:SetUpdate(2)

	if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
	
	local newInstance=InstanceNew("Model")
	newInstance.Name="InstalModel"
	

	if next(GrabTypeData) then
		for k,v in pairs(GrabTypeData) do 
			RunService.Stepped:Wait() 
			local isGroup,newGroup=self:GetGrabData(k) 
			if newGroup then
				newGroup.Parent=newInstance 
				if isGroup then
					InstalData[k]=newGroup:GetChildren() 
				end
			end
		end
	elseif GrabType then
		local isGroup,newGroup=self:GetGrabData(GrabType) 
		if newGroup then
			newGroup.Parent=newInstance
			if isGroup then
				InstalData[GrabType]=newGroup:GetChildren() 
			end
		end
	end
	
	if next(InstalData) then
		local length=#newInstance:GetDescendants()+1
		if length>=MAX_CAP then LastStatus="Dangerous!" else LastStatus="Grab "..tostring(length).." Object" end
		Status.Text=LastStatus
		task.wait(2)
		GrabberModel=newInstance
		InstalTarget=newInstance
		self:SetStatus(0,"Successfully")
	else
		self:SetStatus(0,"An Error Occured")
	end
	
	task.wait(2)
	self:SetStatus(0,"Status")
	Debounce=false
end

function Module:Starting(instance,func)
	local selections={}
	local progress,maxProgress,waitCount=0,0,0
	local meshParts={}
	local packList={instance:FindFirstChild("Building"),instance:FindFirstChild("Tool"),instance:FindFirstChild("Gui")}
	for j,k in ipairs(packList) do if k then selections=k:GetDescendants()  for i,v in ipairs(selections) do if v:IsA("MeshPart") then maxProgress+=1 TableInsert(meshParts,v) end end end end
	if next(meshParts) then
		maxProgress+=#meshParts
		for i,v in ipairs(meshParts) do
			if CanContinue then CanContinue=false continue end 
			progress+=2
			waitCount=(waitCount+1)%15
			if waitCount==0 then RunService.Stepped:Wait() end 
			ConvertMeshPartToSpecialMesh(v)
			func(progress,v,maxProgress) 
		end 
		func(progress,nil,maxProgress) 
		task.wait(2)
	end
end

function Module:Creating(instance,realInstance,data,func)
	local mainSelections,variables,objectives,advencedVariables,count={},{},{},{},0
	local descendants=instance:GetDescendants()
	local progress,maxProgress,waitCount=0,#descendants,0
	for mode,list in pairs(data) do for j,k in ipairs(list) do if type(k)=="string" then maxProgress+=1 end end end
	
	for i,v in ipairs(descendants) do
		if IsStrings(v.ClassName,RegisteredClasses) then 
			progress+=1
			waitCount=(waitCount+1)%15
			if waitCount==0 then RunService.Stepped:Wait() end 
			count=count+1
			CreateVariable(v,variables)
			objectives[variables[v]]=v
			advencedVariables[v]=StringFormat("%s[\'%s\']","V",count)
			TableInsert(mainSelections,v)
			func(progress,v,maxProgress)
		end
	end
	
	for mode,list in pairs(data) do
		for j,k in ipairs(list) do
			if type(k)=="string" then
				progress+=1
				waitCount=(waitCount+1)%15
				if waitCount==0 then RunService.Stepped:Wait() end 
				local v=realInstance:FindFirstChild(mode)
				if v then
					local variable=advencedVariables[v]
					TableInsert(mainSelections,StringFormat(k,variable))
				end
				func(progress,v,maxProgress)
			end
		end
	end
	func(maxProgress,nil,maxProgress) 
	return mainSelections,variables,objectives,advencedVariables
end

function Module:Process(selections,variables,objectives,targets,firstParent,func)
	local isLimit=#selections>=MAX_CAP
	local textLocal,textCoding,textProperty,textInstance="local","","",""
	local isNextProperty,isInstance=false,false
	local foundLocals={}
	local progress,maxProgress=0,#selections
	local sPrefix,sValue="",""
	
	for i,v in ipairs(selections) do
		if v then
			progress+=1
			RunService.Stepped:Wait()
			if type(v)=="string" then
				textCoding=textCoding..v.."\n"
			else
				isNextProperty=false
				local variable,class=variables[v],v.ClassName
				local isPart=v:IsA("BasePart")
				isInstance=true
				local data=InstalData[v.Name]
				if i~=1 and not isLimit then textInstance=textInstance.."\n" end
				if isInstance then
					textInstance=textInstance..StringFormat("%s=e(\'%s\')",variable,class)..";"
					if i~=1 and not isLimit then textProperty=textProperty.."\n" end
					local needle,actives=nil,{}

					for propertyName,property in GetProperties(ObjectClasses[v.ClassName]) do
						RunService.Stepped:Wait()
						
						local propertyType=property.DataType
						
						local s,propertyValue=pcall(function() return v[propertyName] end)
						if not s or not propertyValue then continue end

						if property.DefaultValue==propertyValue then continue end
						if propertyType=="string" and #propertyValue==0 then continue end
						if isLimit and (propertyType=="CFrame" or propertyType=="PhysicalProperties") then continue end
						if isLimit and (propertyType=="string" or propertyType=="bool") and (propertyName=="Name" or (isPart and propertyName=="Anchored")) then continue end
						
						needle=propertyType.."_"..propertyName 

						if actives[needle] then continue end 
						actives[needle]=true
						isNextProperty=false
						
						if LocalData[propertyType] and not foundLocals[propertyType] then
							foundLocals[propertyType]=true
							table.insert(foundLocals,propertyType)
							maxProgress+=1
						end
						
						if IsStrings(propertyType,{"number","float","int","short"}) and tonumber(propertyValue) then 
							isNextProperty=true 
							if propertyValue>=MathHuge then 
								textProperty=textProperty..StringFormat("%s.%s=%s",variable,propertyName,"math.huge")..";" 
							elseif propertyValue<=-MathHuge then 
								textProperty=textProperty..StringFormat("%s.%s=%s",variable,propertyName,"-math.huge")..";" 
							else
								isNextProperty=false 
							end
						elseif propertyType=="Object" then 
							if propertyName=="Parent" and v.Parent==firstParent then 
								isNextProperty=true 
								textProperty=textProperty..StringFormat("%s.%s=%s",variable,"Parent","workspace")..";" 
							end 
						end
						
						if not isNextProperty then
							if propertyType=="Object" then
								if variables[propertyValue] then
									textProperty=textProperty..StringFormat("%s.%s=%s",variable,propertyName,variables[propertyValue])..";"
								else
									warn("["..PLUGIN_NAME.."]: PROCESS FAILED: ","Object",v.Name,v.ClassName.."."..tostring(propertyName),tostring(objectives[targets[propertyValue]]))
									pcall(function()
										textProperty=textProperty..StringFormat("%s.%s=%s",variable,propertyName,variables[propertyValue] or variables[v])..";"
									end)
								end
							else
								textProperty=textProperty..StringFormat("%s.%s=%s",variable,propertyName,SafeData[propertyType](propertyValue))..";"
							end
							isNextProperty=true
						end
					end
					textProperty=textProperty.."\n"
				end
			end
			func(progress,v,maxProgress)
		end
	end
	
	textInstance=textInstance.."\n"
	textLocal=textLocal.." V,e"
	
	for i,k in ipairs(foundLocals) do
		progress+=1
		local v=LocalData[k] 
		if v then
			RunService.Stepped:Wait()
			local prefix,value=v.Prefix,v.Value
			if i==#foundLocals then
				sPrefix=sPrefix..prefix
				sValue=sValue..value
			else
				sPrefix=sPrefix..prefix..","
				sValue=sValue..value..","
			end
		end
		func(progress,v,maxProgress)
	end
	
	if #sPrefix~=0 then
		textLocal=textLocal..","..sPrefix
	end
	
	textLocal=textLocal.."={},Instance.new"
	
	if #sValue~=0 then
		textLocal=textLocal..","..sValue
	end
	
	if not isLimit then textLocal=textLocal.."\n\n" end
	
	func(progress,nil,maxProgress)

	local clipText=""
	if #textCoding>0 then
		clipText=textLocal..textInstance..textCoding..textProperty
	else
		clipText=textLocal..textInstance..textProperty
	end

	foundLocals={}
	return clipText
end

function Module:Convert(data,target)
	local visualInstance=InstanceNew("Model")
	visualInstance.Name="Visual"
	target.Parent=visualInstance
	
	-- Starting --
	Status.Text="Starting Object"
	self:Starting(target,function(i,v,length) Status.Text="Starting Object" self:SetStatus(2,i,length) end)
	task.wait(2)
	
	local length=#target:GetDescendants()+1
	if length>=MAX_CAP then LastStatus="Dangerous!" else LastStatus="Grab "..tostring(length).." Object" end
	Status.Text=LastStatus
	task.wait(2)
	
	if ContinueButton and ContinueButton.Parent then
		ContinueButton.Template.Visible=false
	end
	
	-- Creating --
	Status.Text="Create Object"
	local mainSelections,variables,objectives,advencedVariables=self:Creating(visualInstance,target,data,function(i,v,length) Status.Text="Create Object" self:SetStatus(2,i,length) end)
	task.wait(2)

	-- Process --
	Status.Text="Process Object"
	local text=self:Process(mainSelections,advencedVariables,objectives,variables,visualInstance,function(i,v,length) Status.Text="Process Object" self:SetStatus(2,i,length) end)
	task.wait(2)
	
	target.Parent=nil
	Status.Text="Complete"
	task.wait(2)
	visualInstance:Destroy()
	return text
end

function Module:Instal()
	Status.Text="Instal" 
	self:SetUpdate(2) 
	task.wait(2)
	if not InstalTarget and not Debounce then
		if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
		local newModel=InstanceNew("Model")
		newModel.Name="InstalModel"
		if BuildingTarget and not BuildingData[BuildingTarget] then BuildingData[BuildingTarget]=true end 
		BuildingTarget=nil
		if next(BuildingData) then
			local buildingModel=InstanceNew("Model") buildingModel.Name="Building" 
			for v,k in pairs(BuildingData) do local cv=v:Clone() cv.Parent=buildingModel end
			buildingModel.Parent=newModel
			InstalData["Building"]=buildingModel:GetChildren()
		end
		if GuiTarget and not GuiData[GuiTarget] then GuiData[GuiTarget]=true end 
		GuiTarget=nil
		if next(GuiData) then
			local guiModel=InstanceNew("Model") guiModel.Name="Gui"
			for v,k in pairs(GuiData) do local cv=v:Clone() cv.Parent=guiModel end
			guiModel.Parent=newModel
			InstalData["Gui"]=guiModel:GetChildren()
		end
		if ToolTarget then
			local toolModel=InstanceNew("Model") toolModel.Name="Tool" 
			local cv=ToolTarget:Clone() cv.Parent=toolModel
			toolModel.Parent=newModel
			InstalData["Tool"]=toolModel:GetChildren()
		end
		ToolTarget=nil
		if next(newModel:GetChildren()) then
			GrabberModel=newModel
			InstalTarget=newModel
		else
			newModel:Destroy()
			InstalData["Building"]=nil
			InstalData["Gui"]=nil
			InstalData["Tool"]=nil
		end
	end
	
	if not next(InstalData) or not InstalTarget then self:SetStatus(1,"Target Has Empty",2) return end
	
	if Debounce then return end
	Debounce=true

	if ContinueButton and ContinueButton.Parent then
		ContinueButton.Template.Visible=true
	end
	
	local success,result=true,self:Convert(InstalData,InstalTarget)
	if Destroyed then return end
	if success and type(result)=="string" then
		Status.Text="Text Length: "..#result
		task.wait(5)
		setclipboard(result)
		Status.Text="Copied To Clipboard!"
	else
		Status.Text="An Error Occured"
	end
	
	task.wait(10)
	Status.Text="Status"
	Loader.Text="(0/0) 0%"
	CanContinue=false
	if ContinueButton and ContinueButton.Parent then
		ContinueButton.Template.Visible=false
	end
	if GrabberModel then GrabberModel:Destroy() GrabberModel=nil end
	InstalData={}
	self:SetUpdate(1)
	task.wait(2)
	Debounce=false
end

function Module:Add()
	if IsStrings(GrabType,BannedGrabTypeList) then 
		self:SetStatus(1,"This type not allowed",2) 
		return 
	end
	if GrabType=="Building" then
		if not BuildingTarget then self:SetStatus(1,"Building Target Has Empty",2) return end
		if BuildingData[BuildingTarget] then self:SetStatus(1,"Building Already Added",2) return end
		BuildingData[BuildingTarget]=true
		BuildingTarget=nil
		if not GrabTypeData[GrabType] then GrabTypeData[GrabType]=true end
	elseif GrabType=="MouseIcon" then
		local newMouse=LocalPlayer:GetMouse()
		local mouseIconTarget=newMouse.Icon
		if not mouseIconTarget or #tostring(mouseIconTarget)==0 then self:SetStatus(1,"MouseIcon Target Has Empty",2) return end
		if MouseIconData[mouseIconTarget] then 
			self:SetStatus(1,"MouseIcon Already Added",2) 
			return 
		end
		MouseIconData[mouseIconTarget]=true
		if not GrabTypeData[GrabType] then GrabTypeData[GrabType]=true end
	elseif GrabType=="Tool" then
		local newCharacter=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local isTool=false
		for i,v in ipairs(newCharacter:GetChildren()) do if v:IsA("Tool") then isTool=true TableInsert(ToolData,v:Clone()) end end
		if not isTool then self:SetStatus(1,"Tool Target Has Empty",2) return end
		if not GrabTypeData[GrabType] then GrabTypeData[GrabType]=true end
	elseif GrabType=="Gui" then
		if not GuiTarget then self:SetStatus(1,"Gui Target Has Empty",2) return end
		if GuiData[GuiTarget] then self:SetStatus(1,"Gui Already Added",2) return end
		GuiData[GuiTarget]=true 
		GuiTarget=nil
		if not GrabTypeData[GrabType] then GrabTypeData[GrabType]=true end
	else
		if GrabTypeData[GrabType] then self:SetStatus(1,"Already Added",2) return end GrabTypeData[GrabType]=true
	end
	self:SetStatus(1,"Successfully",2)
end

function Module:Reset()
	self:SetUpdate(1)
end

function Module:Destroy()
	Destroyed=true
	Window:Destroy()
	Outliner:Destroy()
	self:SetUpdate(1)
	local k,v=next(Cache)
	while v do
		Cache[k]=nil
		v:Disconnect()
		k,v=next(Cache)
	end
end

-- Character
do
	local function OnCharacterToolAdded(character)
		if Cache.CharacterToolAdded then Cache.CharacterToolAdded:Disconnect() Cache.CharacterToolAdded=nil end
		Cache.CharacterToolAdded=character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then ToolTarget=child end
		end)
	end

	OnCharacterToolAdded(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
	Cache.CharacterAdded=LocalPlayer.CharacterAdded:Connect(OnCharacterToolAdded)
end

-- Grab Building
do
	Cache.MouseButton1Down=Mouse.Button1Down:Connect(function()
		if not IsInput and GrabType=="Building" then 
			local target=Mouse.Target
			if target then
				BuildingIndex=0
	
				local current=target
				while current and current.Parent and current.Parent~=workspace do
					current=current.Parent
					BuildingIndex=BuildingIndex+1 
					
					if TotalBuilding>0 and BuildingIndex>=TotalBuilding then
						target=current
						break
					end
				end
				
				if Window.Parent then
					MainLabel.Text="Building Index: " .. tostring(BuildingIndex)
					Status.Text=target.Name.." | "..target.ClassName.." | "..tostring(#target:GetChildren())
				end
				Module:SetUpdate(2,target)
				BuildingTarget=target
			else
				BuildingIndex=0
				if Window.Parent then
					MainLabel.Text="0"
					Status.Text="Status"
				end
				Module:SetUpdate(2)
				BuildingTarget=nil
			end
		end
	end)
end

Status=Window:AddContext({
	Type="TextLabel",
	Name="Status",
})

Loader=Window:AddContext({
	Type="TextLabel",
	Name="(0/0) 0%",
})

-- Selector UI
SelectorButton=Window:AddContext({
	Type="Selector",
	Options=GrabTypeList,
	Value=GrabTypeList[1],
	NoCap=true,
	Callback=function(value,key)
		GrabType=value
		Module:SetUpdate(3)
	end,
})

MainLabel=Window:AddContext({
	Type="TextLabel",
	Name="",
})

MainLabel.Template.Visible=false

-- TextBox UI
TextBox=Window:AddContext({
	Type="TextBox",
	PlaceholderText="Type here",
	Callback=function(text)
		local amount=tonumber(text)
		if amount then
			if GrabType=="Building" then 
				TotalBuilding=MathMax(amount,0)
				TextBox.Text=tostring(TotalBuilding)
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

-- Add UI
AddButton=Window:AddContext({
	Type="TextButton",
	Name="Add",
	Options=GrabTypeList,
	Callback=function()
		Module:Add()
	end,
})

-- Initialize UI
InitializeButton=Window:AddContext({
	Type="TextButton",
	Name="Initialize",
	Callback=function()
		Module.Initialize(Module)
	end,
})

InitializeButton.BackgroundColor3=Color3FromRGB(242,186,42)

-- Grab UI
InstalButton=Window:AddContext({
	Type="TextButton",
	Name="Instal",
	Callback=function()
		Module:Instal()
	end,
})

InstalButton.BackgroundColor3=Color3FromRGB(91,154,76)

-- Destroy UI
ContinueButton=Window:AddContext({
	Type="TextButton",
	Name="Continue",
	Callback=function()
		CanContinue=true
	end,
})

ContinueButton.BackgroundColor3=Color3FromRGB(13,105,172)
ContinueButton.Template.Visible=false

-- Reset UI
ResetButton=Window:AddContext({
	Type="TextButton",
	Name="Reset",
	Callback=function()
		Module:Reset()
	end,
})

ResetButton.BackgroundColor3=Color3FromRGB(255,89,89)

-- Destroy UI
DestroyButton=Window:AddContext({
	Type="TextButton",
	Name="Destroy",
	Callback=function()
		Module:Destroy()
	end,
})

DestroyButton.BackgroundColor3=Color3FromRGB(255,124,16)

local VersionLabel=Window:AddContext({
	Type="TextLabel",
	Name="Version: "..VERSION,
})
