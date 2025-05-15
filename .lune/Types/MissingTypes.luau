--!optimize 2
--!strict

local GreenTeaUtilities = require("@packages/GreenTeaUtilities")

export type PrimitiveTypes =
	| "nil"
	| "boolean"
	| "string"
	| "number"
	| "table"
	| "userdata"
	| "function"
	| "thread"
	| "vector"
	| "buffer"

export type CheckableTypes =
	| "nil"
	| "boolean"
	| "string"
	| "number"
	| "table"
	| "userdata"
	| "function"
	| "thread"
	| "vector"
	| "buffer"
	| "Axes"
	| "BrickColor"
	| "CFrame"
	| "Color3"
	| "ColorSequence"
	| "ColorSequenceKeypoint"
	| "DateTime"
	| "DockWidgetPluginGuiInfo"
	| "Enum"
	| "EnumItem"
	| "Enums"
	| "Faces"
	| "FloatCurveKey"
	| "Font"
	| "Instance"
	| "NumberRange"
	| "NumberSequence"
	| "NumberSequenceKeypoint"
	| "OverlapParams"
	| "PathWaypoint"
	| "PhysicalProperties"
	| "Random"
	| "Ray"
	| "RaycastParams"
	| "RaycastResult"
	| "RBXScriptConnection"
	| "RBXScriptSignal"
	| "Rect"
	| "Region3"
	| "Region3int16"
	| "TweenInfo"
	| "UDim"
	| "UDim2"
	| "Vector2"
	| "Vector2int16"
	| "Vector3"
	| "Vector3int16"

local MissingTypes = {
	CheckableTypes = GreenTeaUtilities.SmartLiteral(
		"nil",
		"boolean",
		"string",
		"number",
		"table",
		"userdata",
		"function",
		"thread",
		"vector",
		"buffer",
		"Axes",
		"BrickColor",
		"CFrame",
		"Color3",
		"ColorSequence",
		"ColorSequenceKeypoint",
		"DateTime",
		"DockWidgetPluginGuiInfo",
		"Enum",
		"EnumItem",
		"Enums",
		"Faces",
		"FloatCurveKey",
		"Font",
		"Instance",
		"NumberRange",
		"NumberSequence",
		"NumberSequenceKeypoint",
		"OverlapParams",
		"PathWaypoint",
		"PhysicalProperties",
		"Random",
		"Ray",
		"RaycastParams",
		"RaycastResult",
		"RBXScriptConnection",
		"RBXScriptSignal",
		"Rect",
		"Region3",
		"Region3int16",
		"TweenInfo",
		"UDim",
		"UDim2",
		"Vector2",
		"Vector2int16",
		"Vector3",
		"Vector3int16"
	) :: CheckableTypes;

	PrimitiveTypes = GreenTeaUtilities.SmartLiteral(
		"nil",
		"boolean",
		"string",
		"number",
		"table",
		"userdata",
		"function",
		"thread",
		"vector",
		"buffer"
	) :: PrimitiveTypes;
}

return table.freeze(MissingTypes)
