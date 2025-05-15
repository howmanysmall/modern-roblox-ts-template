--!nocheck
--!optimize 2

local Enum = require("@self/Enum")

type SimpleResult<T, E> = {
	Success: true,
	Value: T,
} | {
	Success: false,
	Error: E,
}

type EnumItem<Value, Type, Name = string> = {
	EnumType: Type,
	Name: Name,
	Value: Value,
}
type EnumObject<Values, ArrayValues> = {
	Cast: ((self: EnumObject<Values, ArrayValues>, check: unknown) -> ArrayValues)
		& ((self: EnumObject<Values, ArrayValues>, check: unknown) -> (false, string)),
	CastResult: (self: EnumObject<Values, ArrayValues>, check: unknown) -> SimpleResult<ArrayValues, string>,
	GetEnumItems: (self: EnumObject<Values, ArrayValues>) -> {ArrayValues},
} & Values

type Enums<Values, ArrayValues> = {
	GetEnums: (self: Enums<Values, ArrayValues>) -> {ArrayValues},
} & Values

export type AccessModifierType =
	| EnumItem<number, AccessModifierType, "Allow">
	| EnumItem<number, AccessModifierType, "Deny">
export type AccessModifierTypeRoot = EnumObject<{
	Allow: EnumItem<number, AccessModifierType, "Allow">,
	Deny: EnumItem<number, AccessModifierType, "Deny">,
}, AccessModifierType>
Enum.AccessModifierType = {"Allow", "Deny"}

export type AccessoryType =
	| EnumItem<number, AccessoryType, "Unknown">
	| EnumItem<number, AccessoryType, "Hat">
	| EnumItem<number, AccessoryType, "Hair">
	| EnumItem<number, AccessoryType, "Face">
	| EnumItem<number, AccessoryType, "Neck">
	| EnumItem<number, AccessoryType, "Shoulder">
	| EnumItem<number, AccessoryType, "Front">
	| EnumItem<number, AccessoryType, "Back">
	| EnumItem<number, AccessoryType, "Waist">
	| EnumItem<number, AccessoryType, "TShirt">
	| EnumItem<number, AccessoryType, "Shirt">
	| EnumItem<number, AccessoryType, "Pants">
	| EnumItem<number, AccessoryType, "Jacket">
	| EnumItem<number, AccessoryType, "Sweater">
	| EnumItem<number, AccessoryType, "Shorts">
	| EnumItem<number, AccessoryType, "LeftShoe">
	| EnumItem<number, AccessoryType, "RightShoe">
	| EnumItem<number, AccessoryType, "DressSkirt">
	| EnumItem<number, AccessoryType, "Eyebrow">
	| EnumItem<number, AccessoryType, "Eyelash">
export type AccessoryTypeRoot = EnumObject<{
	Unknown: EnumItem<number, AccessoryType, "Unknown">,
	Hat: EnumItem<number, AccessoryType, "Hat">,
	Hair: EnumItem<number, AccessoryType, "Hair">,
	Face: EnumItem<number, AccessoryType, "Face">,
	Neck: EnumItem<number, AccessoryType, "Neck">,
	Shoulder: EnumItem<number, AccessoryType, "Shoulder">,
	Front: EnumItem<number, AccessoryType, "Front">,
	Back: EnumItem<number, AccessoryType, "Back">,
	Waist: EnumItem<number, AccessoryType, "Waist">,
	TShirt: EnumItem<number, AccessoryType, "TShirt">,
	Shirt: EnumItem<number, AccessoryType, "Shirt">,
	Pants: EnumItem<number, AccessoryType, "Pants">,
	Jacket: EnumItem<number, AccessoryType, "Jacket">,
	Sweater: EnumItem<number, AccessoryType, "Sweater">,
	Shorts: EnumItem<number, AccessoryType, "Shorts">,
	LeftShoe: EnumItem<number, AccessoryType, "LeftShoe">,
	RightShoe: EnumItem<number, AccessoryType, "RightShoe">,
	DressSkirt: EnumItem<number, AccessoryType, "DressSkirt">,
	Eyebrow: EnumItem<number, AccessoryType, "Eyebrow">,
	Eyelash: EnumItem<number, AccessoryType, "Eyelash">,
}, AccessoryType>
Enum.AccessoryType = {
	"Unknown";
	"Hat";
	"Hair";
	"Face";
	"Neck";
	"Shoulder";
	"Front";
	"Back";
	"Waist";
	"TShirt";
	"Shirt";
	"Pants";
	"Jacket";
	"Sweater";
	"Shorts";
	"LeftShoe";
	"RightShoe";
	"DressSkirt";
	"Eyebrow";
	"Eyelash";
}

export type ActionOnAutoResumeSync =
	| EnumItem<number, ActionOnAutoResumeSync, "DontResume">
	| EnumItem<number, ActionOnAutoResumeSync, "KeepStudio">
	| EnumItem<number, ActionOnAutoResumeSync, "KeepLocal">
export type ActionOnAutoResumeSyncRoot = EnumObject<{
	DontResume: EnumItem<number, ActionOnAutoResumeSync, "DontResume">,
	KeepStudio: EnumItem<number, ActionOnAutoResumeSync, "KeepStudio">,
	KeepLocal: EnumItem<number, ActionOnAutoResumeSync, "KeepLocal">,
}, ActionOnAutoResumeSync>
Enum.ActionOnAutoResumeSync = {"DontResume", "KeepStudio", "KeepLocal"}

export type ActionOnStopSync =
	| EnumItem<number, ActionOnStopSync, "AlwaysAsk">
	| EnumItem<number, ActionOnStopSync, "KeepLocalFiles">
	| EnumItem<number, ActionOnStopSync, "DeleteLocalFiles">
export type ActionOnStopSyncRoot = EnumObject<{
	AlwaysAsk: EnumItem<number, ActionOnStopSync, "AlwaysAsk">,
	KeepLocalFiles: EnumItem<number, ActionOnStopSync, "KeepLocalFiles">,
	DeleteLocalFiles: EnumItem<number, ActionOnStopSync, "DeleteLocalFiles">,
}, ActionOnStopSync>
Enum.ActionOnStopSync = {"AlwaysAsk", "KeepLocalFiles", "DeleteLocalFiles"}

export type ActionType =
	| EnumItem<number, ActionType, "Nothing">
	| EnumItem<number, ActionType, "Pause">
	| EnumItem<number, ActionType, "Lose">
	| EnumItem<number, ActionType, "Draw">
	| EnumItem<number, ActionType, "Win">
export type ActionTypeRoot = EnumObject<{
	Nothing: EnumItem<number, ActionType, "Nothing">,
	Pause: EnumItem<number, ActionType, "Pause">,
	Lose: EnumItem<number, ActionType, "Lose">,
	Draw: EnumItem<number, ActionType, "Draw">,
	Win: EnumItem<number, ActionType, "Win">,
}, ActionType>
Enum.ActionType = {"Nothing", "Pause", "Lose", "Draw", "Win"}

export type ActuatorRelativeTo =
	| EnumItem<number, ActuatorRelativeTo, "Attachment0">
	| EnumItem<number, ActuatorRelativeTo, "Attachment1">
	| EnumItem<number, ActuatorRelativeTo, "World">
export type ActuatorRelativeToRoot = EnumObject<{
	Attachment0: EnumItem<number, ActuatorRelativeTo, "Attachment0">,
	Attachment1: EnumItem<number, ActuatorRelativeTo, "Attachment1">,
	World: EnumItem<number, ActuatorRelativeTo, "World">,
}, ActuatorRelativeTo>
Enum.ActuatorRelativeTo = {"Attachment0", "Attachment1", "World"}

export type ActuatorType =
	| EnumItem<number, ActuatorType, "None">
	| EnumItem<number, ActuatorType, "Motor">
	| EnumItem<number, ActuatorType, "Servo">
export type ActuatorTypeRoot = EnumObject<{
	None: EnumItem<number, ActuatorType, "None">,
	Motor: EnumItem<number, ActuatorType, "Motor">,
	Servo: EnumItem<number, ActuatorType, "Servo">,
}, ActuatorType>
Enum.ActuatorType = {"None", "Motor", "Servo"}

export type AdAvailabilityResult =
	| EnumItem<number, AdAvailabilityResult, "IsAvailable">
	| EnumItem<number, AdAvailabilityResult, "DeviceIneligible">
	| EnumItem<number, AdAvailabilityResult, "ExperienceIneligible">
	| EnumItem<number, AdAvailabilityResult, "InternalError">
	| EnumItem<number, AdAvailabilityResult, "NoFill">
	| EnumItem<number, AdAvailabilityResult, "PlayerIneligible">
	| EnumItem<number, AdAvailabilityResult, "PublisherIneligible">
export type AdAvailabilityResultRoot = EnumObject<{
	IsAvailable: EnumItem<number, AdAvailabilityResult, "IsAvailable">,
	DeviceIneligible: EnumItem<number, AdAvailabilityResult, "DeviceIneligible">,
	ExperienceIneligible: EnumItem<number, AdAvailabilityResult, "ExperienceIneligible">,
	InternalError: EnumItem<number, AdAvailabilityResult, "InternalError">,
	NoFill: EnumItem<number, AdAvailabilityResult, "NoFill">,
	PlayerIneligible: EnumItem<number, AdAvailabilityResult, "PlayerIneligible">,
	PublisherIneligible: EnumItem<number, AdAvailabilityResult, "PublisherIneligible">,
}, AdAvailabilityResult>
Enum.AdAvailabilityResult = {
	IsAvailable = 1;
	DeviceIneligible = 2;
	ExperienceIneligible = 3;
	InternalError = 4;
	NoFill = 5;
	PlayerIneligible = 6;
	PublisherIneligible = 7;
}

export type AdEventType =
	| EnumItem<number, AdEventType, "VideoLoaded">
	| EnumItem<number, AdEventType, "VideoRemoved">
	| EnumItem<number, AdEventType, "UserCompletedVideo">
	| EnumItem<number, AdEventType, "RewardedAdLoaded">
	| EnumItem<number, AdEventType, "RewardedAdGrant">
	| EnumItem<number, AdEventType, "RewardedAdUnloaded">
export type AdEventTypeRoot = EnumObject<{
	VideoLoaded: EnumItem<number, AdEventType, "VideoLoaded">,
	VideoRemoved: EnumItem<number, AdEventType, "VideoRemoved">,
	UserCompletedVideo: EnumItem<number, AdEventType, "UserCompletedVideo">,
	RewardedAdLoaded: EnumItem<number, AdEventType, "RewardedAdLoaded">,
	RewardedAdGrant: EnumItem<number, AdEventType, "RewardedAdGrant">,
	RewardedAdUnloaded: EnumItem<number, AdEventType, "RewardedAdUnloaded">,
}, AdEventType>
Enum.AdEventType =
	{"VideoLoaded", "VideoRemoved", "UserCompletedVideo", "RewardedAdLoaded", "RewardedAdGrant", "RewardedAdUnloaded"}

export type AdFormat = | EnumItem<number, AdFormat, "RewardedVideo">
export type AdFormatRoot = EnumObject<{
	RewardedVideo: EnumItem<number, AdFormat, "RewardedVideo">,
}, AdFormat>
Enum.AdFormat = {"RewardedVideo"}

export type AdShape = | EnumItem<number, AdShape, "HorizontalRectangle">
export type AdShapeRoot = EnumObject<{
	HorizontalRectangle: EnumItem<number, AdShape, "HorizontalRectangle">,
}, AdShape>
Enum.AdShape = {
	HorizontalRectangle = 1;
}

export type AdTeleportMethod =
	| EnumItem<number, AdTeleportMethod, "Undefined">
	| EnumItem<number, AdTeleportMethod, "PortalForward">
	| EnumItem<number, AdTeleportMethod, "InGameMenuBackButton">
	| EnumItem<number, AdTeleportMethod, "UIBackButton">
export type AdTeleportMethodRoot = EnumObject<{
	Undefined: EnumItem<number, AdTeleportMethod, "Undefined">,
	PortalForward: EnumItem<number, AdTeleportMethod, "PortalForward">,
	InGameMenuBackButton: EnumItem<number, AdTeleportMethod, "InGameMenuBackButton">,
	UIBackButton: EnumItem<number, AdTeleportMethod, "UIBackButton">,
}, AdTeleportMethod>
Enum.AdTeleportMethod = {"Undefined", "PortalForward", "InGameMenuBackButton", "UIBackButton"}

export type AdUIEventType =
	| EnumItem<number, AdUIEventType, "AdLabelClicked">
	| EnumItem<number, AdUIEventType, "VolumeButtonClicked">
	| EnumItem<number, AdUIEventType, "FullscreenButtonClicked">
	| EnumItem<number, AdUIEventType, "PlayButtonClicked">
	| EnumItem<number, AdUIEventType, "PauseButtonClicked">
	| EnumItem<number, AdUIEventType, "CloseButtonClicked">
	| EnumItem<number, AdUIEventType, "WhyThisAdClicked">
	| EnumItem<number, AdUIEventType, "PlayEventTriggered">
	| EnumItem<number, AdUIEventType, "PauseEventTriggered">
export type AdUIEventTypeRoot = EnumObject<{
	AdLabelClicked: EnumItem<number, AdUIEventType, "AdLabelClicked">,
	VolumeButtonClicked: EnumItem<number, AdUIEventType, "VolumeButtonClicked">,
	FullscreenButtonClicked: EnumItem<number, AdUIEventType, "FullscreenButtonClicked">,
	PlayButtonClicked: EnumItem<number, AdUIEventType, "PlayButtonClicked">,
	PauseButtonClicked: EnumItem<number, AdUIEventType, "PauseButtonClicked">,
	CloseButtonClicked: EnumItem<number, AdUIEventType, "CloseButtonClicked">,
	WhyThisAdClicked: EnumItem<number, AdUIEventType, "WhyThisAdClicked">,
	PlayEventTriggered: EnumItem<number, AdUIEventType, "PlayEventTriggered">,
	PauseEventTriggered: EnumItem<number, AdUIEventType, "PauseEventTriggered">,
}, AdUIEventType>
Enum.AdUIEventType = {
	"AdLabelClicked";
	"VolumeButtonClicked";
	"FullscreenButtonClicked";
	"PlayButtonClicked";
	"PauseButtonClicked";
	"CloseButtonClicked";
	"WhyThisAdClicked";
	"PlayEventTriggered";
	"PauseEventTriggered";
}

export type AdUIType =
	| EnumItem<number, AdUIType, "None">
	| EnumItem<number, AdUIType, "Image">
	| EnumItem<number, AdUIType, "Video">
export type AdUITypeRoot = EnumObject<{
	None: EnumItem<number, AdUIType, "None">,
	Image: EnumItem<number, AdUIType, "Image">,
	Video: EnumItem<number, AdUIType, "Video">,
}, AdUIType>
Enum.AdUIType = {"None", "Image", "Video"}

export type AdUnitStatus = | EnumItem<number, AdUnitStatus, "Inactive"> | EnumItem<number, AdUnitStatus, "Active">
export type AdUnitStatusRoot = EnumObject<{
	Inactive: EnumItem<number, AdUnitStatus, "Inactive">,
	Active: EnumItem<number, AdUnitStatus, "Active">,
}, AdUnitStatus>
Enum.AdUnitStatus = {"Inactive", "Active"}

export type AdornCullingMode =
	| EnumItem<number, AdornCullingMode, "Automatic">
	| EnumItem<number, AdornCullingMode, "Never">
export type AdornCullingModeRoot = EnumObject<{
	Automatic: EnumItem<number, AdornCullingMode, "Automatic">,
	Never: EnumItem<number, AdornCullingMode, "Never">,
}, AdornCullingMode>
Enum.AdornCullingMode = {"Automatic", "Never"}

export type AlignType =
	| EnumItem<number, AlignType, "Parallel">
	| EnumItem<number, AlignType, "Perpendicular">
	| EnumItem<number, AlignType, "PrimaryAxisParallel">
	| EnumItem<number, AlignType, "PrimaryAxisPerpendicular">
	| EnumItem<number, AlignType, "PrimaryAxisLookAt">
	| EnumItem<number, AlignType, "AllAxes">
export type AlignTypeRoot = EnumObject<{
	Parallel: EnumItem<number, AlignType, "Parallel">,
	Perpendicular: EnumItem<number, AlignType, "Perpendicular">,
	PrimaryAxisParallel: EnumItem<number, AlignType, "PrimaryAxisParallel">,
	PrimaryAxisPerpendicular: EnumItem<number, AlignType, "PrimaryAxisPerpendicular">,
	PrimaryAxisLookAt: EnumItem<number, AlignType, "PrimaryAxisLookAt">,
	AllAxes: EnumItem<number, AlignType, "AllAxes">,
}, AlignType>
Enum.AlignType =
	{"Parallel", "Perpendicular", "PrimaryAxisParallel", "PrimaryAxisPerpendicular", "PrimaryAxisLookAt", "AllAxes"}

export type AlphaMode =
	| EnumItem<number, AlphaMode, "Overlay">
	| EnumItem<number, AlphaMode, "Transparency">
	| EnumItem<number, AlphaMode, "TintMask">
export type AlphaModeRoot = EnumObject<{
	Overlay: EnumItem<number, AlphaMode, "Overlay">,
	Transparency: EnumItem<number, AlphaMode, "Transparency">,
	TintMask: EnumItem<number, AlphaMode, "TintMask">,
}, AlphaMode>
Enum.AlphaMode = {"Overlay", "Transparency", "TintMask"}

export type AnalyticsCustomFieldKeys =
	| EnumItem<number, AnalyticsCustomFieldKeys, "CustomField01">
	| EnumItem<number, AnalyticsCustomFieldKeys, "CustomField02">
	| EnumItem<number, AnalyticsCustomFieldKeys, "CustomField03">
export type AnalyticsCustomFieldKeysRoot = EnumObject<{
	CustomField01: EnumItem<number, AnalyticsCustomFieldKeys, "CustomField01">,
	CustomField02: EnumItem<number, AnalyticsCustomFieldKeys, "CustomField02">,
	CustomField03: EnumItem<number, AnalyticsCustomFieldKeys, "CustomField03">,
}, AnalyticsCustomFieldKeys>
Enum.AnalyticsCustomFieldKeys = {"CustomField01", "CustomField02", "CustomField03"}

export type AnalyticsEconomyAction =
	| EnumItem<number, AnalyticsEconomyAction, "Default">
	| EnumItem<number, AnalyticsEconomyAction, "Acquire">
	| EnumItem<number, AnalyticsEconomyAction, "Spend">
export type AnalyticsEconomyActionRoot = EnumObject<{
	Default: EnumItem<number, AnalyticsEconomyAction, "Default">,
	Acquire: EnumItem<number, AnalyticsEconomyAction, "Acquire">,
	Spend: EnumItem<number, AnalyticsEconomyAction, "Spend">,
}, AnalyticsEconomyAction>
Enum.AnalyticsEconomyAction = {"Default", "Acquire", "Spend"}

export type AnalyticsEconomyFlowType =
	| EnumItem<number, AnalyticsEconomyFlowType, "Sink">
	| EnumItem<number, AnalyticsEconomyFlowType, "Source">
export type AnalyticsEconomyFlowTypeRoot = EnumObject<{
	Sink: EnumItem<number, AnalyticsEconomyFlowType, "Sink">,
	Source: EnumItem<number, AnalyticsEconomyFlowType, "Source">,
}, AnalyticsEconomyFlowType>
Enum.AnalyticsEconomyFlowType = {"Sink", "Source"}

export type AnalyticsEconomyTransactionType =
	| EnumItem<number, AnalyticsEconomyTransactionType, "IAP">
	| EnumItem<number, AnalyticsEconomyTransactionType, "Shop">
	| EnumItem<number, AnalyticsEconomyTransactionType, "Gameplay">
	| EnumItem<number, AnalyticsEconomyTransactionType, "ContextualPurchase">
	| EnumItem<number, AnalyticsEconomyTransactionType, "TimedReward">
	| EnumItem<number, AnalyticsEconomyTransactionType, "Onboarding">
export type AnalyticsEconomyTransactionTypeRoot = EnumObject<{
	IAP: EnumItem<number, AnalyticsEconomyTransactionType, "IAP">,
	Shop: EnumItem<number, AnalyticsEconomyTransactionType, "Shop">,
	Gameplay: EnumItem<number, AnalyticsEconomyTransactionType, "Gameplay">,
	ContextualPurchase: EnumItem<number, AnalyticsEconomyTransactionType, "ContextualPurchase">,
	TimedReward: EnumItem<number, AnalyticsEconomyTransactionType, "TimedReward">,
	Onboarding: EnumItem<number, AnalyticsEconomyTransactionType, "Onboarding">,
}, AnalyticsEconomyTransactionType>
Enum.AnalyticsEconomyTransactionType = {"IAP", "Shop", "Gameplay", "ContextualPurchase", "TimedReward", "Onboarding"}

export type AnalyticsLogLevel =
	| EnumItem<number, AnalyticsLogLevel, "Trace">
	| EnumItem<number, AnalyticsLogLevel, "Debug">
	| EnumItem<number, AnalyticsLogLevel, "Information">
	| EnumItem<number, AnalyticsLogLevel, "Warning">
	| EnumItem<number, AnalyticsLogLevel, "Error">
	| EnumItem<number, AnalyticsLogLevel, "Fatal">
export type AnalyticsLogLevelRoot = EnumObject<{
	Trace: EnumItem<number, AnalyticsLogLevel, "Trace">,
	Debug: EnumItem<number, AnalyticsLogLevel, "Debug">,
	Information: EnumItem<number, AnalyticsLogLevel, "Information">,
	Warning: EnumItem<number, AnalyticsLogLevel, "Warning">,
	Error: EnumItem<number, AnalyticsLogLevel, "Error">,
	Fatal: EnumItem<number, AnalyticsLogLevel, "Fatal">,
}, AnalyticsLogLevel>
Enum.AnalyticsLogLevel = {"Trace", "Debug", "Information", "Warning", "Error", "Fatal"}

export type AnalyticsProgressionStatus =
	| EnumItem<number, AnalyticsProgressionStatus, "Default">
	| EnumItem<number, AnalyticsProgressionStatus, "Begin">
	| EnumItem<number, AnalyticsProgressionStatus, "Complete">
	| EnumItem<number, AnalyticsProgressionStatus, "Abandon">
	| EnumItem<number, AnalyticsProgressionStatus, "Fail">
export type AnalyticsProgressionStatusRoot = EnumObject<{
	Default: EnumItem<number, AnalyticsProgressionStatus, "Default">,
	Begin: EnumItem<number, AnalyticsProgressionStatus, "Begin">,
	Complete: EnumItem<number, AnalyticsProgressionStatus, "Complete">,
	Abandon: EnumItem<number, AnalyticsProgressionStatus, "Abandon">,
	Fail: EnumItem<number, AnalyticsProgressionStatus, "Fail">,
}, AnalyticsProgressionStatus>
Enum.AnalyticsProgressionStatus = {"Default", "Begin", "Complete", "Abandon", "Fail"}

export type AnalyticsProgressionType =
	| EnumItem<number, AnalyticsProgressionType, "Custom">
	| EnumItem<number, AnalyticsProgressionType, "Start">
	| EnumItem<number, AnalyticsProgressionType, "Fail">
	| EnumItem<number, AnalyticsProgressionType, "Complete">
export type AnalyticsProgressionTypeRoot = EnumObject<{
	Custom: EnumItem<number, AnalyticsProgressionType, "Custom">,
	Start: EnumItem<number, AnalyticsProgressionType, "Start">,
	Fail: EnumItem<number, AnalyticsProgressionType, "Fail">,
	Complete: EnumItem<number, AnalyticsProgressionType, "Complete">,
}, AnalyticsProgressionType>
Enum.AnalyticsProgressionType = {"Custom", "Start", "Fail", "Complete"}

export type AnimationClipFromVideoStatus =
	| EnumItem<number, AnimationClipFromVideoStatus, "Initializing">
	| EnumItem<number, AnimationClipFromVideoStatus, "Pending">
	| EnumItem<number, AnimationClipFromVideoStatus, "Processing">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorGeneric">
	| EnumItem<number, AnimationClipFromVideoStatus, "Success">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorVideoTooLong">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorNoPersonDetected">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorVideoUnstable">
	| EnumItem<number, AnimationClipFromVideoStatus, "Timeout">
	| EnumItem<number, AnimationClipFromVideoStatus, "Cancelled">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorMultiplePeople">
	| EnumItem<number, AnimationClipFromVideoStatus, "ErrorUploadingVideo">
export type AnimationClipFromVideoStatusRoot = EnumObject<{
	Initializing: EnumItem<number, AnimationClipFromVideoStatus, "Initializing">,
	Pending: EnumItem<number, AnimationClipFromVideoStatus, "Pending">,
	Processing: EnumItem<number, AnimationClipFromVideoStatus, "Processing">,
	ErrorGeneric: EnumItem<number, AnimationClipFromVideoStatus, "ErrorGeneric">,
	Success: EnumItem<number, AnimationClipFromVideoStatus, "Success">,
	ErrorVideoTooLong: EnumItem<number, AnimationClipFromVideoStatus, "ErrorVideoTooLong">,
	ErrorNoPersonDetected: EnumItem<number, AnimationClipFromVideoStatus, "ErrorNoPersonDetected">,
	ErrorVideoUnstable: EnumItem<number, AnimationClipFromVideoStatus, "ErrorVideoUnstable">,
	Timeout: EnumItem<number, AnimationClipFromVideoStatus, "Timeout">,
	Cancelled: EnumItem<number, AnimationClipFromVideoStatus, "Cancelled">,
	ErrorMultiplePeople: EnumItem<number, AnimationClipFromVideoStatus, "ErrorMultiplePeople">,
	ErrorUploadingVideo: EnumItem<number, AnimationClipFromVideoStatus, "ErrorUploadingVideo">,
}, AnimationClipFromVideoStatus>
Enum.AnimationClipFromVideoStatus = {
	Initializing = 0;
	Pending = 1;
	Processing = 2;
	ErrorGeneric = 4;
	Success = 6;
	ErrorVideoTooLong = 7;
	ErrorNoPersonDetected = 8;
	ErrorVideoUnstable = 9;
	Timeout = 10;
	Cancelled = 11;
	ErrorMultiplePeople = 12;
	ErrorUploadingVideo = 2001;
}

export type AnimationPriority =
	| EnumItem<number, AnimationPriority, "Idle">
	| EnumItem<number, AnimationPriority, "Movement">
	| EnumItem<number, AnimationPriority, "Action">
	| EnumItem<number, AnimationPriority, "Action2">
	| EnumItem<number, AnimationPriority, "Action3">
	| EnumItem<number, AnimationPriority, "Action4">
	| EnumItem<number, AnimationPriority, "Core">
export type AnimationPriorityRoot = EnumObject<{
	Idle: EnumItem<number, AnimationPriority, "Idle">,
	Movement: EnumItem<number, AnimationPriority, "Movement">,
	Action: EnumItem<number, AnimationPriority, "Action">,
	Action2: EnumItem<number, AnimationPriority, "Action2">,
	Action3: EnumItem<number, AnimationPriority, "Action3">,
	Action4: EnumItem<number, AnimationPriority, "Action4">,
	Core: EnumItem<number, AnimationPriority, "Core">,
}, AnimationPriority>
Enum.AnimationPriority = {
	Idle = 0;
	Movement = 1;
	Action = 2;
	Action2 = 3;
	Action3 = 4;
	Action4 = 5;
	Core = 1000;
}

export type AnimatorRetargetingMode =
	| EnumItem<number, AnimatorRetargetingMode, "Default">
	| EnumItem<number, AnimatorRetargetingMode, "Disabled">
	| EnumItem<number, AnimatorRetargetingMode, "Enabled">
export type AnimatorRetargetingModeRoot = EnumObject<{
	Default: EnumItem<number, AnimatorRetargetingMode, "Default">,
	Disabled: EnumItem<number, AnimatorRetargetingMode, "Disabled">,
	Enabled: EnumItem<number, AnimatorRetargetingMode, "Enabled">,
}, AnimatorRetargetingMode>
Enum.AnimatorRetargetingMode = {"Default", "Disabled", "Enabled"}

export type AnnotationEditingMode =
	| EnumItem<number, AnnotationEditingMode, "None">
	| EnumItem<number, AnnotationEditingMode, "PlacingNew">
	| EnumItem<number, AnnotationEditingMode, "WritingNew">
export type AnnotationEditingModeRoot = EnumObject<{
	None: EnumItem<number, AnnotationEditingMode, "None">,
	PlacingNew: EnumItem<number, AnnotationEditingMode, "PlacingNew">,
	WritingNew: EnumItem<number, AnnotationEditingMode, "WritingNew">,
}, AnnotationEditingMode>
Enum.AnnotationEditingMode = {"None", "PlacingNew", "WritingNew"}

export type AnnotationRequestStatus =
	| EnumItem<number, AnnotationRequestStatus, "Success">
	| EnumItem<number, AnnotationRequestStatus, "Loading">
	| EnumItem<number, AnnotationRequestStatus, "ErrorInternalFailure">
	| EnumItem<number, AnnotationRequestStatus, "ErrorNotFound">
	| EnumItem<number, AnnotationRequestStatus, "ErrorModerated">
export type AnnotationRequestStatusRoot = EnumObject<{
	Success: EnumItem<number, AnnotationRequestStatus, "Success">,
	Loading: EnumItem<number, AnnotationRequestStatus, "Loading">,
	ErrorInternalFailure: EnumItem<number, AnnotationRequestStatus, "ErrorInternalFailure">,
	ErrorNotFound: EnumItem<number, AnnotationRequestStatus, "ErrorNotFound">,
	ErrorModerated: EnumItem<number, AnnotationRequestStatus, "ErrorModerated">,
}, AnnotationRequestStatus>
Enum.AnnotationRequestStatus = {"Success", "Loading", "ErrorInternalFailure", "ErrorNotFound", "ErrorModerated"}

export type AnnotationRequestType =
	| EnumItem<number, AnnotationRequestType, "Unknown">
	| EnumItem<number, AnnotationRequestType, "Create">
	| EnumItem<number, AnnotationRequestType, "Resolve">
	| EnumItem<number, AnnotationRequestType, "Delete">
	| EnumItem<number, AnnotationRequestType, "Edit">
export type AnnotationRequestTypeRoot = EnumObject<{
	Unknown: EnumItem<number, AnnotationRequestType, "Unknown">,
	Create: EnumItem<number, AnnotationRequestType, "Create">,
	Resolve: EnumItem<number, AnnotationRequestType, "Resolve">,
	Delete: EnumItem<number, AnnotationRequestType, "Delete">,
	Edit: EnumItem<number, AnnotationRequestType, "Edit">,
}, AnnotationRequestType>
Enum.AnnotationRequestType = {"Unknown", "Create", "Resolve", "Delete", "Edit"}

export type AppLifecycleManagerState =
	| EnumItem<number, AppLifecycleManagerState, "Detached">
	| EnumItem<number, AppLifecycleManagerState, "Active">
	| EnumItem<number, AppLifecycleManagerState, "Inactive">
	| EnumItem<number, AppLifecycleManagerState, "Hidden">
export type AppLifecycleManagerStateRoot = EnumObject<{
	Detached: EnumItem<number, AppLifecycleManagerState, "Detached">,
	Active: EnumItem<number, AppLifecycleManagerState, "Active">,
	Inactive: EnumItem<number, AppLifecycleManagerState, "Inactive">,
	Hidden: EnumItem<number, AppLifecycleManagerState, "Hidden">,
}, AppLifecycleManagerState>
Enum.AppLifecycleManagerState = {"Detached", "Active", "Inactive", "Hidden"}

export type AppShellActionType =
	| EnumItem<number, AppShellActionType, "None">
	| EnumItem<number, AppShellActionType, "OpenApp">
	| EnumItem<number, AppShellActionType, "TapChatTab">
	| EnumItem<number, AppShellActionType, "TapConversationEntry">
	| EnumItem<number, AppShellActionType, "TapAvatarTab">
	| EnumItem<number, AppShellActionType, "ReadConversation">
	| EnumItem<number, AppShellActionType, "TapGamePageTab">
	| EnumItem<number, AppShellActionType, "TapHomePageTab">
	| EnumItem<number, AppShellActionType, "GamePageLoaded">
	| EnumItem<number, AppShellActionType, "HomePageLoaded">
	| EnumItem<number, AppShellActionType, "AvatarEditorPageLoaded">
export type AppShellActionTypeRoot = EnumObject<{
	None: EnumItem<number, AppShellActionType, "None">,
	OpenApp: EnumItem<number, AppShellActionType, "OpenApp">,
	TapChatTab: EnumItem<number, AppShellActionType, "TapChatTab">,
	TapConversationEntry: EnumItem<number, AppShellActionType, "TapConversationEntry">,
	TapAvatarTab: EnumItem<number, AppShellActionType, "TapAvatarTab">,
	ReadConversation: EnumItem<number, AppShellActionType, "ReadConversation">,
	TapGamePageTab: EnumItem<number, AppShellActionType, "TapGamePageTab">,
	TapHomePageTab: EnumItem<number, AppShellActionType, "TapHomePageTab">,
	GamePageLoaded: EnumItem<number, AppShellActionType, "GamePageLoaded">,
	HomePageLoaded: EnumItem<number, AppShellActionType, "HomePageLoaded">,
	AvatarEditorPageLoaded: EnumItem<number, AppShellActionType, "AvatarEditorPageLoaded">,
}, AppShellActionType>
Enum.AppShellActionType = {
	"None";
	"OpenApp";
	"TapChatTab";
	"TapConversationEntry";
	"TapAvatarTab";
	"ReadConversation";
	"TapGamePageTab";
	"TapHomePageTab";
	"GamePageLoaded";
	"HomePageLoaded";
	"AvatarEditorPageLoaded";
}

export type AppShellFeature =
	| EnumItem<number, AppShellFeature, "None">
	| EnumItem<number, AppShellFeature, "Chat">
	| EnumItem<number, AppShellFeature, "AvatarEditor">
	| EnumItem<number, AppShellFeature, "GamePage">
	| EnumItem<number, AppShellFeature, "HomePage">
	| EnumItem<number, AppShellFeature, "More">
	| EnumItem<number, AppShellFeature, "Landing">
export type AppShellFeatureRoot = EnumObject<{
	None: EnumItem<number, AppShellFeature, "None">,
	Chat: EnumItem<number, AppShellFeature, "Chat">,
	AvatarEditor: EnumItem<number, AppShellFeature, "AvatarEditor">,
	GamePage: EnumItem<number, AppShellFeature, "GamePage">,
	HomePage: EnumItem<number, AppShellFeature, "HomePage">,
	More: EnumItem<number, AppShellFeature, "More">,
	Landing: EnumItem<number, AppShellFeature, "Landing">,
}, AppShellFeature>
Enum.AppShellFeature = {"None", "Chat", "AvatarEditor", "GamePage", "HomePage", "More", "Landing"}

export type AppUpdateStatus =
	| EnumItem<number, AppUpdateStatus, "Unknown">
	| EnumItem<number, AppUpdateStatus, "NotSupported">
	| EnumItem<number, AppUpdateStatus, "Failed">
	| EnumItem<number, AppUpdateStatus, "NotAvailable">
	| EnumItem<number, AppUpdateStatus, "Available">
	| EnumItem<number, AppUpdateStatus, "AvailableBoundChannel">
export type AppUpdateStatusRoot = EnumObject<{
	Unknown: EnumItem<number, AppUpdateStatus, "Unknown">,
	NotSupported: EnumItem<number, AppUpdateStatus, "NotSupported">,
	Failed: EnumItem<number, AppUpdateStatus, "Failed">,
	NotAvailable: EnumItem<number, AppUpdateStatus, "NotAvailable">,
	Available: EnumItem<number, AppUpdateStatus, "Available">,
	AvailableBoundChannel: EnumItem<number, AppUpdateStatus, "AvailableBoundChannel">,
}, AppUpdateStatus>
Enum.AppUpdateStatus = {"Unknown", "NotSupported", "Failed", "NotAvailable", "Available", "AvailableBoundChannel"}

export type ApplyStrokeMode =
	| EnumItem<number, ApplyStrokeMode, "Contextual">
	| EnumItem<number, ApplyStrokeMode, "Border">
export type ApplyStrokeModeRoot = EnumObject<{
	Contextual: EnumItem<number, ApplyStrokeMode, "Contextual">,
	Border: EnumItem<number, ApplyStrokeMode, "Border">,
}, ApplyStrokeMode>
Enum.ApplyStrokeMode = {"Contextual", "Border"}

export type AspectType =
	| EnumItem<number, AspectType, "FitWithinMaxSize">
	| EnumItem<number, AspectType, "ScaleWithParentSize">
export type AspectTypeRoot = EnumObject<{
	FitWithinMaxSize: EnumItem<number, AspectType, "FitWithinMaxSize">,
	ScaleWithParentSize: EnumItem<number, AspectType, "ScaleWithParentSize">,
}, AspectType>
Enum.AspectType = {"FitWithinMaxSize", "ScaleWithParentSize"}

export type AssetCreatorType = | EnumItem<number, AssetCreatorType, "User"> | EnumItem<number, AssetCreatorType, "Group">
export type AssetCreatorTypeRoot = EnumObject<{
	User: EnumItem<number, AssetCreatorType, "User">,
	Group: EnumItem<number, AssetCreatorType, "Group">,
}, AssetCreatorType>
Enum.AssetCreatorType = {"User", "Group"}

export type AssetFetchStatus =
	| EnumItem<number, AssetFetchStatus, "Success">
	| EnumItem<number, AssetFetchStatus, "Failure">
	| EnumItem<number, AssetFetchStatus, "None">
	| EnumItem<number, AssetFetchStatus, "Loading">
	| EnumItem<number, AssetFetchStatus, "TimedOut">
export type AssetFetchStatusRoot = EnumObject<{
	Success: EnumItem<number, AssetFetchStatus, "Success">,
	Failure: EnumItem<number, AssetFetchStatus, "Failure">,
	None: EnumItem<number, AssetFetchStatus, "None">,
	Loading: EnumItem<number, AssetFetchStatus, "Loading">,
	TimedOut: EnumItem<number, AssetFetchStatus, "TimedOut">,
}, AssetFetchStatus>
Enum.AssetFetchStatus = {"Success", "Failure", "None", "Loading", "TimedOut"}

export type AssetType =
	| EnumItem<number, AssetType, "Image">
	| EnumItem<number, AssetType, "TShirt">
	| EnumItem<number, AssetType, "Audio">
	| EnumItem<number, AssetType, "Mesh">
	| EnumItem<number, AssetType, "Lua">
	| EnumItem<number, AssetType, "Hat">
	| EnumItem<number, AssetType, "Place">
	| EnumItem<number, AssetType, "Model">
	| EnumItem<number, AssetType, "Shirt">
	| EnumItem<number, AssetType, "Pants">
	| EnumItem<number, AssetType, "Decal">
	| EnumItem<number, AssetType, "Head">
	| EnumItem<number, AssetType, "Face">
	| EnumItem<number, AssetType, "Gear">
	| EnumItem<number, AssetType, "Badge">
	| EnumItem<number, AssetType, "Animation">
	| EnumItem<number, AssetType, "Torso">
	| EnumItem<number, AssetType, "RightArm">
	| EnumItem<number, AssetType, "LeftArm">
	| EnumItem<number, AssetType, "LeftLeg">
	| EnumItem<number, AssetType, "RightLeg">
	| EnumItem<number, AssetType, "Package">
	| EnumItem<number, AssetType, "GamePass">
	| EnumItem<number, AssetType, "Plugin">
	| EnumItem<number, AssetType, "MeshPart">
	| EnumItem<number, AssetType, "HairAccessory">
	| EnumItem<number, AssetType, "FaceAccessory">
	| EnumItem<number, AssetType, "NeckAccessory">
	| EnumItem<number, AssetType, "ShoulderAccessory">
	| EnumItem<number, AssetType, "FrontAccessory">
	| EnumItem<number, AssetType, "BackAccessory">
	| EnumItem<number, AssetType, "WaistAccessory">
	| EnumItem<number, AssetType, "ClimbAnimation">
	| EnumItem<number, AssetType, "DeathAnimation">
	| EnumItem<number, AssetType, "FallAnimation">
	| EnumItem<number, AssetType, "IdleAnimation">
	| EnumItem<number, AssetType, "JumpAnimation">
	| EnumItem<number, AssetType, "RunAnimation">
	| EnumItem<number, AssetType, "SwimAnimation">
	| EnumItem<number, AssetType, "WalkAnimation">
	| EnumItem<number, AssetType, "PoseAnimation">
	| EnumItem<number, AssetType, "EarAccessory">
	| EnumItem<number, AssetType, "EyeAccessory">
	| EnumItem<number, AssetType, "EmoteAnimation">
	| EnumItem<number, AssetType, "Video">
	| EnumItem<number, AssetType, "TShirtAccessory">
	| EnumItem<number, AssetType, "ShirtAccessory">
	| EnumItem<number, AssetType, "PantsAccessory">
	| EnumItem<number, AssetType, "JacketAccessory">
	| EnumItem<number, AssetType, "SweaterAccessory">
	| EnumItem<number, AssetType, "ShortsAccessory">
	| EnumItem<number, AssetType, "LeftShoeAccessory">
	| EnumItem<number, AssetType, "RightShoeAccessory">
	| EnumItem<number, AssetType, "DressSkirtAccessory">
	| EnumItem<number, AssetType, "FontFamily">
	| EnumItem<number, AssetType, "EyebrowAccessory">
	| EnumItem<number, AssetType, "EyelashAccessory">
	| EnumItem<number, AssetType, "MoodAnimation">
	| EnumItem<number, AssetType, "DynamicHead">
export type AssetTypeRoot = EnumObject<{
	Image: EnumItem<number, AssetType, "Image">,
	TShirt: EnumItem<number, AssetType, "TShirt">,
	Audio: EnumItem<number, AssetType, "Audio">,
	Mesh: EnumItem<number, AssetType, "Mesh">,
	Lua: EnumItem<number, AssetType, "Lua">,
	Hat: EnumItem<number, AssetType, "Hat">,
	Place: EnumItem<number, AssetType, "Place">,
	Model: EnumItem<number, AssetType, "Model">,
	Shirt: EnumItem<number, AssetType, "Shirt">,
	Pants: EnumItem<number, AssetType, "Pants">,
	Decal: EnumItem<number, AssetType, "Decal">,
	Head: EnumItem<number, AssetType, "Head">,
	Face: EnumItem<number, AssetType, "Face">,
	Gear: EnumItem<number, AssetType, "Gear">,
	Badge: EnumItem<number, AssetType, "Badge">,
	Animation: EnumItem<number, AssetType, "Animation">,
	Torso: EnumItem<number, AssetType, "Torso">,
	RightArm: EnumItem<number, AssetType, "RightArm">,
	LeftArm: EnumItem<number, AssetType, "LeftArm">,
	LeftLeg: EnumItem<number, AssetType, "LeftLeg">,
	RightLeg: EnumItem<number, AssetType, "RightLeg">,
	Package: EnumItem<number, AssetType, "Package">,
	GamePass: EnumItem<number, AssetType, "GamePass">,
	Plugin: EnumItem<number, AssetType, "Plugin">,
	MeshPart: EnumItem<number, AssetType, "MeshPart">,
	HairAccessory: EnumItem<number, AssetType, "HairAccessory">,
	FaceAccessory: EnumItem<number, AssetType, "FaceAccessory">,
	NeckAccessory: EnumItem<number, AssetType, "NeckAccessory">,
	ShoulderAccessory: EnumItem<number, AssetType, "ShoulderAccessory">,
	FrontAccessory: EnumItem<number, AssetType, "FrontAccessory">,
	BackAccessory: EnumItem<number, AssetType, "BackAccessory">,
	WaistAccessory: EnumItem<number, AssetType, "WaistAccessory">,
	ClimbAnimation: EnumItem<number, AssetType, "ClimbAnimation">,
	DeathAnimation: EnumItem<number, AssetType, "DeathAnimation">,
	FallAnimation: EnumItem<number, AssetType, "FallAnimation">,
	IdleAnimation: EnumItem<number, AssetType, "IdleAnimation">,
	JumpAnimation: EnumItem<number, AssetType, "JumpAnimation">,
	RunAnimation: EnumItem<number, AssetType, "RunAnimation">,
	SwimAnimation: EnumItem<number, AssetType, "SwimAnimation">,
	WalkAnimation: EnumItem<number, AssetType, "WalkAnimation">,
	PoseAnimation: EnumItem<number, AssetType, "PoseAnimation">,
	EarAccessory: EnumItem<number, AssetType, "EarAccessory">,
	EyeAccessory: EnumItem<number, AssetType, "EyeAccessory">,
	EmoteAnimation: EnumItem<number, AssetType, "EmoteAnimation">,
	Video: EnumItem<number, AssetType, "Video">,
	TShirtAccessory: EnumItem<number, AssetType, "TShirtAccessory">,
	ShirtAccessory: EnumItem<number, AssetType, "ShirtAccessory">,
	PantsAccessory: EnumItem<number, AssetType, "PantsAccessory">,
	JacketAccessory: EnumItem<number, AssetType, "JacketAccessory">,
	SweaterAccessory: EnumItem<number, AssetType, "SweaterAccessory">,
	ShortsAccessory: EnumItem<number, AssetType, "ShortsAccessory">,
	LeftShoeAccessory: EnumItem<number, AssetType, "LeftShoeAccessory">,
	RightShoeAccessory: EnumItem<number, AssetType, "RightShoeAccessory">,
	DressSkirtAccessory: EnumItem<number, AssetType, "DressSkirtAccessory">,
	FontFamily: EnumItem<number, AssetType, "FontFamily">,
	EyebrowAccessory: EnumItem<number, AssetType, "EyebrowAccessory">,
	EyelashAccessory: EnumItem<number, AssetType, "EyelashAccessory">,
	MoodAnimation: EnumItem<number, AssetType, "MoodAnimation">,
	DynamicHead: EnumItem<number, AssetType, "DynamicHead">,
}, AssetType>
Enum.AssetType = {
	Image = 1;
	TShirt = 2;
	Audio = 3;
	Mesh = 4;
	Lua = 5;
	Hat = 8;
	Place = 9;
	Model = 10;
	Shirt = 11;
	Pants = 12;
	Decal = 13;
	Head = 17;
	Face = 18;
	Gear = 19;
	Badge = 21;
	Animation = 24;
	Torso = 27;
	RightArm = 28;
	LeftArm = 29;
	LeftLeg = 30;
	RightLeg = 31;
	Package = 32;
	GamePass = 34;
	Plugin = 38;
	MeshPart = 40;
	HairAccessory = 41;
	FaceAccessory = 42;
	NeckAccessory = 43;
	ShoulderAccessory = 44;
	FrontAccessory = 45;
	BackAccessory = 46;
	WaistAccessory = 47;
	ClimbAnimation = 48;
	DeathAnimation = 49;
	FallAnimation = 50;
	IdleAnimation = 51;
	JumpAnimation = 52;
	RunAnimation = 53;
	SwimAnimation = 54;
	WalkAnimation = 55;
	PoseAnimation = 56;
	EarAccessory = 57;
	EyeAccessory = 58;
	EmoteAnimation = 61;
	Video = 62;
	TShirtAccessory = 64;
	ShirtAccessory = 65;
	PantsAccessory = 66;
	JacketAccessory = 67;
	SweaterAccessory = 68;
	ShortsAccessory = 69;
	LeftShoeAccessory = 70;
	RightShoeAccessory = 71;
	DressSkirtAccessory = 72;
	FontFamily = 73;
	EyebrowAccessory = 76;
	EyelashAccessory = 77;
	MoodAnimation = 78;
	DynamicHead = 79;
}

export type AssetTypeVerification =
	| EnumItem<number, AssetTypeVerification, "Default">
	| EnumItem<number, AssetTypeVerification, "ClientOnly">
	| EnumItem<number, AssetTypeVerification, "Always">
export type AssetTypeVerificationRoot = EnumObject<{
	Default: EnumItem<number, AssetTypeVerification, "Default">,
	ClientOnly: EnumItem<number, AssetTypeVerification, "ClientOnly">,
	Always: EnumItem<number, AssetTypeVerification, "Always">,
}, AssetTypeVerification>
Enum.AssetTypeVerification = {
	Default = 1;
	ClientOnly = 2;
	Always = 3;
}

export type AudioApiRollout =
	| EnumItem<number, AudioApiRollout, "Disabled">
	| EnumItem<number, AudioApiRollout, "Automatic">
	| EnumItem<number, AudioApiRollout, "Enabled">
export type AudioApiRolloutRoot = EnumObject<{
	Disabled: EnumItem<number, AudioApiRollout, "Disabled">,
	Automatic: EnumItem<number, AudioApiRollout, "Automatic">,
	Enabled: EnumItem<number, AudioApiRollout, "Enabled">,
}, AudioApiRollout>
Enum.AudioApiRollout = {"Disabled", "Automatic", "Enabled"}

export type AudioCaptureMode = export
type AudioCaptureModeRoot = EnumObject<{}, AudioCaptureMode>
Enum.AudioCaptureMode = {}

export type AudioChannelLayout =
	| EnumItem<number, AudioChannelLayout, "Mono">
	| EnumItem<number, AudioChannelLayout, "Stereo">
	| EnumItem<number, AudioChannelLayout, "Quad">
	| EnumItem<number, AudioChannelLayout, "Surround_5">
	| EnumItem<number, AudioChannelLayout, "Surround_5_1">
	| EnumItem<number, AudioChannelLayout, "Surround_7_1">
	| EnumItem<number, AudioChannelLayout, "Surround_7_1_4">
export type AudioChannelLayoutRoot = EnumObject<{
	Mono: EnumItem<number, AudioChannelLayout, "Mono">,
	Stereo: EnumItem<number, AudioChannelLayout, "Stereo">,
	Quad: EnumItem<number, AudioChannelLayout, "Quad">,
	Surround_5: EnumItem<number, AudioChannelLayout, "Surround_5">,
	Surround_5_1: EnumItem<number, AudioChannelLayout, "Surround_5_1">,
	Surround_7_1: EnumItem<number, AudioChannelLayout, "Surround_7_1">,
	Surround_7_1_4: EnumItem<number, AudioChannelLayout, "Surround_7_1_4">,
}, AudioChannelLayout>
Enum.AudioChannelLayout = {"Mono", "Stereo", "Quad", "Surround_5", "Surround_5_1", "Surround_7_1", "Surround_7_1_4"}

export type AudioFilterType =
	| EnumItem<number, AudioFilterType, "Peak">
	| EnumItem<number, AudioFilterType, "LowShelf">
	| EnumItem<number, AudioFilterType, "HighShelf">
	| EnumItem<number, AudioFilterType, "Lowpass12dB">
	| EnumItem<number, AudioFilterType, "Lowpass24dB">
	| EnumItem<number, AudioFilterType, "Lowpass48dB">
	| EnumItem<number, AudioFilterType, "Highpass12dB">
	| EnumItem<number, AudioFilterType, "Highpass24dB">
	| EnumItem<number, AudioFilterType, "Highpass48dB">
	| EnumItem<number, AudioFilterType, "Bandpass">
	| EnumItem<number, AudioFilterType, "Notch">
	| EnumItem<number, AudioFilterType, "Lowpass6dB">
export type AudioFilterTypeRoot = EnumObject<{
	Peak: EnumItem<number, AudioFilterType, "Peak">,
	LowShelf: EnumItem<number, AudioFilterType, "LowShelf">,
	HighShelf: EnumItem<number, AudioFilterType, "HighShelf">,
	Lowpass12dB: EnumItem<number, AudioFilterType, "Lowpass12dB">,
	Lowpass24dB: EnumItem<number, AudioFilterType, "Lowpass24dB">,
	Lowpass48dB: EnumItem<number, AudioFilterType, "Lowpass48dB">,
	Highpass12dB: EnumItem<number, AudioFilterType, "Highpass12dB">,
	Highpass24dB: EnumItem<number, AudioFilterType, "Highpass24dB">,
	Highpass48dB: EnumItem<number, AudioFilterType, "Highpass48dB">,
	Bandpass: EnumItem<number, AudioFilterType, "Bandpass">,
	Notch: EnumItem<number, AudioFilterType, "Notch">,
	Lowpass6dB: EnumItem<number, AudioFilterType, "Lowpass6dB">,
}, AudioFilterType>
Enum.AudioFilterType = {
	"Peak";
	"LowShelf";
	"HighShelf";
	"Lowpass12dB";
	"Lowpass24dB";
	"Lowpass48dB";
	"Highpass12dB";
	"Highpass24dB";
	"Highpass48dB";
	"Bandpass";
	"Notch";
	"Lowpass6dB";
}

export type AudioSimulationFidelity =
	| EnumItem<number, AudioSimulationFidelity, "None">
	| EnumItem<number, AudioSimulationFidelity, "Automatic">
export type AudioSimulationFidelityRoot = EnumObject<{
	None: EnumItem<number, AudioSimulationFidelity, "None">,
	Automatic: EnumItem<number, AudioSimulationFidelity, "Automatic">,
}, AudioSimulationFidelity>
Enum.AudioSimulationFidelity = {"None", "Automatic"}

export type AudioSubType = | EnumItem<number, AudioSubType, "Music"> | EnumItem<number, AudioSubType, "SoundEffect">
export type AudioSubTypeRoot = EnumObject<{
	Music: EnumItem<number, AudioSubType, "Music">,
	SoundEffect: EnumItem<number, AudioSubType, "SoundEffect">,
}, AudioSubType>
Enum.AudioSubType = {
	Music = 1;
	SoundEffect = 2;
}

export type AudioWindowSize =
	| EnumItem<number, AudioWindowSize, "Small">
	| EnumItem<number, AudioWindowSize, "Medium">
	| EnumItem<number, AudioWindowSize, "Large">
export type AudioWindowSizeRoot = EnumObject<{
	Small: EnumItem<number, AudioWindowSize, "Small">,
	Medium: EnumItem<number, AudioWindowSize, "Medium">,
	Large: EnumItem<number, AudioWindowSize, "Large">,
}, AudioWindowSize>
Enum.AudioWindowSize = {"Small", "Medium", "Large"}

export type AutoIndentRule =
	| EnumItem<number, AutoIndentRule, "Off">
	| EnumItem<number, AutoIndentRule, "Absolute">
	| EnumItem<number, AutoIndentRule, "Relative">
export type AutoIndentRuleRoot = EnumObject<{
	Off: EnumItem<number, AutoIndentRule, "Off">,
	Absolute: EnumItem<number, AutoIndentRule, "Absolute">,
	Relative: EnumItem<number, AutoIndentRule, "Relative">,
}, AutoIndentRule>
Enum.AutoIndentRule = {"Off", "Absolute", "Relative"}

export type AutomaticSize =
	| EnumItem<number, AutomaticSize, "None">
	| EnumItem<number, AutomaticSize, "X">
	| EnumItem<number, AutomaticSize, "Y">
	| EnumItem<number, AutomaticSize, "XY">
export type AutomaticSizeRoot = EnumObject<{
	None: EnumItem<number, AutomaticSize, "None">,
	X: EnumItem<number, AutomaticSize, "X">,
	Y: EnumItem<number, AutomaticSize, "Y">,
	XY: EnumItem<number, AutomaticSize, "XY">,
}, AutomaticSize>
Enum.AutomaticSize = {"None", "X", "Y", "XY"}

export type AvatarAssetType =
	| EnumItem<number, AvatarAssetType, "TShirt">
	| EnumItem<number, AvatarAssetType, "Hat">
	| EnumItem<number, AvatarAssetType, "Shirt">
	| EnumItem<number, AvatarAssetType, "Pants">
	| EnumItem<number, AvatarAssetType, "Head">
	| EnumItem<number, AvatarAssetType, "Face">
	| EnumItem<number, AvatarAssetType, "Gear">
	| EnumItem<number, AvatarAssetType, "Torso">
	| EnumItem<number, AvatarAssetType, "RightArm">
	| EnumItem<number, AvatarAssetType, "LeftArm">
	| EnumItem<number, AvatarAssetType, "LeftLeg">
	| EnumItem<number, AvatarAssetType, "RightLeg">
	| EnumItem<number, AvatarAssetType, "HairAccessory">
	| EnumItem<number, AvatarAssetType, "FaceAccessory">
	| EnumItem<number, AvatarAssetType, "NeckAccessory">
	| EnumItem<number, AvatarAssetType, "ShoulderAccessory">
	| EnumItem<number, AvatarAssetType, "FrontAccessory">
	| EnumItem<number, AvatarAssetType, "BackAccessory">
	| EnumItem<number, AvatarAssetType, "WaistAccessory">
	| EnumItem<number, AvatarAssetType, "ClimbAnimation">
	| EnumItem<number, AvatarAssetType, "FallAnimation">
	| EnumItem<number, AvatarAssetType, "IdleAnimation">
	| EnumItem<number, AvatarAssetType, "JumpAnimation">
	| EnumItem<number, AvatarAssetType, "RunAnimation">
	| EnumItem<number, AvatarAssetType, "SwimAnimation">
	| EnumItem<number, AvatarAssetType, "WalkAnimation">
	| EnumItem<number, AvatarAssetType, "EmoteAnimation">
	| EnumItem<number, AvatarAssetType, "TShirtAccessory">
	| EnumItem<number, AvatarAssetType, "ShirtAccessory">
	| EnumItem<number, AvatarAssetType, "PantsAccessory">
	| EnumItem<number, AvatarAssetType, "JacketAccessory">
	| EnumItem<number, AvatarAssetType, "SweaterAccessory">
	| EnumItem<number, AvatarAssetType, "ShortsAccessory">
	| EnumItem<number, AvatarAssetType, "LeftShoeAccessory">
	| EnumItem<number, AvatarAssetType, "RightShoeAccessory">
	| EnumItem<number, AvatarAssetType, "DressSkirtAccessory">
	| EnumItem<number, AvatarAssetType, "EyebrowAccessory">
	| EnumItem<number, AvatarAssetType, "EyelashAccessory">
	| EnumItem<number, AvatarAssetType, "MoodAnimation">
	| EnumItem<number, AvatarAssetType, "DynamicHead">
export type AvatarAssetTypeRoot = EnumObject<{
	TShirt: EnumItem<number, AvatarAssetType, "TShirt">,
	Hat: EnumItem<number, AvatarAssetType, "Hat">,
	Shirt: EnumItem<number, AvatarAssetType, "Shirt">,
	Pants: EnumItem<number, AvatarAssetType, "Pants">,
	Head: EnumItem<number, AvatarAssetType, "Head">,
	Face: EnumItem<number, AvatarAssetType, "Face">,
	Gear: EnumItem<number, AvatarAssetType, "Gear">,
	Torso: EnumItem<number, AvatarAssetType, "Torso">,
	RightArm: EnumItem<number, AvatarAssetType, "RightArm">,
	LeftArm: EnumItem<number, AvatarAssetType, "LeftArm">,
	LeftLeg: EnumItem<number, AvatarAssetType, "LeftLeg">,
	RightLeg: EnumItem<number, AvatarAssetType, "RightLeg">,
	HairAccessory: EnumItem<number, AvatarAssetType, "HairAccessory">,
	FaceAccessory: EnumItem<number, AvatarAssetType, "FaceAccessory">,
	NeckAccessory: EnumItem<number, AvatarAssetType, "NeckAccessory">,
	ShoulderAccessory: EnumItem<number, AvatarAssetType, "ShoulderAccessory">,
	FrontAccessory: EnumItem<number, AvatarAssetType, "FrontAccessory">,
	BackAccessory: EnumItem<number, AvatarAssetType, "BackAccessory">,
	WaistAccessory: EnumItem<number, AvatarAssetType, "WaistAccessory">,
	ClimbAnimation: EnumItem<number, AvatarAssetType, "ClimbAnimation">,
	FallAnimation: EnumItem<number, AvatarAssetType, "FallAnimation">,
	IdleAnimation: EnumItem<number, AvatarAssetType, "IdleAnimation">,
	JumpAnimation: EnumItem<number, AvatarAssetType, "JumpAnimation">,
	RunAnimation: EnumItem<number, AvatarAssetType, "RunAnimation">,
	SwimAnimation: EnumItem<number, AvatarAssetType, "SwimAnimation">,
	WalkAnimation: EnumItem<number, AvatarAssetType, "WalkAnimation">,
	EmoteAnimation: EnumItem<number, AvatarAssetType, "EmoteAnimation">,
	TShirtAccessory: EnumItem<number, AvatarAssetType, "TShirtAccessory">,
	ShirtAccessory: EnumItem<number, AvatarAssetType, "ShirtAccessory">,
	PantsAccessory: EnumItem<number, AvatarAssetType, "PantsAccessory">,
	JacketAccessory: EnumItem<number, AvatarAssetType, "JacketAccessory">,
	SweaterAccessory: EnumItem<number, AvatarAssetType, "SweaterAccessory">,
	ShortsAccessory: EnumItem<number, AvatarAssetType, "ShortsAccessory">,
	LeftShoeAccessory: EnumItem<number, AvatarAssetType, "LeftShoeAccessory">,
	RightShoeAccessory: EnumItem<number, AvatarAssetType, "RightShoeAccessory">,
	DressSkirtAccessory: EnumItem<number, AvatarAssetType, "DressSkirtAccessory">,
	EyebrowAccessory: EnumItem<number, AvatarAssetType, "EyebrowAccessory">,
	EyelashAccessory: EnumItem<number, AvatarAssetType, "EyelashAccessory">,
	MoodAnimation: EnumItem<number, AvatarAssetType, "MoodAnimation">,
	DynamicHead: EnumItem<number, AvatarAssetType, "DynamicHead">,
}, AvatarAssetType>
Enum.AvatarAssetType = {
	TShirt = 2;
	Hat = 8;
	Shirt = 11;
	Pants = 12;
	Head = 17;
	Face = 18;
	Gear = 19;
	Torso = 27;
	RightArm = 28;
	LeftArm = 29;
	LeftLeg = 30;
	RightLeg = 31;
	HairAccessory = 41;
	FaceAccessory = 42;
	NeckAccessory = 43;
	ShoulderAccessory = 44;
	FrontAccessory = 45;
	BackAccessory = 46;
	WaistAccessory = 47;
	ClimbAnimation = 48;
	FallAnimation = 50;
	IdleAnimation = 51;
	JumpAnimation = 52;
	RunAnimation = 53;
	SwimAnimation = 54;
	WalkAnimation = 55;
	EmoteAnimation = 61;
	TShirtAccessory = 64;
	ShirtAccessory = 65;
	PantsAccessory = 66;
	JacketAccessory = 67;
	SweaterAccessory = 68;
	ShortsAccessory = 69;
	LeftShoeAccessory = 70;
	RightShoeAccessory = 71;
	DressSkirtAccessory = 72;
	EyebrowAccessory = 76;
	EyelashAccessory = 77;
	MoodAnimation = 78;
	DynamicHead = 79;
}

export type AvatarChatServiceFeature =
	| EnumItem<number, AvatarChatServiceFeature, "None">
	| EnumItem<number, AvatarChatServiceFeature, "UniverseAudio">
	| EnumItem<number, AvatarChatServiceFeature, "UniverseVideo">
	| EnumItem<number, AvatarChatServiceFeature, "PlaceAudio">
	| EnumItem<number, AvatarChatServiceFeature, "PlaceVideo">
	| EnumItem<number, AvatarChatServiceFeature, "UserAudioEligible">
	| EnumItem<number, AvatarChatServiceFeature, "UserAudio">
	| EnumItem<number, AvatarChatServiceFeature, "UserVideoEligible">
	| EnumItem<number, AvatarChatServiceFeature, "UserVideo">
	| EnumItem<number, AvatarChatServiceFeature, "UserBanned">
	| EnumItem<number, AvatarChatServiceFeature, "UserVerifiedForVoice">
export type AvatarChatServiceFeatureRoot = EnumObject<{
	None: EnumItem<number, AvatarChatServiceFeature, "None">,
	UniverseAudio: EnumItem<number, AvatarChatServiceFeature, "UniverseAudio">,
	UniverseVideo: EnumItem<number, AvatarChatServiceFeature, "UniverseVideo">,
	PlaceAudio: EnumItem<number, AvatarChatServiceFeature, "PlaceAudio">,
	PlaceVideo: EnumItem<number, AvatarChatServiceFeature, "PlaceVideo">,
	UserAudioEligible: EnumItem<number, AvatarChatServiceFeature, "UserAudioEligible">,
	UserAudio: EnumItem<number, AvatarChatServiceFeature, "UserAudio">,
	UserVideoEligible: EnumItem<number, AvatarChatServiceFeature, "UserVideoEligible">,
	UserVideo: EnumItem<number, AvatarChatServiceFeature, "UserVideo">,
	UserBanned: EnumItem<number, AvatarChatServiceFeature, "UserBanned">,
	UserVerifiedForVoice: EnumItem<number, AvatarChatServiceFeature, "UserVerifiedForVoice">,
}, AvatarChatServiceFeature>
Enum.AvatarChatServiceFeature = {
	None = 0;
	UniverseAudio = 1;
	UniverseVideo = 2;
	PlaceAudio = 4;
	PlaceVideo = 8;
	UserAudioEligible = 16;
	UserAudio = 32;
	UserVideoEligible = 64;
	UserVideo = 128;
	UserBanned = 256;
	UserVerifiedForVoice = 512;
}

export type AvatarContextMenuOption =
	| EnumItem<number, AvatarContextMenuOption, "Friend">
	| EnumItem<number, AvatarContextMenuOption, "Chat">
	| EnumItem<number, AvatarContextMenuOption, "Emote">
	| EnumItem<number, AvatarContextMenuOption, "InspectMenu">
export type AvatarContextMenuOptionRoot = EnumObject<{
	Friend: EnumItem<number, AvatarContextMenuOption, "Friend">,
	Chat: EnumItem<number, AvatarContextMenuOption, "Chat">,
	Emote: EnumItem<number, AvatarContextMenuOption, "Emote">,
	InspectMenu: EnumItem<number, AvatarContextMenuOption, "InspectMenu">,
}, AvatarContextMenuOption>
Enum.AvatarContextMenuOption = {"Friend", "Chat", "Emote", "InspectMenu"}

export type AvatarGenerationError =
	| EnumItem<number, AvatarGenerationError, "None">
	| EnumItem<number, AvatarGenerationError, "Unknown">
	| EnumItem<number, AvatarGenerationError, "DownloadFailed">
	| EnumItem<number, AvatarGenerationError, "Canceled">
	| EnumItem<number, AvatarGenerationError, "Offensive">
	| EnumItem<number, AvatarGenerationError, "Timeout">
	| EnumItem<number, AvatarGenerationError, "JobNotFound">
export type AvatarGenerationErrorRoot = EnumObject<{
	None: EnumItem<number, AvatarGenerationError, "None">,
	Unknown: EnumItem<number, AvatarGenerationError, "Unknown">,
	DownloadFailed: EnumItem<number, AvatarGenerationError, "DownloadFailed">,
	Canceled: EnumItem<number, AvatarGenerationError, "Canceled">,
	Offensive: EnumItem<number, AvatarGenerationError, "Offensive">,
	Timeout: EnumItem<number, AvatarGenerationError, "Timeout">,
	JobNotFound: EnumItem<number, AvatarGenerationError, "JobNotFound">,
}, AvatarGenerationError>
Enum.AvatarGenerationError = {"None", "Unknown", "DownloadFailed", "Canceled", "Offensive", "Timeout", "JobNotFound"}

export type AvatarItemType = | EnumItem<number, AvatarItemType, "Asset"> | EnumItem<number, AvatarItemType, "Bundle">
export type AvatarItemTypeRoot = EnumObject<{
	Asset: EnumItem<number, AvatarItemType, "Asset">,
	Bundle: EnumItem<number, AvatarItemType, "Bundle">,
}, AvatarItemType>
Enum.AvatarItemType = {
	Asset = 1;
	Bundle = 2;
}

export type AvatarPromptResult =
	| EnumItem<number, AvatarPromptResult, "Success">
	| EnumItem<number, AvatarPromptResult, "PermissionDenied">
	| EnumItem<number, AvatarPromptResult, "Failed">
export type AvatarPromptResultRoot = EnumObject<{
	Success: EnumItem<number, AvatarPromptResult, "Success">,
	PermissionDenied: EnumItem<number, AvatarPromptResult, "PermissionDenied">,
	Failed: EnumItem<number, AvatarPromptResult, "Failed">,
}, AvatarPromptResult>
Enum.AvatarPromptResult = {
	Success = 1;
	PermissionDenied = 2;
	Failed = 3;
}

export type AvatarSettingsAccessoryLimitMethod =
	| EnumItem<number, AvatarSettingsAccessoryLimitMethod, "Scale">
	| EnumItem<number, AvatarSettingsAccessoryLimitMethod, "Remove">
export type AvatarSettingsAccessoryLimitMethodRoot = EnumObject<{
	Scale: EnumItem<number, AvatarSettingsAccessoryLimitMethod, "Scale">,
	Remove: EnumItem<number, AvatarSettingsAccessoryLimitMethod, "Remove">,
}, AvatarSettingsAccessoryLimitMethod>
Enum.AvatarSettingsAccessoryLimitMethod = {"Scale", "Remove"}

export type AvatarSettingsAccessoryMode =
	| EnumItem<number, AvatarSettingsAccessoryMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsAccessoryMode, "CustomLimit">
export type AvatarSettingsAccessoryModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsAccessoryMode, "PlayerChoice">,
	CustomLimit: EnumItem<number, AvatarSettingsAccessoryMode, "CustomLimit">,
}, AvatarSettingsAccessoryMode>
Enum.AvatarSettingsAccessoryMode = {"PlayerChoice", "CustomLimit"}

export type AvatarSettingsAnimationClipsMode =
	| EnumItem<number, AvatarSettingsAnimationClipsMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsAnimationClipsMode, "CustomClips">
export type AvatarSettingsAnimationClipsModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsAnimationClipsMode, "PlayerChoice">,
	CustomClips: EnumItem<number, AvatarSettingsAnimationClipsMode, "CustomClips">,
}, AvatarSettingsAnimationClipsMode>
Enum.AvatarSettingsAnimationClipsMode = {"PlayerChoice", "CustomClips"}

export type AvatarSettingsAnimationPacksMode =
	| EnumItem<number, AvatarSettingsAnimationPacksMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsAnimationPacksMode, "StandardR15">
	| EnumItem<number, AvatarSettingsAnimationPacksMode, "StandardR6">
export type AvatarSettingsAnimationPacksModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsAnimationPacksMode, "PlayerChoice">,
	StandardR15: EnumItem<number, AvatarSettingsAnimationPacksMode, "StandardR15">,
	StandardR6: EnumItem<number, AvatarSettingsAnimationPacksMode, "StandardR6">,
}, AvatarSettingsAnimationPacksMode>
Enum.AvatarSettingsAnimationPacksMode = {"PlayerChoice", "StandardR15", "StandardR6"}

export type AvatarSettingsAppearanceMode =
	| EnumItem<number, AvatarSettingsAppearanceMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsAppearanceMode, "CustomParts">
	| EnumItem<number, AvatarSettingsAppearanceMode, "CustomBody">
export type AvatarSettingsAppearanceModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsAppearanceMode, "PlayerChoice">,
	CustomParts: EnumItem<number, AvatarSettingsAppearanceMode, "CustomParts">,
	CustomBody: EnumItem<number, AvatarSettingsAppearanceMode, "CustomBody">,
}, AvatarSettingsAppearanceMode>
Enum.AvatarSettingsAppearanceMode = {"PlayerChoice", "CustomParts", "CustomBody"}

export type AvatarSettingsBuildMode =
	| EnumItem<number, AvatarSettingsBuildMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsBuildMode, "CustomBuild">
export type AvatarSettingsBuildModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsBuildMode, "PlayerChoice">,
	CustomBuild: EnumItem<number, AvatarSettingsBuildMode, "CustomBuild">,
}, AvatarSettingsBuildMode>
Enum.AvatarSettingsBuildMode = {"PlayerChoice", "CustomBuild"}

export type AvatarSettingsClothingMode =
	| EnumItem<number, AvatarSettingsClothingMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsClothingMode, "CustomLimit">
export type AvatarSettingsClothingModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsClothingMode, "PlayerChoice">,
	CustomLimit: EnumItem<number, AvatarSettingsClothingMode, "CustomLimit">,
}, AvatarSettingsClothingMode>
Enum.AvatarSettingsClothingMode = {"PlayerChoice", "CustomLimit"}

export type AvatarSettingsCollisionMode =
	| EnumItem<number, AvatarSettingsCollisionMode, "Default">
	| EnumItem<number, AvatarSettingsCollisionMode, "SingleCollider">
	| EnumItem<number, AvatarSettingsCollisionMode, "Legacy">
export type AvatarSettingsCollisionModeRoot = EnumObject<{
	Default: EnumItem<number, AvatarSettingsCollisionMode, "Default">,
	SingleCollider: EnumItem<number, AvatarSettingsCollisionMode, "SingleCollider">,
	Legacy: EnumItem<number, AvatarSettingsCollisionMode, "Legacy">,
}, AvatarSettingsCollisionMode>
Enum.AvatarSettingsCollisionMode = {"Default", "SingleCollider", "Legacy"}

export type AvatarSettingsCustomAccessoryMode =
	| EnumItem<number, AvatarSettingsCustomAccessoryMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsCustomAccessoryMode, "CustomAccessories">
export type AvatarSettingsCustomAccessoryModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsCustomAccessoryMode, "PlayerChoice">,
	CustomAccessories: EnumItem<number, AvatarSettingsCustomAccessoryMode, "CustomAccessories">,
}, AvatarSettingsCustomAccessoryMode>
Enum.AvatarSettingsCustomAccessoryMode = {"PlayerChoice", "CustomAccessories"}

export type AvatarSettingsCustomBodyType =
	| EnumItem<number, AvatarSettingsCustomBodyType, "AvatarReference">
	| EnumItem<number, AvatarSettingsCustomBodyType, "BundleId">
export type AvatarSettingsCustomBodyTypeRoot = EnumObject<{
	AvatarReference: EnumItem<number, AvatarSettingsCustomBodyType, "AvatarReference">,
	BundleId: EnumItem<number, AvatarSettingsCustomBodyType, "BundleId">,
}, AvatarSettingsCustomBodyType>
Enum.AvatarSettingsCustomBodyType = {"AvatarReference", "BundleId"}

export type AvatarSettingsCustomClothingMode =
	| EnumItem<number, AvatarSettingsCustomClothingMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsCustomClothingMode, "CustomClothing">
export type AvatarSettingsCustomClothingModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsCustomClothingMode, "PlayerChoice">,
	CustomClothing: EnumItem<number, AvatarSettingsCustomClothingMode, "CustomClothing">,
}, AvatarSettingsCustomClothingMode>
Enum.AvatarSettingsCustomClothingMode = {"PlayerChoice", "CustomClothing"}

export type AvatarSettingsHitAndTouchDetectionMode =
	| EnumItem<number, AvatarSettingsHitAndTouchDetectionMode, "UseParts">
	| EnumItem<number, AvatarSettingsHitAndTouchDetectionMode, "UseCollider">
export type AvatarSettingsHitAndTouchDetectionModeRoot = EnumObject<{
	UseParts: EnumItem<number, AvatarSettingsHitAndTouchDetectionMode, "UseParts">,
	UseCollider: EnumItem<number, AvatarSettingsHitAndTouchDetectionMode, "UseCollider">,
}, AvatarSettingsHitAndTouchDetectionMode>
Enum.AvatarSettingsHitAndTouchDetectionMode = {"UseParts", "UseCollider"}

export type AvatarSettingsJumpMode =
	| EnumItem<number, AvatarSettingsJumpMode, "JumpHeight">
	| EnumItem<number, AvatarSettingsJumpMode, "JumpPower">
export type AvatarSettingsJumpModeRoot = EnumObject<{
	JumpHeight: EnumItem<number, AvatarSettingsJumpMode, "JumpHeight">,
	JumpPower: EnumItem<number, AvatarSettingsJumpMode, "JumpPower">,
}, AvatarSettingsJumpMode>
Enum.AvatarSettingsJumpMode = {"JumpHeight", "JumpPower"}

export type AvatarSettingsLegacyCollisionMode =
	| EnumItem<number, AvatarSettingsLegacyCollisionMode, "R6Colliders">
	| EnumItem<number, AvatarSettingsLegacyCollisionMode, "InnerBoxColliders">
export type AvatarSettingsLegacyCollisionModeRoot = EnumObject<{
	R6Colliders: EnumItem<number, AvatarSettingsLegacyCollisionMode, "R6Colliders">,
	InnerBoxColliders: EnumItem<number, AvatarSettingsLegacyCollisionMode, "InnerBoxColliders">,
}, AvatarSettingsLegacyCollisionMode>
Enum.AvatarSettingsLegacyCollisionMode = {"R6Colliders", "InnerBoxColliders"}

export type AvatarSettingsScaleMode =
	| EnumItem<number, AvatarSettingsScaleMode, "PlayerChoice">
	| EnumItem<number, AvatarSettingsScaleMode, "CustomScale">
export type AvatarSettingsScaleModeRoot = EnumObject<{
	PlayerChoice: EnumItem<number, AvatarSettingsScaleMode, "PlayerChoice">,
	CustomScale: EnumItem<number, AvatarSettingsScaleMode, "CustomScale">,
}, AvatarSettingsScaleMode>
Enum.AvatarSettingsScaleMode = {"PlayerChoice", "CustomScale"}

export type AvatarThumbnailCustomizationType =
	| EnumItem<number, AvatarThumbnailCustomizationType, "Closeup">
	| EnumItem<number, AvatarThumbnailCustomizationType, "FullBody">
export type AvatarThumbnailCustomizationTypeRoot = EnumObject<{
	Closeup: EnumItem<number, AvatarThumbnailCustomizationType, "Closeup">,
	FullBody: EnumItem<number, AvatarThumbnailCustomizationType, "FullBody">,
}, AvatarThumbnailCustomizationType>
Enum.AvatarThumbnailCustomizationType = {
	Closeup = 1;
	FullBody = 2;
}

export type AvatarUnificationMode =
	| EnumItem<number, AvatarUnificationMode, "Default">
	| EnumItem<number, AvatarUnificationMode, "Disabled">
	| EnumItem<number, AvatarUnificationMode, "Enabled">
export type AvatarUnificationModeRoot = EnumObject<{
	Default: EnumItem<number, AvatarUnificationMode, "Default">,
	Disabled: EnumItem<number, AvatarUnificationMode, "Disabled">,
	Enabled: EnumItem<number, AvatarUnificationMode, "Enabled">,
}, AvatarUnificationMode>
Enum.AvatarUnificationMode = {"Default", "Disabled", "Enabled"}

export type Axis = | EnumItem<number, Axis, "X"> | EnumItem<number, Axis, "Y"> | EnumItem<number, Axis, "Z">
export type AxisRoot = EnumObject<{
	X: EnumItem<number, Axis, "X">,
	Y: EnumItem<number, Axis, "Y">,
	Z: EnumItem<number, Axis, "Z">,
}, Axis>
Enum.Axis = {"X", "Y", "Z"}

export type BenefitType =
	| EnumItem<number, BenefitType, "DeveloperProduct">
	| EnumItem<number, BenefitType, "AvatarAsset">
	| EnumItem<number, BenefitType, "AvatarBundle">
export type BenefitTypeRoot = EnumObject<{
	DeveloperProduct: EnumItem<number, BenefitType, "DeveloperProduct">,
	AvatarAsset: EnumItem<number, BenefitType, "AvatarAsset">,
	AvatarBundle: EnumItem<number, BenefitType, "AvatarBundle">,
}, BenefitType>
Enum.BenefitType = {"DeveloperProduct", "AvatarAsset", "AvatarBundle"}

export type BinType =
	| EnumItem<number, BinType, "Script">
	| EnumItem<number, BinType, "GameTool">
	| EnumItem<number, BinType, "Grab">
	| EnumItem<number, BinType, "Clone">
	| EnumItem<number, BinType, "Hammer">
export type BinTypeRoot = EnumObject<{
	Script: EnumItem<number, BinType, "Script">,
	GameTool: EnumItem<number, BinType, "GameTool">,
	Grab: EnumItem<number, BinType, "Grab">,
	Clone: EnumItem<number, BinType, "Clone">,
	Hammer: EnumItem<number, BinType, "Hammer">,
}, BinType>
Enum.BinType = {"Script", "GameTool", "Grab", "Clone", "Hammer"}

export type BodyPart =
	| EnumItem<number, BodyPart, "Head">
	| EnumItem<number, BodyPart, "Torso">
	| EnumItem<number, BodyPart, "LeftArm">
	| EnumItem<number, BodyPart, "RightArm">
	| EnumItem<number, BodyPart, "LeftLeg">
	| EnumItem<number, BodyPart, "RightLeg">
export type BodyPartRoot = EnumObject<{
	Head: EnumItem<number, BodyPart, "Head">,
	Torso: EnumItem<number, BodyPart, "Torso">,
	LeftArm: EnumItem<number, BodyPart, "LeftArm">,
	RightArm: EnumItem<number, BodyPart, "RightArm">,
	LeftLeg: EnumItem<number, BodyPart, "LeftLeg">,
	RightLeg: EnumItem<number, BodyPart, "RightLeg">,
}, BodyPart>
Enum.BodyPart = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}

export type BodyPartR15 =
	| EnumItem<number, BodyPartR15, "Head">
	| EnumItem<number, BodyPartR15, "UpperTorso">
	| EnumItem<number, BodyPartR15, "LowerTorso">
	| EnumItem<number, BodyPartR15, "LeftFoot">
	| EnumItem<number, BodyPartR15, "LeftLowerLeg">
	| EnumItem<number, BodyPartR15, "LeftUpperLeg">
	| EnumItem<number, BodyPartR15, "RightFoot">
	| EnumItem<number, BodyPartR15, "RightLowerLeg">
	| EnumItem<number, BodyPartR15, "RightUpperLeg">
	| EnumItem<number, BodyPartR15, "LeftHand">
	| EnumItem<number, BodyPartR15, "LeftLowerArm">
	| EnumItem<number, BodyPartR15, "LeftUpperArm">
	| EnumItem<number, BodyPartR15, "RightHand">
	| EnumItem<number, BodyPartR15, "RightLowerArm">
	| EnumItem<number, BodyPartR15, "RightUpperArm">
	| EnumItem<number, BodyPartR15, "RootPart">
	| EnumItem<number, BodyPartR15, "Unknown">
export type BodyPartR15Root = EnumObject<{
	Head: EnumItem<number, BodyPartR15, "Head">,
	UpperTorso: EnumItem<number, BodyPartR15, "UpperTorso">,
	LowerTorso: EnumItem<number, BodyPartR15, "LowerTorso">,
	LeftFoot: EnumItem<number, BodyPartR15, "LeftFoot">,
	LeftLowerLeg: EnumItem<number, BodyPartR15, "LeftLowerLeg">,
	LeftUpperLeg: EnumItem<number, BodyPartR15, "LeftUpperLeg">,
	RightFoot: EnumItem<number, BodyPartR15, "RightFoot">,
	RightLowerLeg: EnumItem<number, BodyPartR15, "RightLowerLeg">,
	RightUpperLeg: EnumItem<number, BodyPartR15, "RightUpperLeg">,
	LeftHand: EnumItem<number, BodyPartR15, "LeftHand">,
	LeftLowerArm: EnumItem<number, BodyPartR15, "LeftLowerArm">,
	LeftUpperArm: EnumItem<number, BodyPartR15, "LeftUpperArm">,
	RightHand: EnumItem<number, BodyPartR15, "RightHand">,
	RightLowerArm: EnumItem<number, BodyPartR15, "RightLowerArm">,
	RightUpperArm: EnumItem<number, BodyPartR15, "RightUpperArm">,
	RootPart: EnumItem<number, BodyPartR15, "RootPart">,
	Unknown: EnumItem<number, BodyPartR15, "Unknown">,
}, BodyPartR15>
Enum.BodyPartR15 = {
	Head = 0;
	UpperTorso = 1;
	LowerTorso = 2;
	LeftFoot = 3;
	LeftLowerLeg = 4;
	LeftUpperLeg = 5;
	RightFoot = 6;
	RightLowerLeg = 7;
	RightUpperLeg = 8;
	LeftHand = 9;
	LeftLowerArm = 10;
	LeftUpperArm = 11;
	RightHand = 12;
	RightLowerArm = 13;
	RightUpperArm = 14;
	RootPart = 15;
	Unknown = 17;
}

export type BorderMode =
	| EnumItem<number, BorderMode, "Outline">
	| EnumItem<number, BorderMode, "Middle">
	| EnumItem<number, BorderMode, "Inset">
export type BorderModeRoot = EnumObject<{
	Outline: EnumItem<number, BorderMode, "Outline">,
	Middle: EnumItem<number, BorderMode, "Middle">,
	Inset: EnumItem<number, BorderMode, "Inset">,
}, BorderMode>
Enum.BorderMode = {"Outline", "Middle", "Inset"}

export type BreakReason =
	| EnumItem<number, BreakReason, "Other">
	| EnumItem<number, BreakReason, "Error">
	| EnumItem<number, BreakReason, "SpecialBreakpoint">
	| EnumItem<number, BreakReason, "UserBreakpoint">
export type BreakReasonRoot = EnumObject<{
	Other: EnumItem<number, BreakReason, "Other">,
	Error: EnumItem<number, BreakReason, "Error">,
	SpecialBreakpoint: EnumItem<number, BreakReason, "SpecialBreakpoint">,
	UserBreakpoint: EnumItem<number, BreakReason, "UserBreakpoint">,
}, BreakReason>
Enum.BreakReason = {"Other", "Error", "SpecialBreakpoint", "UserBreakpoint"}

export type BreakpointRemoveReason =
	| EnumItem<number, BreakpointRemoveReason, "Requested">
	| EnumItem<number, BreakpointRemoveReason, "ScriptChanged">
	| EnumItem<number, BreakpointRemoveReason, "ScriptRemoved">
export type BreakpointRemoveReasonRoot = EnumObject<{
	Requested: EnumItem<number, BreakpointRemoveReason, "Requested">,
	ScriptChanged: EnumItem<number, BreakpointRemoveReason, "ScriptChanged">,
	ScriptRemoved: EnumItem<number, BreakpointRemoveReason, "ScriptRemoved">,
}, BreakpointRemoveReason>
Enum.BreakpointRemoveReason = {"Requested", "ScriptChanged", "ScriptRemoved"}

export type BulkMoveMode =
	| EnumItem<number, BulkMoveMode, "FireAllEvents">
	| EnumItem<number, BulkMoveMode, "FireCFrameChanged">
export type BulkMoveModeRoot = EnumObject<{
	FireAllEvents: EnumItem<number, BulkMoveMode, "FireAllEvents">,
	FireCFrameChanged: EnumItem<number, BulkMoveMode, "FireCFrameChanged">,
}, BulkMoveMode>
Enum.BulkMoveMode = {"FireAllEvents", "FireCFrameChanged"}

export type BundleType =
	| EnumItem<number, BundleType, "BodyParts">
	| EnumItem<number, BundleType, "Animations">
	| EnumItem<number, BundleType, "Shoes">
	| EnumItem<number, BundleType, "DynamicHead">
	| EnumItem<number, BundleType, "DynamicHeadAvatar">
export type BundleTypeRoot = EnumObject<{
	BodyParts: EnumItem<number, BundleType, "BodyParts">,
	Animations: EnumItem<number, BundleType, "Animations">,
	Shoes: EnumItem<number, BundleType, "Shoes">,
	DynamicHead: EnumItem<number, BundleType, "DynamicHead">,
	DynamicHeadAvatar: EnumItem<number, BundleType, "DynamicHeadAvatar">,
}, BundleType>
Enum.BundleType = {
	BodyParts = 1;
	Animations = 2;
	Shoes = 3;
	DynamicHead = 4;
	DynamicHeadAvatar = 5;
}

export type Button = | EnumItem<number, Button, "Dismount"> | EnumItem<number, Button, "Jump">
export type ButtonRoot = EnumObject<{
	Dismount: EnumItem<number, Button, "Dismount">,
	Jump: EnumItem<number, Button, "Jump">,
}, Button>
Enum.Button = {
	Dismount = 8;
	Jump = 32;
}

export type ButtonStyle =
	| EnumItem<number, ButtonStyle, "Custom">
	| EnumItem<number, ButtonStyle, "RobloxButtonDefault">
	| EnumItem<number, ButtonStyle, "RobloxButton">
	| EnumItem<number, ButtonStyle, "RobloxRoundButton">
	| EnumItem<number, ButtonStyle, "RobloxRoundDefaultButton">
	| EnumItem<number, ButtonStyle, "RobloxRoundDropdownButton">
export type ButtonStyleRoot = EnumObject<{
	Custom: EnumItem<number, ButtonStyle, "Custom">,
	RobloxButtonDefault: EnumItem<number, ButtonStyle, "RobloxButtonDefault">,
	RobloxButton: EnumItem<number, ButtonStyle, "RobloxButton">,
	RobloxRoundButton: EnumItem<number, ButtonStyle, "RobloxRoundButton">,
	RobloxRoundDefaultButton: EnumItem<number, ButtonStyle, "RobloxRoundDefaultButton">,
	RobloxRoundDropdownButton: EnumItem<number, ButtonStyle, "RobloxRoundDropdownButton">,
}, ButtonStyle>
Enum.ButtonStyle = {
	"Custom";
	"RobloxButtonDefault";
	"RobloxButton";
	"RobloxRoundButton";
	"RobloxRoundDefaultButton";
	"RobloxRoundDropdownButton";
}

export type CageType = | EnumItem<number, CageType, "Inner"> | EnumItem<number, CageType, "Outer">
export type CageTypeRoot = EnumObject<{
	Inner: EnumItem<number, CageType, "Inner">,
	Outer: EnumItem<number, CageType, "Outer">,
}, CageType>
Enum.CageType = {"Inner", "Outer"}

export type CameraMode = | EnumItem<number, CameraMode, "Classic"> | EnumItem<number, CameraMode, "LockFirstPerson">
export type CameraModeRoot = EnumObject<{
	Classic: EnumItem<number, CameraMode, "Classic">,
	LockFirstPerson: EnumItem<number, CameraMode, "LockFirstPerson">,
}, CameraMode>
Enum.CameraMode = {"Classic", "LockFirstPerson"}

export type CameraPanMode = | EnumItem<number, CameraPanMode, "Classic"> | EnumItem<number, CameraPanMode, "EdgeBump">
export type CameraPanModeRoot = EnumObject<{
	Classic: EnumItem<number, CameraPanMode, "Classic">,
	EdgeBump: EnumItem<number, CameraPanMode, "EdgeBump">,
}, CameraPanMode>
Enum.CameraPanMode = {"Classic", "EdgeBump"}

export type CameraSpeedAdjustBinding =
	| EnumItem<number, CameraSpeedAdjustBinding, "None">
	| EnumItem<number, CameraSpeedAdjustBinding, "RmbScroll">
	| EnumItem<number, CameraSpeedAdjustBinding, "AltScroll">
export type CameraSpeedAdjustBindingRoot = EnumObject<{
	None: EnumItem<number, CameraSpeedAdjustBinding, "None">,
	RmbScroll: EnumItem<number, CameraSpeedAdjustBinding, "RmbScroll">,
	AltScroll: EnumItem<number, CameraSpeedAdjustBinding, "AltScroll">,
}, CameraSpeedAdjustBinding>
Enum.CameraSpeedAdjustBinding = {"None", "RmbScroll", "AltScroll"}

export type CameraType =
	| EnumItem<number, CameraType, "Fixed">
	| EnumItem<number, CameraType, "Attach">
	| EnumItem<number, CameraType, "Watch">
	| EnumItem<number, CameraType, "Track">
	| EnumItem<number, CameraType, "Follow">
	| EnumItem<number, CameraType, "Custom">
	| EnumItem<number, CameraType, "Scriptable">
	| EnumItem<number, CameraType, "Orbital">
export type CameraTypeRoot = EnumObject<{
	Fixed: EnumItem<number, CameraType, "Fixed">,
	Attach: EnumItem<number, CameraType, "Attach">,
	Watch: EnumItem<number, CameraType, "Watch">,
	Track: EnumItem<number, CameraType, "Track">,
	Follow: EnumItem<number, CameraType, "Follow">,
	Custom: EnumItem<number, CameraType, "Custom">,
	Scriptable: EnumItem<number, CameraType, "Scriptable">,
	Orbital: EnumItem<number, CameraType, "Orbital">,
}, CameraType>
Enum.CameraType = {"Fixed", "Attach", "Watch", "Track", "Follow", "Custom", "Scriptable", "Orbital"}

export type CatalogCategoryFilter =
	| EnumItem<number, CatalogCategoryFilter, "None">
	| EnumItem<number, CatalogCategoryFilter, "Featured">
	| EnumItem<number, CatalogCategoryFilter, "Collectibles">
	| EnumItem<number, CatalogCategoryFilter, "CommunityCreations">
	| EnumItem<number, CatalogCategoryFilter, "Premium">
	| EnumItem<number, CatalogCategoryFilter, "Recommended">
export type CatalogCategoryFilterRoot = EnumObject<{
	None: EnumItem<number, CatalogCategoryFilter, "None">,
	Featured: EnumItem<number, CatalogCategoryFilter, "Featured">,
	Collectibles: EnumItem<number, CatalogCategoryFilter, "Collectibles">,
	CommunityCreations: EnumItem<number, CatalogCategoryFilter, "CommunityCreations">,
	Premium: EnumItem<number, CatalogCategoryFilter, "Premium">,
	Recommended: EnumItem<number, CatalogCategoryFilter, "Recommended">,
}, CatalogCategoryFilter>
Enum.CatalogCategoryFilter = {
	None = 1;
	Featured = 2;
	Collectibles = 3;
	CommunityCreations = 4;
	Premium = 5;
	Recommended = 6;
}

export type CatalogSortAggregation =
	| EnumItem<number, CatalogSortAggregation, "Past12Hours">
	| EnumItem<number, CatalogSortAggregation, "PastDay">
	| EnumItem<number, CatalogSortAggregation, "Past3Days">
	| EnumItem<number, CatalogSortAggregation, "PastWeek">
	| EnumItem<number, CatalogSortAggregation, "PastMonth">
	| EnumItem<number, CatalogSortAggregation, "AllTime">
export type CatalogSortAggregationRoot = EnumObject<{
	Past12Hours: EnumItem<number, CatalogSortAggregation, "Past12Hours">,
	PastDay: EnumItem<number, CatalogSortAggregation, "PastDay">,
	Past3Days: EnumItem<number, CatalogSortAggregation, "Past3Days">,
	PastWeek: EnumItem<number, CatalogSortAggregation, "PastWeek">,
	PastMonth: EnumItem<number, CatalogSortAggregation, "PastMonth">,
	AllTime: EnumItem<number, CatalogSortAggregation, "AllTime">,
}, CatalogSortAggregation>
Enum.CatalogSortAggregation = {
	Past12Hours = 1;
	PastDay = 2;
	Past3Days = 3;
	PastWeek = 4;
	PastMonth = 5;
	AllTime = 6;
}

export type CatalogSortType =
	| EnumItem<number, CatalogSortType, "Relevance">
	| EnumItem<number, CatalogSortType, "PriceHighToLow">
	| EnumItem<number, CatalogSortType, "PriceLowToHigh">
	| EnumItem<number, CatalogSortType, "MostFavorited">
	| EnumItem<number, CatalogSortType, "RecentlyCreated">
	| EnumItem<number, CatalogSortType, "Bestselling">
export type CatalogSortTypeRoot = EnumObject<{
	Relevance: EnumItem<number, CatalogSortType, "Relevance">,
	PriceHighToLow: EnumItem<number, CatalogSortType, "PriceHighToLow">,
	PriceLowToHigh: EnumItem<number, CatalogSortType, "PriceLowToHigh">,
	MostFavorited: EnumItem<number, CatalogSortType, "MostFavorited">,
	RecentlyCreated: EnumItem<number, CatalogSortType, "RecentlyCreated">,
	Bestselling: EnumItem<number, CatalogSortType, "Bestselling">,
}, CatalogSortType>
Enum.CatalogSortType = {
	Relevance = 1;
	PriceHighToLow = 2;
	PriceLowToHigh = 3;
	MostFavorited = 5;
	RecentlyCreated = 6;
	Bestselling = 7;
}

export type CellBlock =
	| EnumItem<number, CellBlock, "Solid">
	| EnumItem<number, CellBlock, "VerticalWedge">
	| EnumItem<number, CellBlock, "CornerWedge">
	| EnumItem<number, CellBlock, "InverseCornerWedge">
	| EnumItem<number, CellBlock, "HorizontalWedge">
export type CellBlockRoot = EnumObject<{
	Solid: EnumItem<number, CellBlock, "Solid">,
	VerticalWedge: EnumItem<number, CellBlock, "VerticalWedge">,
	CornerWedge: EnumItem<number, CellBlock, "CornerWedge">,
	InverseCornerWedge: EnumItem<number, CellBlock, "InverseCornerWedge">,
	HorizontalWedge: EnumItem<number, CellBlock, "HorizontalWedge">,
}, CellBlock>
Enum.CellBlock = {"Solid", "VerticalWedge", "CornerWedge", "InverseCornerWedge", "HorizontalWedge"}

export type CellMaterial =
	| EnumItem<number, CellMaterial, "Empty">
	| EnumItem<number, CellMaterial, "Grass">
	| EnumItem<number, CellMaterial, "Sand">
	| EnumItem<number, CellMaterial, "Brick">
	| EnumItem<number, CellMaterial, "Granite">
	| EnumItem<number, CellMaterial, "Asphalt">
	| EnumItem<number, CellMaterial, "Iron">
	| EnumItem<number, CellMaterial, "Aluminum">
	| EnumItem<number, CellMaterial, "Gold">
	| EnumItem<number, CellMaterial, "WoodPlank">
	| EnumItem<number, CellMaterial, "WoodLog">
	| EnumItem<number, CellMaterial, "Gravel">
	| EnumItem<number, CellMaterial, "CinderBlock">
	| EnumItem<number, CellMaterial, "MossyStone">
	| EnumItem<number, CellMaterial, "Cement">
	| EnumItem<number, CellMaterial, "RedPlastic">
	| EnumItem<number, CellMaterial, "BluePlastic">
	| EnumItem<number, CellMaterial, "Water">
export type CellMaterialRoot = EnumObject<{
	Empty: EnumItem<number, CellMaterial, "Empty">,
	Grass: EnumItem<number, CellMaterial, "Grass">,
	Sand: EnumItem<number, CellMaterial, "Sand">,
	Brick: EnumItem<number, CellMaterial, "Brick">,
	Granite: EnumItem<number, CellMaterial, "Granite">,
	Asphalt: EnumItem<number, CellMaterial, "Asphalt">,
	Iron: EnumItem<number, CellMaterial, "Iron">,
	Aluminum: EnumItem<number, CellMaterial, "Aluminum">,
	Gold: EnumItem<number, CellMaterial, "Gold">,
	WoodPlank: EnumItem<number, CellMaterial, "WoodPlank">,
	WoodLog: EnumItem<number, CellMaterial, "WoodLog">,
	Gravel: EnumItem<number, CellMaterial, "Gravel">,
	CinderBlock: EnumItem<number, CellMaterial, "CinderBlock">,
	MossyStone: EnumItem<number, CellMaterial, "MossyStone">,
	Cement: EnumItem<number, CellMaterial, "Cement">,
	RedPlastic: EnumItem<number, CellMaterial, "RedPlastic">,
	BluePlastic: EnumItem<number, CellMaterial, "BluePlastic">,
	Water: EnumItem<number, CellMaterial, "Water">,
}, CellMaterial>
Enum.CellMaterial = {
	"Empty";
	"Grass";
	"Sand";
	"Brick";
	"Granite";
	"Asphalt";
	"Iron";
	"Aluminum";
	"Gold";
	"WoodPlank";
	"WoodLog";
	"Gravel";
	"CinderBlock";
	"MossyStone";
	"Cement";
	"RedPlastic";
	"BluePlastic";
	"Water";
}

export type CellOrientation =
	| EnumItem<number, CellOrientation, "NegZ">
	| EnumItem<number, CellOrientation, "X">
	| EnumItem<number, CellOrientation, "Z">
	| EnumItem<number, CellOrientation, "NegX">
export type CellOrientationRoot = EnumObject<{
	NegZ: EnumItem<number, CellOrientation, "NegZ">,
	X: EnumItem<number, CellOrientation, "X">,
	Z: EnumItem<number, CellOrientation, "Z">,
	NegX: EnumItem<number, CellOrientation, "NegX">,
}, CellOrientation>
Enum.CellOrientation = {"NegZ", "X", "Z", "NegX"}

export type CenterDialogType =
	| EnumItem<number, CenterDialogType, "UnsolicitedDialog">
	| EnumItem<number, CenterDialogType, "PlayerInitiatedDialog">
	| EnumItem<number, CenterDialogType, "ModalDialog">
	| EnumItem<number, CenterDialogType, "QuitDialog">
export type CenterDialogTypeRoot = EnumObject<{
	UnsolicitedDialog: EnumItem<number, CenterDialogType, "UnsolicitedDialog">,
	PlayerInitiatedDialog: EnumItem<number, CenterDialogType, "PlayerInitiatedDialog">,
	ModalDialog: EnumItem<number, CenterDialogType, "ModalDialog">,
	QuitDialog: EnumItem<number, CenterDialogType, "QuitDialog">,
}, CenterDialogType>
Enum.CenterDialogType = {
	UnsolicitedDialog = 1;
	PlayerInitiatedDialog = 2;
	ModalDialog = 3;
	QuitDialog = 4;
}

export type CharacterControlMode =
	| EnumItem<number, CharacterControlMode, "Default">
	| EnumItem<number, CharacterControlMode, "Legacy">
	| EnumItem<number, CharacterControlMode, "NoCharacterController">
	| EnumItem<number, CharacterControlMode, "LuaCharacterController">
export type CharacterControlModeRoot = EnumObject<{
	Default: EnumItem<number, CharacterControlMode, "Default">,
	Legacy: EnumItem<number, CharacterControlMode, "Legacy">,
	NoCharacterController: EnumItem<number, CharacterControlMode, "NoCharacterController">,
	LuaCharacterController: EnumItem<number, CharacterControlMode, "LuaCharacterController">,
}, CharacterControlMode>
Enum.CharacterControlMode = {"Default", "Legacy", "NoCharacterController", "LuaCharacterController"}

export type ChatCallbackType =
	| EnumItem<number, ChatCallbackType, "OnCreatingChatWindow">
	| EnumItem<number, ChatCallbackType, "OnClientSendingMessage">
	| EnumItem<number, ChatCallbackType, "OnClientFormattingMessage">
	| EnumItem<number, ChatCallbackType, "OnServerReceivingMessage">
export type ChatCallbackTypeRoot = EnumObject<{
	OnCreatingChatWindow: EnumItem<number, ChatCallbackType, "OnCreatingChatWindow">,
	OnClientSendingMessage: EnumItem<number, ChatCallbackType, "OnClientSendingMessage">,
	OnClientFormattingMessage: EnumItem<number, ChatCallbackType, "OnClientFormattingMessage">,
	OnServerReceivingMessage: EnumItem<number, ChatCallbackType, "OnServerReceivingMessage">,
}, ChatCallbackType>
Enum.ChatCallbackType = {
	OnCreatingChatWindow = 1;
	OnClientSendingMessage = 2;
	OnClientFormattingMessage = 3;
	OnServerReceivingMessage = 17;
}

export type ChatColor =
	| EnumItem<number, ChatColor, "Blue">
	| EnumItem<number, ChatColor, "Green">
	| EnumItem<number, ChatColor, "Red">
	| EnumItem<number, ChatColor, "White">
export type ChatColorRoot = EnumObject<{
	Blue: EnumItem<number, ChatColor, "Blue">,
	Green: EnumItem<number, ChatColor, "Green">,
	Red: EnumItem<number, ChatColor, "Red">,
	White: EnumItem<number, ChatColor, "White">,
}, ChatColor>
Enum.ChatColor = {"Blue", "Green", "Red", "White"}

export type ChatMode = | EnumItem<number, ChatMode, "Menu"> | EnumItem<number, ChatMode, "TextAndMenu">
export type ChatModeRoot = EnumObject<{
	Menu: EnumItem<number, ChatMode, "Menu">,
	TextAndMenu: EnumItem<number, ChatMode, "TextAndMenu">,
}, ChatMode>
Enum.ChatMode = {"Menu", "TextAndMenu"}

export type ChatPrivacyMode =
	| EnumItem<number, ChatPrivacyMode, "AllUsers">
	| EnumItem<number, ChatPrivacyMode, "NoOne">
	| EnumItem<number, ChatPrivacyMode, "Friends">
export type ChatPrivacyModeRoot = EnumObject<{
	AllUsers: EnumItem<number, ChatPrivacyMode, "AllUsers">,
	NoOne: EnumItem<number, ChatPrivacyMode, "NoOne">,
	Friends: EnumItem<number, ChatPrivacyMode, "Friends">,
}, ChatPrivacyMode>
Enum.ChatPrivacyMode = {"AllUsers", "NoOne", "Friends"}

export type ChatRestrictionStatus =
	| EnumItem<number, ChatRestrictionStatus, "Unknown">
	| EnumItem<number, ChatRestrictionStatus, "NotRestricted">
	| EnumItem<number, ChatRestrictionStatus, "Restricted">
export type ChatRestrictionStatusRoot = EnumObject<{
	Unknown: EnumItem<number, ChatRestrictionStatus, "Unknown">,
	NotRestricted: EnumItem<number, ChatRestrictionStatus, "NotRestricted">,
	Restricted: EnumItem<number, ChatRestrictionStatus, "Restricted">,
}, ChatRestrictionStatus>
Enum.ChatRestrictionStatus = {"Unknown", "NotRestricted", "Restricted"}

export type ChatStyle =
	| EnumItem<number, ChatStyle, "Classic">
	| EnumItem<number, ChatStyle, "Bubble">
	| EnumItem<number, ChatStyle, "ClassicAndBubble">
export type ChatStyleRoot = EnumObject<{
	Classic: EnumItem<number, ChatStyle, "Classic">,
	Bubble: EnumItem<number, ChatStyle, "Bubble">,
	ClassicAndBubble: EnumItem<number, ChatStyle, "ClassicAndBubble">,
}, ChatStyle>
Enum.ChatStyle = {"Classic", "Bubble", "ClassicAndBubble"}

export type ChatVersion =
	| EnumItem<number, ChatVersion, "LegacyChatService">
	| EnumItem<number, ChatVersion, "TextChatService">
export type ChatVersionRoot = EnumObject<{
	LegacyChatService: EnumItem<number, ChatVersion, "LegacyChatService">,
	TextChatService: EnumItem<number, ChatVersion, "TextChatService">,
}, ChatVersion>
Enum.ChatVersion = {"LegacyChatService", "TextChatService"}

export type ClientAnimatorThrottlingMode =
	| EnumItem<number, ClientAnimatorThrottlingMode, "Default">
	| EnumItem<number, ClientAnimatorThrottlingMode, "Disabled">
	| EnumItem<number, ClientAnimatorThrottlingMode, "Enabled">
export type ClientAnimatorThrottlingModeRoot = EnumObject<{
	Default: EnumItem<number, ClientAnimatorThrottlingMode, "Default">,
	Disabled: EnumItem<number, ClientAnimatorThrottlingMode, "Disabled">,
	Enabled: EnumItem<number, ClientAnimatorThrottlingMode, "Enabled">,
}, ClientAnimatorThrottlingMode>
Enum.ClientAnimatorThrottlingMode = {"Default", "Disabled", "Enabled"}

export type CloseReason =
	| EnumItem<number, CloseReason, "Unknown">
	| EnumItem<number, CloseReason, "RobloxMaintenance">
	| EnumItem<number, CloseReason, "DeveloperShutdown">
	| EnumItem<number, CloseReason, "DeveloperUpdate">
	| EnumItem<number, CloseReason, "ServerEmpty">
	| EnumItem<number, CloseReason, "OutOfMemory">
export type CloseReasonRoot = EnumObject<{
	Unknown: EnumItem<number, CloseReason, "Unknown">,
	RobloxMaintenance: EnumItem<number, CloseReason, "RobloxMaintenance">,
	DeveloperShutdown: EnumItem<number, CloseReason, "DeveloperShutdown">,
	DeveloperUpdate: EnumItem<number, CloseReason, "DeveloperUpdate">,
	ServerEmpty: EnumItem<number, CloseReason, "ServerEmpty">,
	OutOfMemory: EnumItem<number, CloseReason, "OutOfMemory">,
}, CloseReason>
Enum.CloseReason =
	{"Unknown", "RobloxMaintenance", "DeveloperShutdown", "DeveloperUpdate", "ServerEmpty", "OutOfMemory"}

export type CollaboratorStatus =
	| EnumItem<number, CollaboratorStatus, "None">
	| EnumItem<number, CollaboratorStatus, "Editing3D">
	| EnumItem<number, CollaboratorStatus, "Scripting">
	| EnumItem<number, CollaboratorStatus, "PrivateScripting">
export type CollaboratorStatusRoot = EnumObject<{
	None: EnumItem<number, CollaboratorStatus, "None">,
	Editing3D: EnumItem<number, CollaboratorStatus, "Editing3D">,
	Scripting: EnumItem<number, CollaboratorStatus, "Scripting">,
	PrivateScripting: EnumItem<number, CollaboratorStatus, "PrivateScripting">,
}, CollaboratorStatus>
Enum.CollaboratorStatus = {"None", "Editing3D", "Scripting", "PrivateScripting"}

export type CollisionFidelity =
	| EnumItem<number, CollisionFidelity, "Default">
	| EnumItem<number, CollisionFidelity, "Hull">
	| EnumItem<number, CollisionFidelity, "Box">
	| EnumItem<number, CollisionFidelity, "PreciseConvexDecomposition">
export type CollisionFidelityRoot = EnumObject<{
	Default: EnumItem<number, CollisionFidelity, "Default">,
	Hull: EnumItem<number, CollisionFidelity, "Hull">,
	Box: EnumItem<number, CollisionFidelity, "Box">,
	PreciseConvexDecomposition: EnumItem<number, CollisionFidelity, "PreciseConvexDecomposition">,
}, CollisionFidelity>
Enum.CollisionFidelity = {"Default", "Hull", "Box", "PreciseConvexDecomposition"}

export type CommandPermission =
	| EnumItem<number, CommandPermission, "Plugin">
	| EnumItem<number, CommandPermission, "LocalUser">
export type CommandPermissionRoot = EnumObject<{
	Plugin: EnumItem<number, CommandPermission, "Plugin">,
	LocalUser: EnumItem<number, CommandPermission, "LocalUser">,
}, CommandPermission>
Enum.CommandPermission = {"Plugin", "LocalUser"}

export type CompileTarget =
	| EnumItem<number, CompileTarget, "Client">
	| EnumItem<number, CompileTarget, "CoreScript">
	| EnumItem<number, CompileTarget, "Studio">
	| EnumItem<number, CompileTarget, "CoreScriptRaw">
export type CompileTargetRoot = EnumObject<{
	Client: EnumItem<number, CompileTarget, "Client">,
	CoreScript: EnumItem<number, CompileTarget, "CoreScript">,
	Studio: EnumItem<number, CompileTarget, "Studio">,
	CoreScriptRaw: EnumItem<number, CompileTarget, "CoreScriptRaw">,
}, CompileTarget>
Enum.CompileTarget = {"Client", "CoreScript", "Studio", "CoreScriptRaw"}

export type CompletionAcceptanceBehavior =
	| EnumItem<number, CompletionAcceptanceBehavior, "Insert">
	| EnumItem<number, CompletionAcceptanceBehavior, "Replace">
	| EnumItem<number, CompletionAcceptanceBehavior, "ReplaceOnEnterInsertOnTab">
	| EnumItem<number, CompletionAcceptanceBehavior, "InsertOnEnterReplaceOnTab">
export type CompletionAcceptanceBehaviorRoot = EnumObject<{
	Insert: EnumItem<number, CompletionAcceptanceBehavior, "Insert">,
	Replace: EnumItem<number, CompletionAcceptanceBehavior, "Replace">,
	ReplaceOnEnterInsertOnTab: EnumItem<number, CompletionAcceptanceBehavior, "ReplaceOnEnterInsertOnTab">,
	InsertOnEnterReplaceOnTab: EnumItem<number, CompletionAcceptanceBehavior, "InsertOnEnterReplaceOnTab">,
}, CompletionAcceptanceBehavior>
Enum.CompletionAcceptanceBehavior = {"Insert", "Replace", "ReplaceOnEnterInsertOnTab", "InsertOnEnterReplaceOnTab"}

export type CompletionItemKind =
	| EnumItem<number, CompletionItemKind, "Text">
	| EnumItem<number, CompletionItemKind, "Method">
	| EnumItem<number, CompletionItemKind, "Function">
	| EnumItem<number, CompletionItemKind, "Constructor">
	| EnumItem<number, CompletionItemKind, "Field">
	| EnumItem<number, CompletionItemKind, "Variable">
	| EnumItem<number, CompletionItemKind, "Class">
	| EnumItem<number, CompletionItemKind, "Interface">
	| EnumItem<number, CompletionItemKind, "Module">
	| EnumItem<number, CompletionItemKind, "Property">
	| EnumItem<number, CompletionItemKind, "Unit">
	| EnumItem<number, CompletionItemKind, "Value">
	| EnumItem<number, CompletionItemKind, "Enum">
	| EnumItem<number, CompletionItemKind, "Keyword">
	| EnumItem<number, CompletionItemKind, "Snippet">
	| EnumItem<number, CompletionItemKind, "Color">
	| EnumItem<number, CompletionItemKind, "File">
	| EnumItem<number, CompletionItemKind, "Reference">
	| EnumItem<number, CompletionItemKind, "Folder">
	| EnumItem<number, CompletionItemKind, "EnumMember">
	| EnumItem<number, CompletionItemKind, "Constant">
	| EnumItem<number, CompletionItemKind, "Struct">
	| EnumItem<number, CompletionItemKind, "Event">
	| EnumItem<number, CompletionItemKind, "Operator">
	| EnumItem<number, CompletionItemKind, "TypeParameter">
export type CompletionItemKindRoot = EnumObject<{
	Text: EnumItem<number, CompletionItemKind, "Text">,
	Method: EnumItem<number, CompletionItemKind, "Method">,
	Function: EnumItem<number, CompletionItemKind, "Function">,
	Constructor: EnumItem<number, CompletionItemKind, "Constructor">,
	Field: EnumItem<number, CompletionItemKind, "Field">,
	Variable: EnumItem<number, CompletionItemKind, "Variable">,
	Class: EnumItem<number, CompletionItemKind, "Class">,
	Interface: EnumItem<number, CompletionItemKind, "Interface">,
	Module: EnumItem<number, CompletionItemKind, "Module">,
	Property: EnumItem<number, CompletionItemKind, "Property">,
	Unit: EnumItem<number, CompletionItemKind, "Unit">,
	Value: EnumItem<number, CompletionItemKind, "Value">,
	Enum: EnumItem<number, CompletionItemKind, "Enum">,
	Keyword: EnumItem<number, CompletionItemKind, "Keyword">,
	Snippet: EnumItem<number, CompletionItemKind, "Snippet">,
	Color: EnumItem<number, CompletionItemKind, "Color">,
	File: EnumItem<number, CompletionItemKind, "File">,
	Reference: EnumItem<number, CompletionItemKind, "Reference">,
	Folder: EnumItem<number, CompletionItemKind, "Folder">,
	EnumMember: EnumItem<number, CompletionItemKind, "EnumMember">,
	Constant: EnumItem<number, CompletionItemKind, "Constant">,
	Struct: EnumItem<number, CompletionItemKind, "Struct">,
	Event: EnumItem<number, CompletionItemKind, "Event">,
	Operator: EnumItem<number, CompletionItemKind, "Operator">,
	TypeParameter: EnumItem<number, CompletionItemKind, "TypeParameter">,
}, CompletionItemKind>
Enum.CompletionItemKind = {
	Text = 1;
	Method = 2;
	Function = 3;
	Constructor = 4;
	Field = 5;
	Variable = 6;
	Class = 7;
	Interface = 8;
	Module = 9;
	Property = 10;
	Unit = 11;
	Value = 12;
	Enum = 13;
	Keyword = 14;
	Snippet = 15;
	Color = 16;
	File = 17;
	Reference = 18;
	Folder = 19;
	EnumMember = 20;
	Constant = 21;
	Struct = 22;
	Event = 23;
	Operator = 24;
	TypeParameter = 25;
}

export type CompletionItemTag =
	| EnumItem<number, CompletionItemTag, "Deprecated">
	| EnumItem<number, CompletionItemTag, "IncorrectIndexType">
	| EnumItem<number, CompletionItemTag, "PluginPermissions">
	| EnumItem<number, CompletionItemTag, "CommandLinePermissions">
	| EnumItem<number, CompletionItemTag, "RobloxPermissions">
	| EnumItem<number, CompletionItemTag, "AddParens">
	| EnumItem<number, CompletionItemTag, "PutCursorInParens">
	| EnumItem<number, CompletionItemTag, "TypeCorrect">
	| EnumItem<number, CompletionItemTag, "ClientServerBoundaryViolation">
	| EnumItem<number, CompletionItemTag, "Invalidated">
	| EnumItem<number, CompletionItemTag, "PutCursorBeforeEnd">
export type CompletionItemTagRoot = EnumObject<{
	Deprecated: EnumItem<number, CompletionItemTag, "Deprecated">,
	IncorrectIndexType: EnumItem<number, CompletionItemTag, "IncorrectIndexType">,
	PluginPermissions: EnumItem<number, CompletionItemTag, "PluginPermissions">,
	CommandLinePermissions: EnumItem<number, CompletionItemTag, "CommandLinePermissions">,
	RobloxPermissions: EnumItem<number, CompletionItemTag, "RobloxPermissions">,
	AddParens: EnumItem<number, CompletionItemTag, "AddParens">,
	PutCursorInParens: EnumItem<number, CompletionItemTag, "PutCursorInParens">,
	TypeCorrect: EnumItem<number, CompletionItemTag, "TypeCorrect">,
	ClientServerBoundaryViolation: EnumItem<number, CompletionItemTag, "ClientServerBoundaryViolation">,
	Invalidated: EnumItem<number, CompletionItemTag, "Invalidated">,
	PutCursorBeforeEnd: EnumItem<number, CompletionItemTag, "PutCursorBeforeEnd">,
}, CompletionItemTag>
Enum.CompletionItemTag = {
	Deprecated = 1;
	IncorrectIndexType = 2;
	PluginPermissions = 3;
	CommandLinePermissions = 4;
	RobloxPermissions = 5;
	AddParens = 6;
	PutCursorInParens = 7;
	TypeCorrect = 8;
	ClientServerBoundaryViolation = 9;
	Invalidated = 10;
	PutCursorBeforeEnd = 11;
}

export type CompletionTriggerKind =
	| EnumItem<number, CompletionTriggerKind, "Invoked">
	| EnumItem<number, CompletionTriggerKind, "TriggerCharacter">
	| EnumItem<number, CompletionTriggerKind, "TriggerForIncompleteCompletions">
export type CompletionTriggerKindRoot = EnumObject<{
	Invoked: EnumItem<number, CompletionTriggerKind, "Invoked">,
	TriggerCharacter: EnumItem<number, CompletionTriggerKind, "TriggerCharacter">,
	TriggerForIncompleteCompletions: EnumItem<number, CompletionTriggerKind, "TriggerForIncompleteCompletions">,
}, CompletionTriggerKind>
Enum.CompletionTriggerKind = {
	Invoked = 1;
	TriggerCharacter = 2;
	TriggerForIncompleteCompletions = 3;
}

export type ComputerCameraMovementMode =
	| EnumItem<number, ComputerCameraMovementMode, "Default">
	| EnumItem<number, ComputerCameraMovementMode, "Classic">
	| EnumItem<number, ComputerCameraMovementMode, "Follow">
	| EnumItem<number, ComputerCameraMovementMode, "Orbital">
	| EnumItem<number, ComputerCameraMovementMode, "CameraToggle">
export type ComputerCameraMovementModeRoot = EnumObject<{
	Default: EnumItem<number, ComputerCameraMovementMode, "Default">,
	Classic: EnumItem<number, ComputerCameraMovementMode, "Classic">,
	Follow: EnumItem<number, ComputerCameraMovementMode, "Follow">,
	Orbital: EnumItem<number, ComputerCameraMovementMode, "Orbital">,
	CameraToggle: EnumItem<number, ComputerCameraMovementMode, "CameraToggle">,
}, ComputerCameraMovementMode>
Enum.ComputerCameraMovementMode = {"Default", "Classic", "Follow", "Orbital", "CameraToggle"}

export type ComputerMovementMode =
	| EnumItem<number, ComputerMovementMode, "Default">
	| EnumItem<number, ComputerMovementMode, "KeyboardMouse">
	| EnumItem<number, ComputerMovementMode, "ClickToMove">
export type ComputerMovementModeRoot = EnumObject<{
	Default: EnumItem<number, ComputerMovementMode, "Default">,
	KeyboardMouse: EnumItem<number, ComputerMovementMode, "KeyboardMouse">,
	ClickToMove: EnumItem<number, ComputerMovementMode, "ClickToMove">,
}, ComputerMovementMode>
Enum.ComputerMovementMode = {"Default", "KeyboardMouse", "ClickToMove"}

export type ConfigSnapshotErrorState =
	| EnumItem<number, ConfigSnapshotErrorState, "None">
	| EnumItem<number, ConfigSnapshotErrorState, "LoadFailed">
export type ConfigSnapshotErrorStateRoot = EnumObject<{
	None: EnumItem<number, ConfigSnapshotErrorState, "None">,
	LoadFailed: EnumItem<number, ConfigSnapshotErrorState, "LoadFailed">,
}, ConfigSnapshotErrorState>
Enum.ConfigSnapshotErrorState = {"None", "LoadFailed"}

export type ConnectionError =
	| EnumItem<number, ConnectionError, "OK">
	| EnumItem<number, ConnectionError, "Unknown">
	| EnumItem<number, ConnectionError, "DisconnectErrors">
	| EnumItem<number, ConnectionError, "DisconnectBadhash">
	| EnumItem<number, ConnectionError, "DisconnectSecurityKeyMismatch">
	| EnumItem<number, ConnectionError, "DisconnectProtocolMismatch">
	| EnumItem<number, ConnectionError, "DisconnectReceivePacketError">
	| EnumItem<number, ConnectionError, "DisconnectReceivePacketStreamError">
	| EnumItem<number, ConnectionError, "DisconnectSendPacketError">
	| EnumItem<number, ConnectionError, "DisconnectIllegalTeleport">
	| EnumItem<number, ConnectionError, "DisconnectDuplicatePlayer">
	| EnumItem<number, ConnectionError, "DisconnectDuplicateTicket">
	| EnumItem<number, ConnectionError, "DisconnectTimeout">
	| EnumItem<number, ConnectionError, "DisconnectLuaKick">
	| EnumItem<number, ConnectionError, "DisconnectOnRemoteSysStats">
	| EnumItem<number, ConnectionError, "DisconnectHashTimeout">
	| EnumItem<number, ConnectionError, "DisconnectCloudEditKick">
	| EnumItem<number, ConnectionError, "DisconnectPlayerless">
	| EnumItem<number, ConnectionError, "DisconnectNewSecurityKeyMismatch">
	| EnumItem<number, ConnectionError, "DisconnectEvicted">
	| EnumItem<number, ConnectionError, "DisconnectDevMaintenance">
	| EnumItem<number, ConnectionError, "DisconnectRobloxMaintenance">
	| EnumItem<number, ConnectionError, "DisconnectRejoin">
	| EnumItem<number, ConnectionError, "DisconnectConnectionLost">
	| EnumItem<number, ConnectionError, "DisconnectIdle">
	| EnumItem<number, ConnectionError, "DisconnectRaknetErrors">
	| EnumItem<number, ConnectionError, "DisconnectWrongVersion">
	| EnumItem<number, ConnectionError, "DisconnectBySecurityPolicy">
	| EnumItem<number, ConnectionError, "DisconnectBlockedIP">
	| EnumItem<number, ConnectionError, "DisconnectClientFailure">
	| EnumItem<number, ConnectionError, "DisconnectClientRequest">
	| EnumItem<number, ConnectionError, "DisconnectPrivateServerKickout">
	| EnumItem<number, ConnectionError, "DisconnectModeratedGame">
	| EnumItem<number, ConnectionError, "ServerShutdown">
	| EnumItem<number, ConnectionError, "ReplicatorTimeout">
	| EnumItem<number, ConnectionError, "PlayerRemoved">
	| EnumItem<number, ConnectionError, "DisconnectOutOfMemoryKeepPlayingLeave">
	| EnumItem<number, ConnectionError, "DisconnectRomarkEndOfTest">
	| EnumItem<number, ConnectionError, "DisconnectCollaboratorPermissionRevoked">
	| EnumItem<number, ConnectionError, "DisconnectCollaboratorUnderage">
	| EnumItem<number, ConnectionError, "NetworkInternal">
	| EnumItem<number, ConnectionError, "NetworkSend">
	| EnumItem<number, ConnectionError, "NetworkTimeout">
	| EnumItem<number, ConnectionError, "NetworkMisbehavior">
	| EnumItem<number, ConnectionError, "NetworkSecurity">
	| EnumItem<number, ConnectionError, "ReplacementReady">
	| EnumItem<number, ConnectionError, "ServerEmpty">
	| EnumItem<number, ConnectionError, "PhantomFreeze">
	| EnumItem<number, ConnectionError, "AndroidAnticheatKick">
	| EnumItem<number, ConnectionError, "AndroidEmulatorKick">
	| EnumItem<number, ConnectionError, "PlacelaunchErrors">
	| EnumItem<number, ConnectionError, "PlacelaunchDisabled">
	| EnumItem<number, ConnectionError, "PlacelaunchError">
	| EnumItem<number, ConnectionError, "PlacelaunchGameEnded">
	| EnumItem<number, ConnectionError, "PlacelaunchGameFull">
	| EnumItem<number, ConnectionError, "PlacelaunchUserLeft">
	| EnumItem<number, ConnectionError, "PlacelaunchRestricted">
	| EnumItem<number, ConnectionError, "PlacelaunchUnauthorized">
	| EnumItem<number, ConnectionError, "PlacelaunchFlooded">
	| EnumItem<number, ConnectionError, "PlacelaunchHashExpired">
	| EnumItem<number, ConnectionError, "PlacelaunchHashException">
	| EnumItem<number, ConnectionError, "PlacelaunchPartyCannotFit">
	| EnumItem<number, ConnectionError, "PlacelaunchHttpError">
	| EnumItem<number, ConnectionError, "PlacelaunchUserPrivacyUnauthorized">
	| EnumItem<number, ConnectionError, "PlacelaunchCreatorBan">
	| EnumItem<number, ConnectionError, "PlacelaunchCustomMessage">
	| EnumItem<number, ConnectionError, "PlacelaunchOtherError">
	| EnumItem<number, ConnectionError, "TeleportErrors">
	| EnumItem<number, ConnectionError, "TeleportFailure">
	| EnumItem<number, ConnectionError, "TeleportGameNotFound">
	| EnumItem<number, ConnectionError, "TeleportGameEnded">
	| EnumItem<number, ConnectionError, "TeleportGameFull">
	| EnumItem<number, ConnectionError, "TeleportUnauthorized">
	| EnumItem<number, ConnectionError, "TeleportFlooded">
	| EnumItem<number, ConnectionError, "TeleportIsTeleporting">
export type ConnectionErrorRoot = EnumObject<{
	OK: EnumItem<number, ConnectionError, "OK">,
	Unknown: EnumItem<number, ConnectionError, "Unknown">,
	DisconnectErrors: EnumItem<number, ConnectionError, "DisconnectErrors">,
	DisconnectBadhash: EnumItem<number, ConnectionError, "DisconnectBadhash">,
	DisconnectSecurityKeyMismatch: EnumItem<number, ConnectionError, "DisconnectSecurityKeyMismatch">,
	DisconnectProtocolMismatch: EnumItem<number, ConnectionError, "DisconnectProtocolMismatch">,
	DisconnectReceivePacketError: EnumItem<number, ConnectionError, "DisconnectReceivePacketError">,
	DisconnectReceivePacketStreamError: EnumItem<number, ConnectionError, "DisconnectReceivePacketStreamError">,
	DisconnectSendPacketError: EnumItem<number, ConnectionError, "DisconnectSendPacketError">,
	DisconnectIllegalTeleport: EnumItem<number, ConnectionError, "DisconnectIllegalTeleport">,
	DisconnectDuplicatePlayer: EnumItem<number, ConnectionError, "DisconnectDuplicatePlayer">,
	DisconnectDuplicateTicket: EnumItem<number, ConnectionError, "DisconnectDuplicateTicket">,
	DisconnectTimeout: EnumItem<number, ConnectionError, "DisconnectTimeout">,
	DisconnectLuaKick: EnumItem<number, ConnectionError, "DisconnectLuaKick">,
	DisconnectOnRemoteSysStats: EnumItem<number, ConnectionError, "DisconnectOnRemoteSysStats">,
	DisconnectHashTimeout: EnumItem<number, ConnectionError, "DisconnectHashTimeout">,
	DisconnectCloudEditKick: EnumItem<number, ConnectionError, "DisconnectCloudEditKick">,
	DisconnectPlayerless: EnumItem<number, ConnectionError, "DisconnectPlayerless">,
	DisconnectNewSecurityKeyMismatch: EnumItem<number, ConnectionError, "DisconnectNewSecurityKeyMismatch">,
	DisconnectEvicted: EnumItem<number, ConnectionError, "DisconnectEvicted">,
	DisconnectDevMaintenance: EnumItem<number, ConnectionError, "DisconnectDevMaintenance">,
	DisconnectRobloxMaintenance: EnumItem<number, ConnectionError, "DisconnectRobloxMaintenance">,
	DisconnectRejoin: EnumItem<number, ConnectionError, "DisconnectRejoin">,
	DisconnectConnectionLost: EnumItem<number, ConnectionError, "DisconnectConnectionLost">,
	DisconnectIdle: EnumItem<number, ConnectionError, "DisconnectIdle">,
	DisconnectRaknetErrors: EnumItem<number, ConnectionError, "DisconnectRaknetErrors">,
	DisconnectWrongVersion: EnumItem<number, ConnectionError, "DisconnectWrongVersion">,
	DisconnectBySecurityPolicy: EnumItem<number, ConnectionError, "DisconnectBySecurityPolicy">,
	DisconnectBlockedIP: EnumItem<number, ConnectionError, "DisconnectBlockedIP">,
	DisconnectClientFailure: EnumItem<number, ConnectionError, "DisconnectClientFailure">,
	DisconnectClientRequest: EnumItem<number, ConnectionError, "DisconnectClientRequest">,
	DisconnectPrivateServerKickout: EnumItem<number, ConnectionError, "DisconnectPrivateServerKickout">,
	DisconnectModeratedGame: EnumItem<number, ConnectionError, "DisconnectModeratedGame">,
	ServerShutdown: EnumItem<number, ConnectionError, "ServerShutdown">,
	ReplicatorTimeout: EnumItem<number, ConnectionError, "ReplicatorTimeout">,
	PlayerRemoved: EnumItem<number, ConnectionError, "PlayerRemoved">,
	DisconnectOutOfMemoryKeepPlayingLeave: EnumItem<number, ConnectionError, "DisconnectOutOfMemoryKeepPlayingLeave">,
	DisconnectRomarkEndOfTest: EnumItem<number, ConnectionError, "DisconnectRomarkEndOfTest">,
	DisconnectCollaboratorPermissionRevoked: EnumItem<number, ConnectionError, "DisconnectCollaboratorPermissionRevoked">,
	DisconnectCollaboratorUnderage: EnumItem<number, ConnectionError, "DisconnectCollaboratorUnderage">,
	NetworkInternal: EnumItem<number, ConnectionError, "NetworkInternal">,
	NetworkSend: EnumItem<number, ConnectionError, "NetworkSend">,
	NetworkTimeout: EnumItem<number, ConnectionError, "NetworkTimeout">,
	NetworkMisbehavior: EnumItem<number, ConnectionError, "NetworkMisbehavior">,
	NetworkSecurity: EnumItem<number, ConnectionError, "NetworkSecurity">,
	ReplacementReady: EnumItem<number, ConnectionError, "ReplacementReady">,
	ServerEmpty: EnumItem<number, ConnectionError, "ServerEmpty">,
	PhantomFreeze: EnumItem<number, ConnectionError, "PhantomFreeze">,
	AndroidAnticheatKick: EnumItem<number, ConnectionError, "AndroidAnticheatKick">,
	AndroidEmulatorKick: EnumItem<number, ConnectionError, "AndroidEmulatorKick">,
	PlacelaunchErrors: EnumItem<number, ConnectionError, "PlacelaunchErrors">,
	PlacelaunchDisabled: EnumItem<number, ConnectionError, "PlacelaunchDisabled">,
	PlacelaunchError: EnumItem<number, ConnectionError, "PlacelaunchError">,
	PlacelaunchGameEnded: EnumItem<number, ConnectionError, "PlacelaunchGameEnded">,
	PlacelaunchGameFull: EnumItem<number, ConnectionError, "PlacelaunchGameFull">,
	PlacelaunchUserLeft: EnumItem<number, ConnectionError, "PlacelaunchUserLeft">,
	PlacelaunchRestricted: EnumItem<number, ConnectionError, "PlacelaunchRestricted">,
	PlacelaunchUnauthorized: EnumItem<number, ConnectionError, "PlacelaunchUnauthorized">,
	PlacelaunchFlooded: EnumItem<number, ConnectionError, "PlacelaunchFlooded">,
	PlacelaunchHashExpired: EnumItem<number, ConnectionError, "PlacelaunchHashExpired">,
	PlacelaunchHashException: EnumItem<number, ConnectionError, "PlacelaunchHashException">,
	PlacelaunchPartyCannotFit: EnumItem<number, ConnectionError, "PlacelaunchPartyCannotFit">,
	PlacelaunchHttpError: EnumItem<number, ConnectionError, "PlacelaunchHttpError">,
	PlacelaunchUserPrivacyUnauthorized: EnumItem<number, ConnectionError, "PlacelaunchUserPrivacyUnauthorized">,
	PlacelaunchCreatorBan: EnumItem<number, ConnectionError, "PlacelaunchCreatorBan">,
	PlacelaunchCustomMessage: EnumItem<number, ConnectionError, "PlacelaunchCustomMessage">,
	PlacelaunchOtherError: EnumItem<number, ConnectionError, "PlacelaunchOtherError">,
	TeleportErrors: EnumItem<number, ConnectionError, "TeleportErrors">,
	TeleportFailure: EnumItem<number, ConnectionError, "TeleportFailure">,
	TeleportGameNotFound: EnumItem<number, ConnectionError, "TeleportGameNotFound">,
	TeleportGameEnded: EnumItem<number, ConnectionError, "TeleportGameEnded">,
	TeleportGameFull: EnumItem<number, ConnectionError, "TeleportGameFull">,
	TeleportUnauthorized: EnumItem<number, ConnectionError, "TeleportUnauthorized">,
	TeleportFlooded: EnumItem<number, ConnectionError, "TeleportFlooded">,
	TeleportIsTeleporting: EnumItem<number, ConnectionError, "TeleportIsTeleporting">,
}, ConnectionError>
Enum.ConnectionError = {
	OK = 0;
	Unknown = 1;
	DisconnectErrors = 256;
	DisconnectBadhash = 257;
	DisconnectSecurityKeyMismatch = 258;
	DisconnectProtocolMismatch = 259;
	DisconnectReceivePacketError = 260;
	DisconnectReceivePacketStreamError = 261;
	DisconnectSendPacketError = 262;
	DisconnectIllegalTeleport = 263;
	DisconnectDuplicatePlayer = 264;
	DisconnectDuplicateTicket = 265;
	DisconnectTimeout = 266;
	DisconnectLuaKick = 267;
	DisconnectOnRemoteSysStats = 268;
	DisconnectHashTimeout = 269;
	DisconnectCloudEditKick = 270;
	DisconnectPlayerless = 271;
	DisconnectNewSecurityKeyMismatch = 272;
	DisconnectEvicted = 273;
	DisconnectDevMaintenance = 274;
	DisconnectRobloxMaintenance = 275;
	DisconnectRejoin = 276;
	DisconnectConnectionLost = 277;
	DisconnectIdle = 278;
	DisconnectRaknetErrors = 279;
	DisconnectWrongVersion = 280;
	DisconnectBySecurityPolicy = 281;
	DisconnectBlockedIP = 282;
	DisconnectClientFailure = 284;
	DisconnectClientRequest = 285;
	DisconnectPrivateServerKickout = 286;
	DisconnectModeratedGame = 287;
	ServerShutdown = 288;
	ReplicatorTimeout = 290;
	PlayerRemoved = 291;
	DisconnectOutOfMemoryKeepPlayingLeave = 292;
	DisconnectRomarkEndOfTest = 293;
	DisconnectCollaboratorPermissionRevoked = 294;
	DisconnectCollaboratorUnderage = 295;
	NetworkInternal = 296;
	NetworkSend = 297;
	NetworkTimeout = 298;
	NetworkMisbehavior = 299;
	NetworkSecurity = 300;
	ReplacementReady = 301;
	ServerEmpty = 302;
	PhantomFreeze = 303;
	AndroidAnticheatKick = 304;
	AndroidEmulatorKick = 305;
	PlacelaunchErrors = 512;
	PlacelaunchDisabled = 515;
	PlacelaunchError = 516;
	PlacelaunchGameEnded = 517;
	PlacelaunchGameFull = 518;
	PlacelaunchUserLeft = 522;
	PlacelaunchRestricted = 523;
	PlacelaunchUnauthorized = 524;
	PlacelaunchFlooded = 525;
	PlacelaunchHashExpired = 526;
	PlacelaunchHashException = 527;
	PlacelaunchPartyCannotFit = 528;
	PlacelaunchHttpError = 529;
	PlacelaunchUserPrivacyUnauthorized = 533;
	PlacelaunchCreatorBan = 600;
	PlacelaunchCustomMessage = 610;
	PlacelaunchOtherError = 611;
	TeleportErrors = 768;
	TeleportFailure = 769;
	TeleportGameNotFound = 770;
	TeleportGameEnded = 771;
	TeleportGameFull = 772;
	TeleportUnauthorized = 773;
	TeleportFlooded = 774;
	TeleportIsTeleporting = 775;
}

export type ConnectionState =
	| EnumItem<number, ConnectionState, "Connected">
	| EnumItem<number, ConnectionState, "Disconnected">
export type ConnectionStateRoot = EnumObject<{
	Connected: EnumItem<number, ConnectionState, "Connected">,
	Disconnected: EnumItem<number, ConnectionState, "Disconnected">,
}, ConnectionState>
Enum.ConnectionState = {"Connected", "Disconnected"}

export type ContentSourceType =
	| EnumItem<number, ContentSourceType, "None">
	| EnumItem<number, ContentSourceType, "Uri">
	| EnumItem<number, ContentSourceType, "Object">
export type ContentSourceTypeRoot = EnumObject<{
	None: EnumItem<number, ContentSourceType, "None">,
	Uri: EnumItem<number, ContentSourceType, "Uri">,
	Object: EnumItem<number, ContentSourceType, "Object">,
}, ContentSourceType>
Enum.ContentSourceType = {"None", "Uri", "Object"}

export type ContextActionPriority =
	| EnumItem<number, ContextActionPriority, "Low">
	| EnumItem<number, ContextActionPriority, "Medium">
	| EnumItem<number, ContextActionPriority, "High">
export type ContextActionPriorityRoot = EnumObject<{
	Low: EnumItem<number, ContextActionPriority, "Low">,
	Medium: EnumItem<number, ContextActionPriority, "Medium">,
	High: EnumItem<number, ContextActionPriority, "High">,
}, ContextActionPriority>
Enum.ContextActionPriority = {
	Low = 1000;
	Medium = 2000;
	High = 3000;
}

export type ContextActionResult =
	| EnumItem<number, ContextActionResult, "Sink">
	| EnumItem<number, ContextActionResult, "Pass">
export type ContextActionResultRoot = EnumObject<{
	Sink: EnumItem<number, ContextActionResult, "Sink">,
	Pass: EnumItem<number, ContextActionResult, "Pass">,
}, ContextActionResult>
Enum.ContextActionResult = {"Sink", "Pass"}

export type ControlMode = | EnumItem<number, ControlMode, "Classic"> | EnumItem<number, ControlMode, "MouseLockSwitch">
export type ControlModeRoot = EnumObject<{
	Classic: EnumItem<number, ControlMode, "Classic">,
	MouseLockSwitch: EnumItem<number, ControlMode, "MouseLockSwitch">,
}, ControlMode>
Enum.ControlMode = {"Classic", "MouseLockSwitch"}

export type CoreGuiType =
	| EnumItem<number, CoreGuiType, "PlayerList">
	| EnumItem<number, CoreGuiType, "Health">
	| EnumItem<number, CoreGuiType, "Backpack">
	| EnumItem<number, CoreGuiType, "Chat">
	| EnumItem<number, CoreGuiType, "All">
	| EnumItem<number, CoreGuiType, "EmotesMenu">
	| EnumItem<number, CoreGuiType, "SelfView">
	| EnumItem<number, CoreGuiType, "Captures">
export type CoreGuiTypeRoot = EnumObject<{
	PlayerList: EnumItem<number, CoreGuiType, "PlayerList">,
	Health: EnumItem<number, CoreGuiType, "Health">,
	Backpack: EnumItem<number, CoreGuiType, "Backpack">,
	Chat: EnumItem<number, CoreGuiType, "Chat">,
	All: EnumItem<number, CoreGuiType, "All">,
	EmotesMenu: EnumItem<number, CoreGuiType, "EmotesMenu">,
	SelfView: EnumItem<number, CoreGuiType, "SelfView">,
	Captures: EnumItem<number, CoreGuiType, "Captures">,
}, CoreGuiType>
Enum.CoreGuiType = {"PlayerList", "Health", "Backpack", "Chat", "All", "EmotesMenu", "SelfView", "Captures"}

export type CreateAssetResult =
	| EnumItem<number, CreateAssetResult, "Success">
	| EnumItem<number, CreateAssetResult, "PermissionDenied">
	| EnumItem<number, CreateAssetResult, "UploadFailed">
	| EnumItem<number, CreateAssetResult, "Unknown">
export type CreateAssetResultRoot = EnumObject<{
	Success: EnumItem<number, CreateAssetResult, "Success">,
	PermissionDenied: EnumItem<number, CreateAssetResult, "PermissionDenied">,
	UploadFailed: EnumItem<number, CreateAssetResult, "UploadFailed">,
	Unknown: EnumItem<number, CreateAssetResult, "Unknown">,
}, CreateAssetResult>
Enum.CreateAssetResult = {
	Success = 1;
	PermissionDenied = 2;
	UploadFailed = 3;
	Unknown = 4;
}

export type CreateOutfitFailure =
	| EnumItem<number, CreateOutfitFailure, "InvalidName">
	| EnumItem<number, CreateOutfitFailure, "OutfitLimitReached">
	| EnumItem<number, CreateOutfitFailure, "Other">
export type CreateOutfitFailureRoot = EnumObject<{
	InvalidName: EnumItem<number, CreateOutfitFailure, "InvalidName">,
	OutfitLimitReached: EnumItem<number, CreateOutfitFailure, "OutfitLimitReached">,
	Other: EnumItem<number, CreateOutfitFailure, "Other">,
}, CreateOutfitFailure>
Enum.CreateOutfitFailure = {
	InvalidName = 1;
	OutfitLimitReached = 2;
	Other = 3;
}

export type CreatorType = | EnumItem<number, CreatorType, "User"> | EnumItem<number, CreatorType, "Group">
export type CreatorTypeRoot = EnumObject<{
	User: EnumItem<number, CreatorType, "User">,
	Group: EnumItem<number, CreatorType, "Group">,
}, CreatorType>
Enum.CreatorType = {"User", "Group"}

export type CreatorTypeFilter =
	| EnumItem<number, CreatorTypeFilter, "User">
	| EnumItem<number, CreatorTypeFilter, "Group">
	| EnumItem<number, CreatorTypeFilter, "All">
export type CreatorTypeFilterRoot = EnumObject<{
	User: EnumItem<number, CreatorTypeFilter, "User">,
	Group: EnumItem<number, CreatorTypeFilter, "Group">,
	All: EnumItem<number, CreatorTypeFilter, "All">,
}, CreatorTypeFilter>
Enum.CreatorTypeFilter = {"User", "Group", "All"}

export type CurrencyType =
	| EnumItem<number, CurrencyType, "Default">
	| EnumItem<number, CurrencyType, "Robux">
	| EnumItem<number, CurrencyType, "Tix">
export type CurrencyTypeRoot = EnumObject<{
	Default: EnumItem<number, CurrencyType, "Default">,
	Robux: EnumItem<number, CurrencyType, "Robux">,
	Tix: EnumItem<number, CurrencyType, "Tix">,
}, CurrencyType>
Enum.CurrencyType = {"Default", "Robux", "Tix"}

export type CustomCameraMode =
	| EnumItem<number, CustomCameraMode, "Default">
	| EnumItem<number, CustomCameraMode, "Classic">
	| EnumItem<number, CustomCameraMode, "Follow">
export type CustomCameraModeRoot = EnumObject<{
	Default: EnumItem<number, CustomCameraMode, "Default">,
	Classic: EnumItem<number, CustomCameraMode, "Classic">,
	Follow: EnumItem<number, CustomCameraMode, "Follow">,
}, CustomCameraMode>
Enum.CustomCameraMode = {"Default", "Classic", "Follow"}

export type DataStoreRequestType =
	| EnumItem<number, DataStoreRequestType, "GetAsync">
	| EnumItem<number, DataStoreRequestType, "SetIncrementAsync">
	| EnumItem<number, DataStoreRequestType, "UpdateAsync">
	| EnumItem<number, DataStoreRequestType, "GetSortedAsync">
	| EnumItem<number, DataStoreRequestType, "SetIncrementSortedAsync">
	| EnumItem<number, DataStoreRequestType, "OnUpdate">
	| EnumItem<number, DataStoreRequestType, "ListAsync">
	| EnumItem<number, DataStoreRequestType, "GetVersionAsync">
	| EnumItem<number, DataStoreRequestType, "RemoveVersionAsync">
export type DataStoreRequestTypeRoot = EnumObject<{
	GetAsync: EnumItem<number, DataStoreRequestType, "GetAsync">,
	SetIncrementAsync: EnumItem<number, DataStoreRequestType, "SetIncrementAsync">,
	UpdateAsync: EnumItem<number, DataStoreRequestType, "UpdateAsync">,
	GetSortedAsync: EnumItem<number, DataStoreRequestType, "GetSortedAsync">,
	SetIncrementSortedAsync: EnumItem<number, DataStoreRequestType, "SetIncrementSortedAsync">,
	OnUpdate: EnumItem<number, DataStoreRequestType, "OnUpdate">,
	ListAsync: EnumItem<number, DataStoreRequestType, "ListAsync">,
	GetVersionAsync: EnumItem<number, DataStoreRequestType, "GetVersionAsync">,
	RemoveVersionAsync: EnumItem<number, DataStoreRequestType, "RemoveVersionAsync">,
}, DataStoreRequestType>
Enum.DataStoreRequestType = {
	"GetAsync";
	"SetIncrementAsync";
	"UpdateAsync";
	"GetSortedAsync";
	"SetIncrementSortedAsync";
	"OnUpdate";
	"ListAsync";
	"GetVersionAsync";
	"RemoveVersionAsync";
}

export type DebuggerEndReason =
	| EnumItem<number, DebuggerEndReason, "ClientRequest">
	| EnumItem<number, DebuggerEndReason, "Timeout">
	| EnumItem<number, DebuggerEndReason, "InvalidHost">
	| EnumItem<number, DebuggerEndReason, "Disconnected">
	| EnumItem<number, DebuggerEndReason, "ServerShutdown">
	| EnumItem<number, DebuggerEndReason, "ServerProtocolMismatch">
	| EnumItem<number, DebuggerEndReason, "ConfigurationFailed">
	| EnumItem<number, DebuggerEndReason, "RpcError">
export type DebuggerEndReasonRoot = EnumObject<{
	ClientRequest: EnumItem<number, DebuggerEndReason, "ClientRequest">,
	Timeout: EnumItem<number, DebuggerEndReason, "Timeout">,
	InvalidHost: EnumItem<number, DebuggerEndReason, "InvalidHost">,
	Disconnected: EnumItem<number, DebuggerEndReason, "Disconnected">,
	ServerShutdown: EnumItem<number, DebuggerEndReason, "ServerShutdown">,
	ServerProtocolMismatch: EnumItem<number, DebuggerEndReason, "ServerProtocolMismatch">,
	ConfigurationFailed: EnumItem<number, DebuggerEndReason, "ConfigurationFailed">,
	RpcError: EnumItem<number, DebuggerEndReason, "RpcError">,
}, DebuggerEndReason>
Enum.DebuggerEndReason = {
	"ClientRequest";
	"Timeout";
	"InvalidHost";
	"Disconnected";
	"ServerShutdown";
	"ServerProtocolMismatch";
	"ConfigurationFailed";
	"RpcError";
}

export type DebuggerExceptionBreakMode =
	| EnumItem<number, DebuggerExceptionBreakMode, "Never">
	| EnumItem<number, DebuggerExceptionBreakMode, "Always">
	| EnumItem<number, DebuggerExceptionBreakMode, "Unhandled">
export type DebuggerExceptionBreakModeRoot = EnumObject<{
	Never: EnumItem<number, DebuggerExceptionBreakMode, "Never">,
	Always: EnumItem<number, DebuggerExceptionBreakMode, "Always">,
	Unhandled: EnumItem<number, DebuggerExceptionBreakMode, "Unhandled">,
}, DebuggerExceptionBreakMode>
Enum.DebuggerExceptionBreakMode = {"Never", "Always", "Unhandled"}

export type DebuggerFrameType = | EnumItem<number, DebuggerFrameType, "C"> | EnumItem<number, DebuggerFrameType, "Lua">
export type DebuggerFrameTypeRoot = EnumObject<{
	C: EnumItem<number, DebuggerFrameType, "C">,
	Lua: EnumItem<number, DebuggerFrameType, "Lua">,
}, DebuggerFrameType>
Enum.DebuggerFrameType = {"C", "Lua"}

export type DebuggerPauseReason =
	| EnumItem<number, DebuggerPauseReason, "Unknown">
	| EnumItem<number, DebuggerPauseReason, "Requested">
	| EnumItem<number, DebuggerPauseReason, "Breakpoint">
	| EnumItem<number, DebuggerPauseReason, "Exception">
	| EnumItem<number, DebuggerPauseReason, "SingleStep">
	| EnumItem<number, DebuggerPauseReason, "Entrypoint">
export type DebuggerPauseReasonRoot = EnumObject<{
	Unknown: EnumItem<number, DebuggerPauseReason, "Unknown">,
	Requested: EnumItem<number, DebuggerPauseReason, "Requested">,
	Breakpoint: EnumItem<number, DebuggerPauseReason, "Breakpoint">,
	Exception: EnumItem<number, DebuggerPauseReason, "Exception">,
	SingleStep: EnumItem<number, DebuggerPauseReason, "SingleStep">,
	Entrypoint: EnumItem<number, DebuggerPauseReason, "Entrypoint">,
}, DebuggerPauseReason>
Enum.DebuggerPauseReason = {"Unknown", "Requested", "Breakpoint", "Exception", "SingleStep", "Entrypoint"}

export type DebuggerStatus =
	| EnumItem<number, DebuggerStatus, "Success">
	| EnumItem<number, DebuggerStatus, "Timeout">
	| EnumItem<number, DebuggerStatus, "ConnectionLost">
	| EnumItem<number, DebuggerStatus, "InvalidResponse">
	| EnumItem<number, DebuggerStatus, "InternalError">
	| EnumItem<number, DebuggerStatus, "InvalidState">
	| EnumItem<number, DebuggerStatus, "RpcError">
	| EnumItem<number, DebuggerStatus, "InvalidArgument">
	| EnumItem<number, DebuggerStatus, "ConnectionClosed">
export type DebuggerStatusRoot = EnumObject<{
	Success: EnumItem<number, DebuggerStatus, "Success">,
	Timeout: EnumItem<number, DebuggerStatus, "Timeout">,
	ConnectionLost: EnumItem<number, DebuggerStatus, "ConnectionLost">,
	InvalidResponse: EnumItem<number, DebuggerStatus, "InvalidResponse">,
	InternalError: EnumItem<number, DebuggerStatus, "InternalError">,
	InvalidState: EnumItem<number, DebuggerStatus, "InvalidState">,
	RpcError: EnumItem<number, DebuggerStatus, "RpcError">,
	InvalidArgument: EnumItem<number, DebuggerStatus, "InvalidArgument">,
	ConnectionClosed: EnumItem<number, DebuggerStatus, "ConnectionClosed">,
}, DebuggerStatus>
Enum.DebuggerStatus = {
	"Success";
	"Timeout";
	"ConnectionLost";
	"InvalidResponse";
	"InternalError";
	"InvalidState";
	"RpcError";
	"InvalidArgument";
	"ConnectionClosed";
}

export type DevCameraOcclusionMode =
	| EnumItem<number, DevCameraOcclusionMode, "Zoom">
	| EnumItem<number, DevCameraOcclusionMode, "Invisicam">
export type DevCameraOcclusionModeRoot = EnumObject<{
	Zoom: EnumItem<number, DevCameraOcclusionMode, "Zoom">,
	Invisicam: EnumItem<number, DevCameraOcclusionMode, "Invisicam">,
}, DevCameraOcclusionMode>
Enum.DevCameraOcclusionMode = {"Zoom", "Invisicam"}

export type DevComputerCameraMovementMode =
	| EnumItem<number, DevComputerCameraMovementMode, "UserChoice">
	| EnumItem<number, DevComputerCameraMovementMode, "Classic">
	| EnumItem<number, DevComputerCameraMovementMode, "Follow">
	| EnumItem<number, DevComputerCameraMovementMode, "Orbital">
	| EnumItem<number, DevComputerCameraMovementMode, "CameraToggle">
export type DevComputerCameraMovementModeRoot = EnumObject<{
	UserChoice: EnumItem<number, DevComputerCameraMovementMode, "UserChoice">,
	Classic: EnumItem<number, DevComputerCameraMovementMode, "Classic">,
	Follow: EnumItem<number, DevComputerCameraMovementMode, "Follow">,
	Orbital: EnumItem<number, DevComputerCameraMovementMode, "Orbital">,
	CameraToggle: EnumItem<number, DevComputerCameraMovementMode, "CameraToggle">,
}, DevComputerCameraMovementMode>
Enum.DevComputerCameraMovementMode = {"UserChoice", "Classic", "Follow", "Orbital", "CameraToggle"}

export type DevComputerMovementMode =
	| EnumItem<number, DevComputerMovementMode, "UserChoice">
	| EnumItem<number, DevComputerMovementMode, "KeyboardMouse">
	| EnumItem<number, DevComputerMovementMode, "ClickToMove">
	| EnumItem<number, DevComputerMovementMode, "Scriptable">
export type DevComputerMovementModeRoot = EnumObject<{
	UserChoice: EnumItem<number, DevComputerMovementMode, "UserChoice">,
	KeyboardMouse: EnumItem<number, DevComputerMovementMode, "KeyboardMouse">,
	ClickToMove: EnumItem<number, DevComputerMovementMode, "ClickToMove">,
	Scriptable: EnumItem<number, DevComputerMovementMode, "Scriptable">,
}, DevComputerMovementMode>
Enum.DevComputerMovementMode = {"UserChoice", "KeyboardMouse", "ClickToMove", "Scriptable"}

export type DevTouchCameraMovementMode =
	| EnumItem<number, DevTouchCameraMovementMode, "UserChoice">
	| EnumItem<number, DevTouchCameraMovementMode, "Classic">
	| EnumItem<number, DevTouchCameraMovementMode, "Follow">
	| EnumItem<number, DevTouchCameraMovementMode, "Orbital">
export type DevTouchCameraMovementModeRoot = EnumObject<{
	UserChoice: EnumItem<number, DevTouchCameraMovementMode, "UserChoice">,
	Classic: EnumItem<number, DevTouchCameraMovementMode, "Classic">,
	Follow: EnumItem<number, DevTouchCameraMovementMode, "Follow">,
	Orbital: EnumItem<number, DevTouchCameraMovementMode, "Orbital">,
}, DevTouchCameraMovementMode>
Enum.DevTouchCameraMovementMode = {"UserChoice", "Classic", "Follow", "Orbital"}

export type DevTouchMovementMode =
	| EnumItem<number, DevTouchMovementMode, "UserChoice">
	| EnumItem<number, DevTouchMovementMode, "Thumbstick">
	| EnumItem<number, DevTouchMovementMode, "DPad">
	| EnumItem<number, DevTouchMovementMode, "Thumbpad">
	| EnumItem<number, DevTouchMovementMode, "ClickToMove">
	| EnumItem<number, DevTouchMovementMode, "Scriptable">
	| EnumItem<number, DevTouchMovementMode, "DynamicThumbstick">
export type DevTouchMovementModeRoot = EnumObject<{
	UserChoice: EnumItem<number, DevTouchMovementMode, "UserChoice">,
	Thumbstick: EnumItem<number, DevTouchMovementMode, "Thumbstick">,
	DPad: EnumItem<number, DevTouchMovementMode, "DPad">,
	Thumbpad: EnumItem<number, DevTouchMovementMode, "Thumbpad">,
	ClickToMove: EnumItem<number, DevTouchMovementMode, "ClickToMove">,
	Scriptable: EnumItem<number, DevTouchMovementMode, "Scriptable">,
	DynamicThumbstick: EnumItem<number, DevTouchMovementMode, "DynamicThumbstick">,
}, DevTouchMovementMode>
Enum.DevTouchMovementMode =
	{"UserChoice", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "Scriptable", "DynamicThumbstick"}

export type DeveloperMemoryTag =
	| EnumItem<number, DeveloperMemoryTag, "Internal">
	| EnumItem<number, DeveloperMemoryTag, "HttpCache">
	| EnumItem<number, DeveloperMemoryTag, "Instances">
	| EnumItem<number, DeveloperMemoryTag, "Signals">
	| EnumItem<number, DeveloperMemoryTag, "LuaHeap">
	| EnumItem<number, DeveloperMemoryTag, "Script">
	| EnumItem<number, DeveloperMemoryTag, "PhysicsCollision">
	| EnumItem<number, DeveloperMemoryTag, "PhysicsParts">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsSolidModels">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsMeshParts">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsParticles">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsParts">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsSpatialHash">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsTerrain">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsTexture">
	| EnumItem<number, DeveloperMemoryTag, "GraphicsTextureCharacter">
	| EnumItem<number, DeveloperMemoryTag, "Sounds">
	| EnumItem<number, DeveloperMemoryTag, "StreamingSounds">
	| EnumItem<number, DeveloperMemoryTag, "TerrainVoxels">
	| EnumItem<number, DeveloperMemoryTag, "Gui">
	| EnumItem<number, DeveloperMemoryTag, "Animation">
	| EnumItem<number, DeveloperMemoryTag, "Navigation">
	| EnumItem<number, DeveloperMemoryTag, "GeometryCSG">
export type DeveloperMemoryTagRoot = EnumObject<{
	Internal: EnumItem<number, DeveloperMemoryTag, "Internal">,
	HttpCache: EnumItem<number, DeveloperMemoryTag, "HttpCache">,
	Instances: EnumItem<number, DeveloperMemoryTag, "Instances">,
	Signals: EnumItem<number, DeveloperMemoryTag, "Signals">,
	LuaHeap: EnumItem<number, DeveloperMemoryTag, "LuaHeap">,
	Script: EnumItem<number, DeveloperMemoryTag, "Script">,
	PhysicsCollision: EnumItem<number, DeveloperMemoryTag, "PhysicsCollision">,
	PhysicsParts: EnumItem<number, DeveloperMemoryTag, "PhysicsParts">,
	GraphicsSolidModels: EnumItem<number, DeveloperMemoryTag, "GraphicsSolidModels">,
	GraphicsMeshParts: EnumItem<number, DeveloperMemoryTag, "GraphicsMeshParts">,
	GraphicsParticles: EnumItem<number, DeveloperMemoryTag, "GraphicsParticles">,
	GraphicsParts: EnumItem<number, DeveloperMemoryTag, "GraphicsParts">,
	GraphicsSpatialHash: EnumItem<number, DeveloperMemoryTag, "GraphicsSpatialHash">,
	GraphicsTerrain: EnumItem<number, DeveloperMemoryTag, "GraphicsTerrain">,
	GraphicsTexture: EnumItem<number, DeveloperMemoryTag, "GraphicsTexture">,
	GraphicsTextureCharacter: EnumItem<number, DeveloperMemoryTag, "GraphicsTextureCharacter">,
	Sounds: EnumItem<number, DeveloperMemoryTag, "Sounds">,
	StreamingSounds: EnumItem<number, DeveloperMemoryTag, "StreamingSounds">,
	TerrainVoxels: EnumItem<number, DeveloperMemoryTag, "TerrainVoxels">,
	Gui: EnumItem<number, DeveloperMemoryTag, "Gui">,
	Animation: EnumItem<number, DeveloperMemoryTag, "Animation">,
	Navigation: EnumItem<number, DeveloperMemoryTag, "Navigation">,
	GeometryCSG: EnumItem<number, DeveloperMemoryTag, "GeometryCSG">,
}, DeveloperMemoryTag>
Enum.DeveloperMemoryTag = {
	Internal = 0;
	HttpCache = 1;
	Instances = 2;
	Signals = 3;
	LuaHeap = 4;
	Script = 5;
	PhysicsCollision = 6;
	PhysicsParts = 7;
	GraphicsSolidModels = 8;
	GraphicsMeshParts = 10;
	GraphicsParticles = 11;
	GraphicsParts = 12;
	GraphicsSpatialHash = 13;
	GraphicsTerrain = 14;
	GraphicsTexture = 15;
	GraphicsTextureCharacter = 16;
	Sounds = 17;
	StreamingSounds = 18;
	TerrainVoxels = 19;
	Gui = 21;
	Animation = 22;
	Navigation = 23;
	GeometryCSG = 24;
}

export type DeviceFeatureType = | EnumItem<number, DeviceFeatureType, "DeviceCapture">
export type DeviceFeatureTypeRoot = EnumObject<{
	DeviceCapture: EnumItem<number, DeviceFeatureType, "DeviceCapture">,
}, DeviceFeatureType>
Enum.DeviceFeatureType = {"DeviceCapture"}

export type DeviceForm =
	| EnumItem<number, DeviceForm, "Console">
	| EnumItem<number, DeviceForm, "Phone">
	| EnumItem<number, DeviceForm, "Tablet">
	| EnumItem<number, DeviceForm, "Desktop">
	| EnumItem<number, DeviceForm, "VR">
export type DeviceFormRoot = EnumObject<{
	Console: EnumItem<number, DeviceForm, "Console">,
	Phone: EnumItem<number, DeviceForm, "Phone">,
	Tablet: EnumItem<number, DeviceForm, "Tablet">,
	Desktop: EnumItem<number, DeviceForm, "Desktop">,
	VR: EnumItem<number, DeviceForm, "VR">,
}, DeviceForm>
Enum.DeviceForm = {"Console", "Phone", "Tablet", "Desktop", "VR"}

export type DeviceLevel =
	| EnumItem<number, DeviceLevel, "Low">
	| EnumItem<number, DeviceLevel, "Medium">
	| EnumItem<number, DeviceLevel, "High">
export type DeviceLevelRoot = EnumObject<{
	Low: EnumItem<number, DeviceLevel, "Low">,
	Medium: EnumItem<number, DeviceLevel, "Medium">,
	High: EnumItem<number, DeviceLevel, "High">,
}, DeviceLevel>
Enum.DeviceLevel = {"Low", "Medium", "High"}

export type DeviceType =
	| EnumItem<number, DeviceType, "Unknown">
	| EnumItem<number, DeviceType, "Desktop">
	| EnumItem<number, DeviceType, "Tablet">
	| EnumItem<number, DeviceType, "Phone">
export type DeviceTypeRoot = EnumObject<{
	Unknown: EnumItem<number, DeviceType, "Unknown">,
	Desktop: EnumItem<number, DeviceType, "Desktop">,
	Tablet: EnumItem<number, DeviceType, "Tablet">,
	Phone: EnumItem<number, DeviceType, "Phone">,
}, DeviceType>
Enum.DeviceType = {"Unknown", "Desktop", "Tablet", "Phone"}

export type DialogBehaviorType =
	| EnumItem<number, DialogBehaviorType, "SinglePlayer">
	| EnumItem<number, DialogBehaviorType, "MultiplePlayers">
export type DialogBehaviorTypeRoot = EnumObject<{
	SinglePlayer: EnumItem<number, DialogBehaviorType, "SinglePlayer">,
	MultiplePlayers: EnumItem<number, DialogBehaviorType, "MultiplePlayers">,
}, DialogBehaviorType>
Enum.DialogBehaviorType = {"SinglePlayer", "MultiplePlayers"}

export type DialogPurpose =
	| EnumItem<number, DialogPurpose, "Quest">
	| EnumItem<number, DialogPurpose, "Help">
	| EnumItem<number, DialogPurpose, "Shop">
export type DialogPurposeRoot = EnumObject<{
	Quest: EnumItem<number, DialogPurpose, "Quest">,
	Help: EnumItem<number, DialogPurpose, "Help">,
	Shop: EnumItem<number, DialogPurpose, "Shop">,
}, DialogPurpose>
Enum.DialogPurpose = {"Quest", "Help", "Shop"}

export type DialogTone =
	| EnumItem<number, DialogTone, "Neutral">
	| EnumItem<number, DialogTone, "Friendly">
	| EnumItem<number, DialogTone, "Enemy">
export type DialogToneRoot = EnumObject<{
	Neutral: EnumItem<number, DialogTone, "Neutral">,
	Friendly: EnumItem<number, DialogTone, "Friendly">,
	Enemy: EnumItem<number, DialogTone, "Enemy">,
}, DialogTone>
Enum.DialogTone = {"Neutral", "Friendly", "Enemy"}

export type DominantAxis = | EnumItem<number, DominantAxis, "Width"> | EnumItem<number, DominantAxis, "Height">
export type DominantAxisRoot = EnumObject<{
	Width: EnumItem<number, DominantAxis, "Width">,
	Height: EnumItem<number, DominantAxis, "Height">,
}, DominantAxis>
Enum.DominantAxis = {"Width", "Height"}

export type DraftStatusCode =
	| EnumItem<number, DraftStatusCode, "OK">
	| EnumItem<number, DraftStatusCode, "DraftOutdated">
	| EnumItem<number, DraftStatusCode, "ScriptRemoved">
	| EnumItem<number, DraftStatusCode, "DraftCommitted">
export type DraftStatusCodeRoot = EnumObject<{
	OK: EnumItem<number, DraftStatusCode, "OK">,
	DraftOutdated: EnumItem<number, DraftStatusCode, "DraftOutdated">,
	ScriptRemoved: EnumItem<number, DraftStatusCode, "ScriptRemoved">,
	DraftCommitted: EnumItem<number, DraftStatusCode, "DraftCommitted">,
}, DraftStatusCode>
Enum.DraftStatusCode = {"OK", "DraftOutdated", "ScriptRemoved", "DraftCommitted"}

export type DragDetectorDragStyle =
	| EnumItem<number, DragDetectorDragStyle, "TranslateLine">
	| EnumItem<number, DragDetectorDragStyle, "TranslatePlane">
	| EnumItem<number, DragDetectorDragStyle, "TranslatePlaneOrLine">
	| EnumItem<number, DragDetectorDragStyle, "TranslateLineOrPlane">
	| EnumItem<number, DragDetectorDragStyle, "TranslateViewPlane">
	| EnumItem<number, DragDetectorDragStyle, "RotateAxis">
	| EnumItem<number, DragDetectorDragStyle, "RotateTrackball">
	| EnumItem<number, DragDetectorDragStyle, "Scriptable">
	| EnumItem<number, DragDetectorDragStyle, "BestForDevice">
export type DragDetectorDragStyleRoot = EnumObject<{
	TranslateLine: EnumItem<number, DragDetectorDragStyle, "TranslateLine">,
	TranslatePlane: EnumItem<number, DragDetectorDragStyle, "TranslatePlane">,
	TranslatePlaneOrLine: EnumItem<number, DragDetectorDragStyle, "TranslatePlaneOrLine">,
	TranslateLineOrPlane: EnumItem<number, DragDetectorDragStyle, "TranslateLineOrPlane">,
	TranslateViewPlane: EnumItem<number, DragDetectorDragStyle, "TranslateViewPlane">,
	RotateAxis: EnumItem<number, DragDetectorDragStyle, "RotateAxis">,
	RotateTrackball: EnumItem<number, DragDetectorDragStyle, "RotateTrackball">,
	Scriptable: EnumItem<number, DragDetectorDragStyle, "Scriptable">,
	BestForDevice: EnumItem<number, DragDetectorDragStyle, "BestForDevice">,
}, DragDetectorDragStyle>
Enum.DragDetectorDragStyle = {
	"TranslateLine";
	"TranslatePlane";
	"TranslatePlaneOrLine";
	"TranslateLineOrPlane";
	"TranslateViewPlane";
	"RotateAxis";
	"RotateTrackball";
	"Scriptable";
	"BestForDevice";
}

export type DragDetectorPermissionPolicy =
	| EnumItem<number, DragDetectorPermissionPolicy, "Nobody">
	| EnumItem<number, DragDetectorPermissionPolicy, "Everybody">
	| EnumItem<number, DragDetectorPermissionPolicy, "Scriptable">
export type DragDetectorPermissionPolicyRoot = EnumObject<{
	Nobody: EnumItem<number, DragDetectorPermissionPolicy, "Nobody">,
	Everybody: EnumItem<number, DragDetectorPermissionPolicy, "Everybody">,
	Scriptable: EnumItem<number, DragDetectorPermissionPolicy, "Scriptable">,
}, DragDetectorPermissionPolicy>
Enum.DragDetectorPermissionPolicy = {"Nobody", "Everybody", "Scriptable"}

export type DragDetectorResponseStyle =
	| EnumItem<number, DragDetectorResponseStyle, "Geometric">
	| EnumItem<number, DragDetectorResponseStyle, "Physical">
	| EnumItem<number, DragDetectorResponseStyle, "Custom">
export type DragDetectorResponseStyleRoot = EnumObject<{
	Geometric: EnumItem<number, DragDetectorResponseStyle, "Geometric">,
	Physical: EnumItem<number, DragDetectorResponseStyle, "Physical">,
	Custom: EnumItem<number, DragDetectorResponseStyle, "Custom">,
}, DragDetectorResponseStyle>
Enum.DragDetectorResponseStyle = {"Geometric", "Physical", "Custom"}

export type DraggerCoordinateSpace =
	| EnumItem<number, DraggerCoordinateSpace, "Object">
	| EnumItem<number, DraggerCoordinateSpace, "World">
export type DraggerCoordinateSpaceRoot = EnumObject<{
	Object: EnumItem<number, DraggerCoordinateSpace, "Object">,
	World: EnumItem<number, DraggerCoordinateSpace, "World">,
}, DraggerCoordinateSpace>
Enum.DraggerCoordinateSpace = {"Object", "World"}

export type DraggerMovementMode =
	| EnumItem<number, DraggerMovementMode, "Geometric">
	| EnumItem<number, DraggerMovementMode, "Physical">
export type DraggerMovementModeRoot = EnumObject<{
	Geometric: EnumItem<number, DraggerMovementMode, "Geometric">,
	Physical: EnumItem<number, DraggerMovementMode, "Physical">,
}, DraggerMovementMode>
Enum.DraggerMovementMode = {"Geometric", "Physical"}

export type DraggingScrollBar =
	| EnumItem<number, DraggingScrollBar, "None">
	| EnumItem<number, DraggingScrollBar, "Horizontal">
	| EnumItem<number, DraggingScrollBar, "Vertical">
export type DraggingScrollBarRoot = EnumObject<{
	None: EnumItem<number, DraggingScrollBar, "None">,
	Horizontal: EnumItem<number, DraggingScrollBar, "Horizontal">,
	Vertical: EnumItem<number, DraggingScrollBar, "Vertical">,
}, DraggingScrollBar>
Enum.DraggingScrollBar = {"None", "Horizontal", "Vertical"}

export type EasingDirection =
	| EnumItem<number, EasingDirection, "In">
	| EnumItem<number, EasingDirection, "Out">
	| EnumItem<number, EasingDirection, "InOut">
export type EasingDirectionRoot = EnumObject<{
	In: EnumItem<number, EasingDirection, "In">,
	Out: EnumItem<number, EasingDirection, "Out">,
	InOut: EnumItem<number, EasingDirection, "InOut">,
}, EasingDirection>
Enum.EasingDirection = {"In", "Out", "InOut"}

export type EasingStyle =
	| EnumItem<number, EasingStyle, "Linear">
	| EnumItem<number, EasingStyle, "Sine">
	| EnumItem<number, EasingStyle, "Back">
	| EnumItem<number, EasingStyle, "Quad">
	| EnumItem<number, EasingStyle, "Quart">
	| EnumItem<number, EasingStyle, "Quint">
	| EnumItem<number, EasingStyle, "Bounce">
	| EnumItem<number, EasingStyle, "Elastic">
	| EnumItem<number, EasingStyle, "Exponential">
	| EnumItem<number, EasingStyle, "Circular">
	| EnumItem<number, EasingStyle, "Cubic">
export type EasingStyleRoot = EnumObject<{
	Linear: EnumItem<number, EasingStyle, "Linear">,
	Sine: EnumItem<number, EasingStyle, "Sine">,
	Back: EnumItem<number, EasingStyle, "Back">,
	Quad: EnumItem<number, EasingStyle, "Quad">,
	Quart: EnumItem<number, EasingStyle, "Quart">,
	Quint: EnumItem<number, EasingStyle, "Quint">,
	Bounce: EnumItem<number, EasingStyle, "Bounce">,
	Elastic: EnumItem<number, EasingStyle, "Elastic">,
	Exponential: EnumItem<number, EasingStyle, "Exponential">,
	Circular: EnumItem<number, EasingStyle, "Circular">,
	Cubic: EnumItem<number, EasingStyle, "Cubic">,
}, EasingStyle>
Enum.EasingStyle =
	{"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"}

export type EditableStatus =
	| EnumItem<number, EditableStatus, "Unknown">
	| EnumItem<number, EditableStatus, "Allowed">
	| EnumItem<number, EditableStatus, "Disallowed">
export type EditableStatusRoot = EnumObject<{
	Unknown: EnumItem<number, EditableStatus, "Unknown">,
	Allowed: EnumItem<number, EditableStatus, "Allowed">,
	Disallowed: EnumItem<number, EditableStatus, "Disallowed">,
}, EditableStatus>
Enum.EditableStatus = {"Unknown", "Allowed", "Disallowed"}

export type ElasticBehavior =
	| EnumItem<number, ElasticBehavior, "WhenScrollable">
	| EnumItem<number, ElasticBehavior, "Always">
	| EnumItem<number, ElasticBehavior, "Never">
export type ElasticBehaviorRoot = EnumObject<{
	WhenScrollable: EnumItem<number, ElasticBehavior, "WhenScrollable">,
	Always: EnumItem<number, ElasticBehavior, "Always">,
	Never: EnumItem<number, ElasticBehavior, "Never">,
}, ElasticBehavior>
Enum.ElasticBehavior = {"WhenScrollable", "Always", "Never"}

export type EnviromentalPhysicsThrottle =
	| EnumItem<number, EnviromentalPhysicsThrottle, "DefaultAuto">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Disabled">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Always">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Skip2">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Skip4">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Skip8">
	| EnumItem<number, EnviromentalPhysicsThrottle, "Skip16">
export type EnviromentalPhysicsThrottleRoot = EnumObject<{
	DefaultAuto: EnumItem<number, EnviromentalPhysicsThrottle, "DefaultAuto">,
	Disabled: EnumItem<number, EnviromentalPhysicsThrottle, "Disabled">,
	Always: EnumItem<number, EnviromentalPhysicsThrottle, "Always">,
	Skip2: EnumItem<number, EnviromentalPhysicsThrottle, "Skip2">,
	Skip4: EnumItem<number, EnviromentalPhysicsThrottle, "Skip4">,
	Skip8: EnumItem<number, EnviromentalPhysicsThrottle, "Skip8">,
	Skip16: EnumItem<number, EnviromentalPhysicsThrottle, "Skip16">,
}, EnviromentalPhysicsThrottle>
Enum.EnviromentalPhysicsThrottle = {"DefaultAuto", "Disabled", "Always", "Skip2", "Skip4", "Skip8", "Skip16"}

export type ExperienceAuthScope =
	| EnumItem<number, ExperienceAuthScope, "DefaultScope">
	| EnumItem<number, ExperienceAuthScope, "CreatorAssetsCreate">
export type ExperienceAuthScopeRoot = EnumObject<{
	DefaultScope: EnumItem<number, ExperienceAuthScope, "DefaultScope">,
	CreatorAssetsCreate: EnumItem<number, ExperienceAuthScope, "CreatorAssetsCreate">,
}, ExperienceAuthScope>
Enum.ExperienceAuthScope = {"DefaultScope", "CreatorAssetsCreate"}

export type ExplosionType = | EnumItem<number, ExplosionType, "NoCraters"> | EnumItem<number, ExplosionType, "Craters">
export type ExplosionTypeRoot = EnumObject<{
	NoCraters: EnumItem<number, ExplosionType, "NoCraters">,
	Craters: EnumItem<number, ExplosionType, "Craters">,
}, ExplosionType>
Enum.ExplosionType = {"NoCraters", "Craters"}

export type FACSDataLod =
	| EnumItem<number, FACSDataLod, "LOD0">
	| EnumItem<number, FACSDataLod, "LOD1">
	| EnumItem<number, FACSDataLod, "LODCount">
export type FACSDataLodRoot = EnumObject<{
	LOD0: EnumItem<number, FACSDataLod, "LOD0">,
	LOD1: EnumItem<number, FACSDataLod, "LOD1">,
	LODCount: EnumItem<number, FACSDataLod, "LODCount">,
}, FACSDataLod>
Enum.FACSDataLod = {"LOD0", "LOD1", "LODCount"}

export type FacialAgeEstimationResultType =
	| EnumItem<number, FacialAgeEstimationResultType, "Complete">
	| EnumItem<number, FacialAgeEstimationResultType, "Cancel">
	| EnumItem<number, FacialAgeEstimationResultType, "Error">
export type FacialAgeEstimationResultTypeRoot = EnumObject<{
	Complete: EnumItem<number, FacialAgeEstimationResultType, "Complete">,
	Cancel: EnumItem<number, FacialAgeEstimationResultType, "Cancel">,
	Error: EnumItem<number, FacialAgeEstimationResultType, "Error">,
}, FacialAgeEstimationResultType>
Enum.FacialAgeEstimationResultType = {"Complete", "Cancel", "Error"}

export type FacialAnimationStreamingState =
	| EnumItem<number, FacialAnimationStreamingState, "None">
	| EnumItem<number, FacialAnimationStreamingState, "Audio">
	| EnumItem<number, FacialAnimationStreamingState, "Video">
	| EnumItem<number, FacialAnimationStreamingState, "Place">
	| EnumItem<number, FacialAnimationStreamingState, "Server">
export type FacialAnimationStreamingStateRoot = EnumObject<{
	None: EnumItem<number, FacialAnimationStreamingState, "None">,
	Audio: EnumItem<number, FacialAnimationStreamingState, "Audio">,
	Video: EnumItem<number, FacialAnimationStreamingState, "Video">,
	Place: EnumItem<number, FacialAnimationStreamingState, "Place">,
	Server: EnumItem<number, FacialAnimationStreamingState, "Server">,
}, FacialAnimationStreamingState>
Enum.FacialAnimationStreamingState = {
	None = 0;
	Audio = 1;
	Video = 2;
	Place = 4;
	Server = 8;
}

export type FacsActionUnit =
	| EnumItem<number, FacsActionUnit, "ChinRaiserUpperLip">
	| EnumItem<number, FacsActionUnit, "ChinRaiser">
	| EnumItem<number, FacsActionUnit, "FlatPucker">
	| EnumItem<number, FacsActionUnit, "Funneler">
	| EnumItem<number, FacsActionUnit, "LowerLipSuck">
	| EnumItem<number, FacsActionUnit, "LipPresser">
	| EnumItem<number, FacsActionUnit, "LipsTogether">
	| EnumItem<number, FacsActionUnit, "MouthLeft">
	| EnumItem<number, FacsActionUnit, "MouthRight">
	| EnumItem<number, FacsActionUnit, "Pucker">
	| EnumItem<number, FacsActionUnit, "UpperLipSuck">
	| EnumItem<number, FacsActionUnit, "LeftCheekPuff">
	| EnumItem<number, FacsActionUnit, "LeftDimpler">
	| EnumItem<number, FacsActionUnit, "LeftLipCornerDown">
	| EnumItem<number, FacsActionUnit, "LeftLowerLipDepressor">
	| EnumItem<number, FacsActionUnit, "LeftLipCornerPuller">
	| EnumItem<number, FacsActionUnit, "LeftLipStretcher">
	| EnumItem<number, FacsActionUnit, "LeftUpperLipRaiser">
	| EnumItem<number, FacsActionUnit, "RightCheekPuff">
	| EnumItem<number, FacsActionUnit, "RightDimpler">
	| EnumItem<number, FacsActionUnit, "RightLipCornerDown">
	| EnumItem<number, FacsActionUnit, "RightLowerLipDepressor">
	| EnumItem<number, FacsActionUnit, "RightLipCornerPuller">
	| EnumItem<number, FacsActionUnit, "RightLipStretcher">
	| EnumItem<number, FacsActionUnit, "RightUpperLipRaiser">
	| EnumItem<number, FacsActionUnit, "JawDrop">
	| EnumItem<number, FacsActionUnit, "JawLeft">
	| EnumItem<number, FacsActionUnit, "JawRight">
	| EnumItem<number, FacsActionUnit, "Corrugator">
	| EnumItem<number, FacsActionUnit, "LeftBrowLowerer">
	| EnumItem<number, FacsActionUnit, "LeftOuterBrowRaiser">
	| EnumItem<number, FacsActionUnit, "LeftNoseWrinkler">
	| EnumItem<number, FacsActionUnit, "LeftInnerBrowRaiser">
	| EnumItem<number, FacsActionUnit, "RightBrowLowerer">
	| EnumItem<number, FacsActionUnit, "RightOuterBrowRaiser">
	| EnumItem<number, FacsActionUnit, "RightInnerBrowRaiser">
	| EnumItem<number, FacsActionUnit, "RightNoseWrinkler">
	| EnumItem<number, FacsActionUnit, "EyesLookDown">
	| EnumItem<number, FacsActionUnit, "EyesLookLeft">
	| EnumItem<number, FacsActionUnit, "EyesLookUp">
	| EnumItem<number, FacsActionUnit, "EyesLookRight">
	| EnumItem<number, FacsActionUnit, "LeftCheekRaiser">
	| EnumItem<number, FacsActionUnit, "LeftEyeUpperLidRaiser">
	| EnumItem<number, FacsActionUnit, "LeftEyeClosed">
	| EnumItem<number, FacsActionUnit, "RightCheekRaiser">
	| EnumItem<number, FacsActionUnit, "RightEyeUpperLidRaiser">
	| EnumItem<number, FacsActionUnit, "RightEyeClosed">
	| EnumItem<number, FacsActionUnit, "TongueDown">
	| EnumItem<number, FacsActionUnit, "TongueOut">
	| EnumItem<number, FacsActionUnit, "TongueUp">
export type FacsActionUnitRoot = EnumObject<{
	ChinRaiserUpperLip: EnumItem<number, FacsActionUnit, "ChinRaiserUpperLip">,
	ChinRaiser: EnumItem<number, FacsActionUnit, "ChinRaiser">,
	FlatPucker: EnumItem<number, FacsActionUnit, "FlatPucker">,
	Funneler: EnumItem<number, FacsActionUnit, "Funneler">,
	LowerLipSuck: EnumItem<number, FacsActionUnit, "LowerLipSuck">,
	LipPresser: EnumItem<number, FacsActionUnit, "LipPresser">,
	LipsTogether: EnumItem<number, FacsActionUnit, "LipsTogether">,
	MouthLeft: EnumItem<number, FacsActionUnit, "MouthLeft">,
	MouthRight: EnumItem<number, FacsActionUnit, "MouthRight">,
	Pucker: EnumItem<number, FacsActionUnit, "Pucker">,
	UpperLipSuck: EnumItem<number, FacsActionUnit, "UpperLipSuck">,
	LeftCheekPuff: EnumItem<number, FacsActionUnit, "LeftCheekPuff">,
	LeftDimpler: EnumItem<number, FacsActionUnit, "LeftDimpler">,
	LeftLipCornerDown: EnumItem<number, FacsActionUnit, "LeftLipCornerDown">,
	LeftLowerLipDepressor: EnumItem<number, FacsActionUnit, "LeftLowerLipDepressor">,
	LeftLipCornerPuller: EnumItem<number, FacsActionUnit, "LeftLipCornerPuller">,
	LeftLipStretcher: EnumItem<number, FacsActionUnit, "LeftLipStretcher">,
	LeftUpperLipRaiser: EnumItem<number, FacsActionUnit, "LeftUpperLipRaiser">,
	RightCheekPuff: EnumItem<number, FacsActionUnit, "RightCheekPuff">,
	RightDimpler: EnumItem<number, FacsActionUnit, "RightDimpler">,
	RightLipCornerDown: EnumItem<number, FacsActionUnit, "RightLipCornerDown">,
	RightLowerLipDepressor: EnumItem<number, FacsActionUnit, "RightLowerLipDepressor">,
	RightLipCornerPuller: EnumItem<number, FacsActionUnit, "RightLipCornerPuller">,
	RightLipStretcher: EnumItem<number, FacsActionUnit, "RightLipStretcher">,
	RightUpperLipRaiser: EnumItem<number, FacsActionUnit, "RightUpperLipRaiser">,
	JawDrop: EnumItem<number, FacsActionUnit, "JawDrop">,
	JawLeft: EnumItem<number, FacsActionUnit, "JawLeft">,
	JawRight: EnumItem<number, FacsActionUnit, "JawRight">,
	Corrugator: EnumItem<number, FacsActionUnit, "Corrugator">,
	LeftBrowLowerer: EnumItem<number, FacsActionUnit, "LeftBrowLowerer">,
	LeftOuterBrowRaiser: EnumItem<number, FacsActionUnit, "LeftOuterBrowRaiser">,
	LeftNoseWrinkler: EnumItem<number, FacsActionUnit, "LeftNoseWrinkler">,
	LeftInnerBrowRaiser: EnumItem<number, FacsActionUnit, "LeftInnerBrowRaiser">,
	RightBrowLowerer: EnumItem<number, FacsActionUnit, "RightBrowLowerer">,
	RightOuterBrowRaiser: EnumItem<number, FacsActionUnit, "RightOuterBrowRaiser">,
	RightInnerBrowRaiser: EnumItem<number, FacsActionUnit, "RightInnerBrowRaiser">,
	RightNoseWrinkler: EnumItem<number, FacsActionUnit, "RightNoseWrinkler">,
	EyesLookDown: EnumItem<number, FacsActionUnit, "EyesLookDown">,
	EyesLookLeft: EnumItem<number, FacsActionUnit, "EyesLookLeft">,
	EyesLookUp: EnumItem<number, FacsActionUnit, "EyesLookUp">,
	EyesLookRight: EnumItem<number, FacsActionUnit, "EyesLookRight">,
	LeftCheekRaiser: EnumItem<number, FacsActionUnit, "LeftCheekRaiser">,
	LeftEyeUpperLidRaiser: EnumItem<number, FacsActionUnit, "LeftEyeUpperLidRaiser">,
	LeftEyeClosed: EnumItem<number, FacsActionUnit, "LeftEyeClosed">,
	RightCheekRaiser: EnumItem<number, FacsActionUnit, "RightCheekRaiser">,
	RightEyeUpperLidRaiser: EnumItem<number, FacsActionUnit, "RightEyeUpperLidRaiser">,
	RightEyeClosed: EnumItem<number, FacsActionUnit, "RightEyeClosed">,
	TongueDown: EnumItem<number, FacsActionUnit, "TongueDown">,
	TongueOut: EnumItem<number, FacsActionUnit, "TongueOut">,
	TongueUp: EnumItem<number, FacsActionUnit, "TongueUp">,
}, FacsActionUnit>
Enum.FacsActionUnit = {
	"ChinRaiserUpperLip";
	"ChinRaiser";
	"FlatPucker";
	"Funneler";
	"LowerLipSuck";
	"LipPresser";
	"LipsTogether";
	"MouthLeft";
	"MouthRight";
	"Pucker";
	"UpperLipSuck";
	"LeftCheekPuff";
	"LeftDimpler";
	"LeftLipCornerDown";
	"LeftLowerLipDepressor";
	"LeftLipCornerPuller";
	"LeftLipStretcher";
	"LeftUpperLipRaiser";
	"RightCheekPuff";
	"RightDimpler";
	"RightLipCornerDown";
	"RightLowerLipDepressor";
	"RightLipCornerPuller";
	"RightLipStretcher";
	"RightUpperLipRaiser";
	"JawDrop";
	"JawLeft";
	"JawRight";
	"Corrugator";
	"LeftBrowLowerer";
	"LeftOuterBrowRaiser";
	"LeftNoseWrinkler";
	"LeftInnerBrowRaiser";
	"RightBrowLowerer";
	"RightOuterBrowRaiser";
	"RightInnerBrowRaiser";
	"RightNoseWrinkler";
	"EyesLookDown";
	"EyesLookLeft";
	"EyesLookUp";
	"EyesLookRight";
	"LeftCheekRaiser";
	"LeftEyeUpperLidRaiser";
	"LeftEyeClosed";
	"RightCheekRaiser";
	"RightEyeUpperLidRaiser";
	"RightEyeClosed";
	"TongueDown";
	"TongueOut";
	"TongueUp";
}

export type FeedRankingScoreType =
	| EnumItem<number, FeedRankingScoreType, "Content">
	| EnumItem<number, FeedRankingScoreType, "Final">
	| EnumItem<number, FeedRankingScoreType, "GameJoin">
	| EnumItem<number, FeedRankingScoreType, "Interaction">
	| EnumItem<number, FeedRankingScoreType, "Sharing">
export type FeedRankingScoreTypeRoot = EnumObject<{
	Content: EnumItem<number, FeedRankingScoreType, "Content">,
	Final: EnumItem<number, FeedRankingScoreType, "Final">,
	GameJoin: EnumItem<number, FeedRankingScoreType, "GameJoin">,
	Interaction: EnumItem<number, FeedRankingScoreType, "Interaction">,
	Sharing: EnumItem<number, FeedRankingScoreType, "Sharing">,
}, FeedRankingScoreType>
Enum.FeedRankingScoreType = {"Content", "Final", "GameJoin", "Interaction", "Sharing"}

export type FieldOfViewMode =
	| EnumItem<number, FieldOfViewMode, "Vertical">
	| EnumItem<number, FieldOfViewMode, "Diagonal">
	| EnumItem<number, FieldOfViewMode, "MaxAxis">
export type FieldOfViewModeRoot = EnumObject<{
	Vertical: EnumItem<number, FieldOfViewMode, "Vertical">,
	Diagonal: EnumItem<number, FieldOfViewMode, "Diagonal">,
	MaxAxis: EnumItem<number, FieldOfViewMode, "MaxAxis">,
}, FieldOfViewMode>
Enum.FieldOfViewMode = {"Vertical", "Diagonal", "MaxAxis"}

export type FillDirection = | EnumItem<number, FillDirection, "Horizontal"> | EnumItem<number, FillDirection, "Vertical">
export type FillDirectionRoot = EnumObject<{
	Horizontal: EnumItem<number, FillDirection, "Horizontal">,
	Vertical: EnumItem<number, FillDirection, "Vertical">,
}, FillDirection>
Enum.FillDirection = {"Horizontal", "Vertical"}

export type FilterErrorType =
	| EnumItem<number, FilterErrorType, "BackslashNotEscapingAnything">
	| EnumItem<number, FilterErrorType, "BadBespokeFilter">
	| EnumItem<number, FilterErrorType, "BadName">
	| EnumItem<number, FilterErrorType, "IncompleteOr">
	| EnumItem<number, FilterErrorType, "IncompleteParenthesis">
	| EnumItem<number, FilterErrorType, "InvalidDoubleStar">
	| EnumItem<number, FilterErrorType, "InvalidTilde">
	| EnumItem<number, FilterErrorType, "PropertyBadOperator">
	| EnumItem<number, FilterErrorType, "PropertyDoesNotExist">
	| EnumItem<number, FilterErrorType, "PropertyInvalidField">
	| EnumItem<number, FilterErrorType, "PropertyInvalidValue">
	| EnumItem<number, FilterErrorType, "PropertyUnsupportedFields">
	| EnumItem<number, FilterErrorType, "PropertyUnsupportedProperty">
	| EnumItem<number, FilterErrorType, "UnexpectedNameIndex">
	| EnumItem<number, FilterErrorType, "UnexpectedToken">
	| EnumItem<number, FilterErrorType, "UnfinishedBinaryOperator">
	| EnumItem<number, FilterErrorType, "UnfinishedQuote">
	| EnumItem<number, FilterErrorType, "UnknownBespokeFilter">
	| EnumItem<number, FilterErrorType, "WildcardInProperty">
export type FilterErrorTypeRoot = EnumObject<{
	BackslashNotEscapingAnything: EnumItem<number, FilterErrorType, "BackslashNotEscapingAnything">,
	BadBespokeFilter: EnumItem<number, FilterErrorType, "BadBespokeFilter">,
	BadName: EnumItem<number, FilterErrorType, "BadName">,
	IncompleteOr: EnumItem<number, FilterErrorType, "IncompleteOr">,
	IncompleteParenthesis: EnumItem<number, FilterErrorType, "IncompleteParenthesis">,
	InvalidDoubleStar: EnumItem<number, FilterErrorType, "InvalidDoubleStar">,
	InvalidTilde: EnumItem<number, FilterErrorType, "InvalidTilde">,
	PropertyBadOperator: EnumItem<number, FilterErrorType, "PropertyBadOperator">,
	PropertyDoesNotExist: EnumItem<number, FilterErrorType, "PropertyDoesNotExist">,
	PropertyInvalidField: EnumItem<number, FilterErrorType, "PropertyInvalidField">,
	PropertyInvalidValue: EnumItem<number, FilterErrorType, "PropertyInvalidValue">,
	PropertyUnsupportedFields: EnumItem<number, FilterErrorType, "PropertyUnsupportedFields">,
	PropertyUnsupportedProperty: EnumItem<number, FilterErrorType, "PropertyUnsupportedProperty">,
	UnexpectedNameIndex: EnumItem<number, FilterErrorType, "UnexpectedNameIndex">,
	UnexpectedToken: EnumItem<number, FilterErrorType, "UnexpectedToken">,
	UnfinishedBinaryOperator: EnumItem<number, FilterErrorType, "UnfinishedBinaryOperator">,
	UnfinishedQuote: EnumItem<number, FilterErrorType, "UnfinishedQuote">,
	UnknownBespokeFilter: EnumItem<number, FilterErrorType, "UnknownBespokeFilter">,
	WildcardInProperty: EnumItem<number, FilterErrorType, "WildcardInProperty">,
}, FilterErrorType>
Enum.FilterErrorType = {
	"BackslashNotEscapingAnything";
	"BadBespokeFilter";
	"BadName";
	"IncompleteOr";
	"IncompleteParenthesis";
	"InvalidDoubleStar";
	"InvalidTilde";
	"PropertyBadOperator";
	"PropertyDoesNotExist";
	"PropertyInvalidField";
	"PropertyInvalidValue";
	"PropertyUnsupportedFields";
	"PropertyUnsupportedProperty";
	"UnexpectedNameIndex";
	"UnexpectedToken";
	"UnfinishedBinaryOperator";
	"UnfinishedQuote";
	"UnknownBespokeFilter";
	"WildcardInProperty";
}

export type FilterResult = | EnumItem<number, FilterResult, "Accepted"> | EnumItem<number, FilterResult, "Rejected">
export type FilterResultRoot = EnumObject<{
	Accepted: EnumItem<number, FilterResult, "Accepted">,
	Rejected: EnumItem<number, FilterResult, "Rejected">,
}, FilterResult>
Enum.FilterResult = {"Accepted", "Rejected"}

export type FinishRecordingOperation =
	| EnumItem<number, FinishRecordingOperation, "Cancel">
	| EnumItem<number, FinishRecordingOperation, "Commit">
	| EnumItem<number, FinishRecordingOperation, "Append">
export type FinishRecordingOperationRoot = EnumObject<{
	Cancel: EnumItem<number, FinishRecordingOperation, "Cancel">,
	Commit: EnumItem<number, FinishRecordingOperation, "Commit">,
	Append: EnumItem<number, FinishRecordingOperation, "Append">,
}, FinishRecordingOperation>
Enum.FinishRecordingOperation = {"Cancel", "Commit", "Append"}

export type FluidFidelity =
	| EnumItem<number, FluidFidelity, "Automatic">
	| EnumItem<number, FluidFidelity, "UseCollisionGeometry">
	| EnumItem<number, FluidFidelity, "UsePreciseGeometry">
export type FluidFidelityRoot = EnumObject<{
	Automatic: EnumItem<number, FluidFidelity, "Automatic">,
	UseCollisionGeometry: EnumItem<number, FluidFidelity, "UseCollisionGeometry">,
	UsePreciseGeometry: EnumItem<number, FluidFidelity, "UsePreciseGeometry">,
}, FluidFidelity>
Enum.FluidFidelity = {"Automatic", "UseCollisionGeometry", "UsePreciseGeometry"}

export type FluidForces = | EnumItem<number, FluidForces, "Default"> | EnumItem<number, FluidForces, "Experimental">
export type FluidForcesRoot = EnumObject<{
	Default: EnumItem<number, FluidForces, "Default">,
	Experimental: EnumItem<number, FluidForces, "Experimental">,
}, FluidForces>
Enum.FluidForces = {"Default", "Experimental"}

export type Font =
	| EnumItem<number, Font, "Legacy">
	| EnumItem<number, Font, "Arial">
	| EnumItem<number, Font, "ArialBold">
	| EnumItem<number, Font, "SourceSans">
	| EnumItem<number, Font, "SourceSansBold">
	| EnumItem<number, Font, "SourceSansLight">
	| EnumItem<number, Font, "SourceSansItalic">
	| EnumItem<number, Font, "Bodoni">
	| EnumItem<number, Font, "Garamond">
	| EnumItem<number, Font, "Cartoon">
	| EnumItem<number, Font, "Code">
	| EnumItem<number, Font, "Highway">
	| EnumItem<number, Font, "SciFi">
	| EnumItem<number, Font, "Arcade">
	| EnumItem<number, Font, "Fantasy">
	| EnumItem<number, Font, "Antique">
	| EnumItem<number, Font, "SourceSansSemibold">
	| EnumItem<number, Font, "Gotham">
	| EnumItem<number, Font, "GothamMedium">
	| EnumItem<number, Font, "GothamBold">
	| EnumItem<number, Font, "GothamBlack">
	| EnumItem<number, Font, "AmaticSC">
	| EnumItem<number, Font, "Bangers">
	| EnumItem<number, Font, "Creepster">
	| EnumItem<number, Font, "DenkOne">
	| EnumItem<number, Font, "Fondamento">
	| EnumItem<number, Font, "FredokaOne">
	| EnumItem<number, Font, "GrenzeGotisch">
	| EnumItem<number, Font, "IndieFlower">
	| EnumItem<number, Font, "JosefinSans">
	| EnumItem<number, Font, "Jura">
	| EnumItem<number, Font, "Kalam">
	| EnumItem<number, Font, "LuckiestGuy">
	| EnumItem<number, Font, "Merriweather">
	| EnumItem<number, Font, "Michroma">
	| EnumItem<number, Font, "Nunito">
	| EnumItem<number, Font, "Oswald">
	| EnumItem<number, Font, "PatrickHand">
	| EnumItem<number, Font, "PermanentMarker">
	| EnumItem<number, Font, "Roboto">
	| EnumItem<number, Font, "RobotoCondensed">
	| EnumItem<number, Font, "RobotoMono">
	| EnumItem<number, Font, "Sarpanch">
	| EnumItem<number, Font, "SpecialElite">
	| EnumItem<number, Font, "TitilliumWeb">
	| EnumItem<number, Font, "Ubuntu">
	| EnumItem<number, Font, "BuilderSans">
	| EnumItem<number, Font, "BuilderSansMedium">
	| EnumItem<number, Font, "BuilderSansBold">
	| EnumItem<number, Font, "BuilderSansExtraBold">
	| EnumItem<number, Font, "Arimo">
	| EnumItem<number, Font, "ArimoBold">
	| EnumItem<number, Font, "Unknown">
export type FontRoot = EnumObject<{
	Legacy: EnumItem<number, Font, "Legacy">,
	Arial: EnumItem<number, Font, "Arial">,
	ArialBold: EnumItem<number, Font, "ArialBold">,
	SourceSans: EnumItem<number, Font, "SourceSans">,
	SourceSansBold: EnumItem<number, Font, "SourceSansBold">,
	SourceSansLight: EnumItem<number, Font, "SourceSansLight">,
	SourceSansItalic: EnumItem<number, Font, "SourceSansItalic">,
	Bodoni: EnumItem<number, Font, "Bodoni">,
	Garamond: EnumItem<number, Font, "Garamond">,
	Cartoon: EnumItem<number, Font, "Cartoon">,
	Code: EnumItem<number, Font, "Code">,
	Highway: EnumItem<number, Font, "Highway">,
	SciFi: EnumItem<number, Font, "SciFi">,
	Arcade: EnumItem<number, Font, "Arcade">,
	Fantasy: EnumItem<number, Font, "Fantasy">,
	Antique: EnumItem<number, Font, "Antique">,
	SourceSansSemibold: EnumItem<number, Font, "SourceSansSemibold">,
	Gotham: EnumItem<number, Font, "Gotham">,
	GothamMedium: EnumItem<number, Font, "GothamMedium">,
	GothamBold: EnumItem<number, Font, "GothamBold">,
	GothamBlack: EnumItem<number, Font, "GothamBlack">,
	AmaticSC: EnumItem<number, Font, "AmaticSC">,
	Bangers: EnumItem<number, Font, "Bangers">,
	Creepster: EnumItem<number, Font, "Creepster">,
	DenkOne: EnumItem<number, Font, "DenkOne">,
	Fondamento: EnumItem<number, Font, "Fondamento">,
	FredokaOne: EnumItem<number, Font, "FredokaOne">,
	GrenzeGotisch: EnumItem<number, Font, "GrenzeGotisch">,
	IndieFlower: EnumItem<number, Font, "IndieFlower">,
	JosefinSans: EnumItem<number, Font, "JosefinSans">,
	Jura: EnumItem<number, Font, "Jura">,
	Kalam: EnumItem<number, Font, "Kalam">,
	LuckiestGuy: EnumItem<number, Font, "LuckiestGuy">,
	Merriweather: EnumItem<number, Font, "Merriweather">,
	Michroma: EnumItem<number, Font, "Michroma">,
	Nunito: EnumItem<number, Font, "Nunito">,
	Oswald: EnumItem<number, Font, "Oswald">,
	PatrickHand: EnumItem<number, Font, "PatrickHand">,
	PermanentMarker: EnumItem<number, Font, "PermanentMarker">,
	Roboto: EnumItem<number, Font, "Roboto">,
	RobotoCondensed: EnumItem<number, Font, "RobotoCondensed">,
	RobotoMono: EnumItem<number, Font, "RobotoMono">,
	Sarpanch: EnumItem<number, Font, "Sarpanch">,
	SpecialElite: EnumItem<number, Font, "SpecialElite">,
	TitilliumWeb: EnumItem<number, Font, "TitilliumWeb">,
	Ubuntu: EnumItem<number, Font, "Ubuntu">,
	BuilderSans: EnumItem<number, Font, "BuilderSans">,
	BuilderSansMedium: EnumItem<number, Font, "BuilderSansMedium">,
	BuilderSansBold: EnumItem<number, Font, "BuilderSansBold">,
	BuilderSansExtraBold: EnumItem<number, Font, "BuilderSansExtraBold">,
	Arimo: EnumItem<number, Font, "Arimo">,
	ArimoBold: EnumItem<number, Font, "ArimoBold">,
	Unknown: EnumItem<number, Font, "Unknown">,
}, Font>
Enum.Font = {
	Legacy = 0;
	Arial = 1;
	ArialBold = 2;
	SourceSans = 3;
	SourceSansBold = 4;
	SourceSansLight = 5;
	SourceSansItalic = 6;
	Bodoni = 7;
	Garamond = 8;
	Cartoon = 9;
	Code = 10;
	Highway = 11;
	SciFi = 12;
	Arcade = 13;
	Fantasy = 14;
	Antique = 15;
	SourceSansSemibold = 16;
	Gotham = 17;
	GothamMedium = 18;
	GothamBold = 19;
	GothamBlack = 20;
	AmaticSC = 21;
	Bangers = 22;
	Creepster = 23;
	DenkOne = 24;
	Fondamento = 25;
	FredokaOne = 26;
	GrenzeGotisch = 27;
	IndieFlower = 28;
	JosefinSans = 29;
	Jura = 30;
	Kalam = 31;
	LuckiestGuy = 32;
	Merriweather = 33;
	Michroma = 34;
	Nunito = 35;
	Oswald = 36;
	PatrickHand = 37;
	PermanentMarker = 38;
	Roboto = 39;
	RobotoCondensed = 40;
	RobotoMono = 41;
	Sarpanch = 42;
	SpecialElite = 43;
	TitilliumWeb = 44;
	Ubuntu = 45;
	BuilderSans = 46;
	BuilderSansMedium = 47;
	BuilderSansBold = 48;
	BuilderSansExtraBold = 49;
	Arimo = 50;
	ArimoBold = 51;
	Unknown = 100;
}

export type FontSize =
	| EnumItem<number, FontSize, "Size8">
	| EnumItem<number, FontSize, "Size9">
	| EnumItem<number, FontSize, "Size10">
	| EnumItem<number, FontSize, "Size11">
	| EnumItem<number, FontSize, "Size12">
	| EnumItem<number, FontSize, "Size14">
	| EnumItem<number, FontSize, "Size18">
	| EnumItem<number, FontSize, "Size24">
	| EnumItem<number, FontSize, "Size36">
	| EnumItem<number, FontSize, "Size48">
	| EnumItem<number, FontSize, "Size28">
	| EnumItem<number, FontSize, "Size32">
	| EnumItem<number, FontSize, "Size42">
	| EnumItem<number, FontSize, "Size60">
	| EnumItem<number, FontSize, "Size96">
export type FontSizeRoot = EnumObject<{
	Size8: EnumItem<number, FontSize, "Size8">,
	Size9: EnumItem<number, FontSize, "Size9">,
	Size10: EnumItem<number, FontSize, "Size10">,
	Size11: EnumItem<number, FontSize, "Size11">,
	Size12: EnumItem<number, FontSize, "Size12">,
	Size14: EnumItem<number, FontSize, "Size14">,
	Size18: EnumItem<number, FontSize, "Size18">,
	Size24: EnumItem<number, FontSize, "Size24">,
	Size36: EnumItem<number, FontSize, "Size36">,
	Size48: EnumItem<number, FontSize, "Size48">,
	Size28: EnumItem<number, FontSize, "Size28">,
	Size32: EnumItem<number, FontSize, "Size32">,
	Size42: EnumItem<number, FontSize, "Size42">,
	Size60: EnumItem<number, FontSize, "Size60">,
	Size96: EnumItem<number, FontSize, "Size96">,
}, FontSize>
Enum.FontSize = {
	"Size8";
	"Size9";
	"Size10";
	"Size11";
	"Size12";
	"Size14";
	"Size18";
	"Size24";
	"Size36";
	"Size48";
	"Size28";
	"Size32";
	"Size42";
	"Size60";
	"Size96";
}

export type FontStyle = | EnumItem<number, FontStyle, "Normal"> | EnumItem<number, FontStyle, "Italic">
export type FontStyleRoot = EnumObject<{
	Normal: EnumItem<number, FontStyle, "Normal">,
	Italic: EnumItem<number, FontStyle, "Italic">,
}, FontStyle>
Enum.FontStyle = {"Normal", "Italic"}

export type FontWeight =
	| EnumItem<number, FontWeight, "Thin">
	| EnumItem<number, FontWeight, "ExtraLight">
	| EnumItem<number, FontWeight, "Light">
	| EnumItem<number, FontWeight, "Regular">
	| EnumItem<number, FontWeight, "Medium">
	| EnumItem<number, FontWeight, "SemiBold">
	| EnumItem<number, FontWeight, "Bold">
	| EnumItem<number, FontWeight, "ExtraBold">
	| EnumItem<number, FontWeight, "Heavy">
export type FontWeightRoot = EnumObject<{
	Thin: EnumItem<number, FontWeight, "Thin">,
	ExtraLight: EnumItem<number, FontWeight, "ExtraLight">,
	Light: EnumItem<number, FontWeight, "Light">,
	Regular: EnumItem<number, FontWeight, "Regular">,
	Medium: EnumItem<number, FontWeight, "Medium">,
	SemiBold: EnumItem<number, FontWeight, "SemiBold">,
	Bold: EnumItem<number, FontWeight, "Bold">,
	ExtraBold: EnumItem<number, FontWeight, "ExtraBold">,
	Heavy: EnumItem<number, FontWeight, "Heavy">,
}, FontWeight>
Enum.FontWeight = {
	Thin = 100;
	ExtraLight = 200;
	Light = 300;
	Regular = 400;
	Medium = 500;
	SemiBold = 600;
	Bold = 700;
	ExtraBold = 800;
	Heavy = 900;
}

export type ForceLimitMode = | EnumItem<number, ForceLimitMode, "Magnitude"> | EnumItem<number, ForceLimitMode, "PerAxis">
export type ForceLimitModeRoot = EnumObject<{
	Magnitude: EnumItem<number, ForceLimitMode, "Magnitude">,
	PerAxis: EnumItem<number, ForceLimitMode, "PerAxis">,
}, ForceLimitMode>
Enum.ForceLimitMode = {"Magnitude", "PerAxis"}

export type FormFactor =
	| EnumItem<number, FormFactor, "Symmetric">
	| EnumItem<number, FormFactor, "Brick">
	| EnumItem<number, FormFactor, "Plate">
	| EnumItem<number, FormFactor, "Custom">
export type FormFactorRoot = EnumObject<{
	Symmetric: EnumItem<number, FormFactor, "Symmetric">,
	Brick: EnumItem<number, FormFactor, "Brick">,
	Plate: EnumItem<number, FormFactor, "Plate">,
	Custom: EnumItem<number, FormFactor, "Custom">,
}, FormFactor>
Enum.FormFactor = {"Symmetric", "Brick", "Plate", "Custom"}

export type FrameStyle =
	| EnumItem<number, FrameStyle, "Custom">
	| EnumItem<number, FrameStyle, "ChatBlue">
	| EnumItem<number, FrameStyle, "RobloxSquare">
	| EnumItem<number, FrameStyle, "RobloxRound">
	| EnumItem<number, FrameStyle, "ChatGreen">
	| EnumItem<number, FrameStyle, "ChatRed">
	| EnumItem<number, FrameStyle, "DropShadow">
export type FrameStyleRoot = EnumObject<{
	Custom: EnumItem<number, FrameStyle, "Custom">,
	ChatBlue: EnumItem<number, FrameStyle, "ChatBlue">,
	RobloxSquare: EnumItem<number, FrameStyle, "RobloxSquare">,
	RobloxRound: EnumItem<number, FrameStyle, "RobloxRound">,
	ChatGreen: EnumItem<number, FrameStyle, "ChatGreen">,
	ChatRed: EnumItem<number, FrameStyle, "ChatRed">,
	DropShadow: EnumItem<number, FrameStyle, "DropShadow">,
}, FrameStyle>
Enum.FrameStyle = {"Custom", "ChatBlue", "RobloxSquare", "RobloxRound", "ChatGreen", "ChatRed", "DropShadow"}

export type FramerateManagerMode =
	| EnumItem<number, FramerateManagerMode, "Automatic">
	| EnumItem<number, FramerateManagerMode, "On">
	| EnumItem<number, FramerateManagerMode, "Off">
export type FramerateManagerModeRoot = EnumObject<{
	Automatic: EnumItem<number, FramerateManagerMode, "Automatic">,
	On: EnumItem<number, FramerateManagerMode, "On">,
	Off: EnumItem<number, FramerateManagerMode, "Off">,
}, FramerateManagerMode>
Enum.FramerateManagerMode = {"Automatic", "On", "Off"}

export type FriendRequestEvent =
	| EnumItem<number, FriendRequestEvent, "Issue">
	| EnumItem<number, FriendRequestEvent, "Revoke">
	| EnumItem<number, FriendRequestEvent, "Accept">
	| EnumItem<number, FriendRequestEvent, "Deny">
export type FriendRequestEventRoot = EnumObject<{
	Issue: EnumItem<number, FriendRequestEvent, "Issue">,
	Revoke: EnumItem<number, FriendRequestEvent, "Revoke">,
	Accept: EnumItem<number, FriendRequestEvent, "Accept">,
	Deny: EnumItem<number, FriendRequestEvent, "Deny">,
}, FriendRequestEvent>
Enum.FriendRequestEvent = {"Issue", "Revoke", "Accept", "Deny"}

export type FriendStatus =
	| EnumItem<number, FriendStatus, "Unknown">
	| EnumItem<number, FriendStatus, "NotFriend">
	| EnumItem<number, FriendStatus, "Friend">
	| EnumItem<number, FriendStatus, "FriendRequestSent">
	| EnumItem<number, FriendStatus, "FriendRequestReceived">
export type FriendStatusRoot = EnumObject<{
	Unknown: EnumItem<number, FriendStatus, "Unknown">,
	NotFriend: EnumItem<number, FriendStatus, "NotFriend">,
	Friend: EnumItem<number, FriendStatus, "Friend">,
	FriendRequestSent: EnumItem<number, FriendStatus, "FriendRequestSent">,
	FriendRequestReceived: EnumItem<number, FriendStatus, "FriendRequestReceived">,
}, FriendStatus>
Enum.FriendStatus = {"Unknown", "NotFriend", "Friend", "FriendRequestSent", "FriendRequestReceived"}

export type FunctionalTestResult =
	| EnumItem<number, FunctionalTestResult, "Passed">
	| EnumItem<number, FunctionalTestResult, "Warning">
	| EnumItem<number, FunctionalTestResult, "Error">
export type FunctionalTestResultRoot = EnumObject<{
	Passed: EnumItem<number, FunctionalTestResult, "Passed">,
	Warning: EnumItem<number, FunctionalTestResult, "Warning">,
	Error: EnumItem<number, FunctionalTestResult, "Error">,
}, FunctionalTestResult>
Enum.FunctionalTestResult = {"Passed", "Warning", "Error"}

export type GameAvatarType =
	| EnumItem<number, GameAvatarType, "R6">
	| EnumItem<number, GameAvatarType, "R15">
	| EnumItem<number, GameAvatarType, "PlayerChoice">
export type GameAvatarTypeRoot = EnumObject<{
	R6: EnumItem<number, GameAvatarType, "R6">,
	R15: EnumItem<number, GameAvatarType, "R15">,
	PlayerChoice: EnumItem<number, GameAvatarType, "PlayerChoice">,
}, GameAvatarType>
Enum.GameAvatarType = {"R6", "R15", "PlayerChoice"}

export type GamepadType =
	| EnumItem<number, GamepadType, "Unknown">
	| EnumItem<number, GamepadType, "PS4">
	| EnumItem<number, GamepadType, "PS5">
	| EnumItem<number, GamepadType, "XboxOne">
export type GamepadTypeRoot = EnumObject<{
	Unknown: EnumItem<number, GamepadType, "Unknown">,
	PS4: EnumItem<number, GamepadType, "PS4">,
	PS5: EnumItem<number, GamepadType, "PS5">,
	XboxOne: EnumItem<number, GamepadType, "XboxOne">,
}, GamepadType>
Enum.GamepadType = {"Unknown", "PS4", "PS5", "XboxOne"}

export type GearGenreSetting =
	| EnumItem<number, GearGenreSetting, "AllGenres">
	| EnumItem<number, GearGenreSetting, "MatchingGenreOnly">
export type GearGenreSettingRoot = EnumObject<{
	AllGenres: EnumItem<number, GearGenreSetting, "AllGenres">,
	MatchingGenreOnly: EnumItem<number, GearGenreSetting, "MatchingGenreOnly">,
}, GearGenreSetting>
Enum.GearGenreSetting = {"AllGenres", "MatchingGenreOnly"}

export type GearType =
	| EnumItem<number, GearType, "MeleeWeapons">
	| EnumItem<number, GearType, "RangedWeapons">
	| EnumItem<number, GearType, "Explosives">
	| EnumItem<number, GearType, "PowerUps">
	| EnumItem<number, GearType, "NavigationEnhancers">
	| EnumItem<number, GearType, "MusicalInstruments">
	| EnumItem<number, GearType, "SocialItems">
	| EnumItem<number, GearType, "BuildingTools">
	| EnumItem<number, GearType, "Transport">
export type GearTypeRoot = EnumObject<{
	MeleeWeapons: EnumItem<number, GearType, "MeleeWeapons">,
	RangedWeapons: EnumItem<number, GearType, "RangedWeapons">,
	Explosives: EnumItem<number, GearType, "Explosives">,
	PowerUps: EnumItem<number, GearType, "PowerUps">,
	NavigationEnhancers: EnumItem<number, GearType, "NavigationEnhancers">,
	MusicalInstruments: EnumItem<number, GearType, "MusicalInstruments">,
	SocialItems: EnumItem<number, GearType, "SocialItems">,
	BuildingTools: EnumItem<number, GearType, "BuildingTools">,
	Transport: EnumItem<number, GearType, "Transport">,
}, GearType>
Enum.GearType = {
	"MeleeWeapons";
	"RangedWeapons";
	"Explosives";
	"PowerUps";
	"NavigationEnhancers";
	"MusicalInstruments";
	"SocialItems";
	"BuildingTools";
	"Transport";
}

export type Genre =
	| EnumItem<number, Genre, "All">
	| EnumItem<number, Genre, "TownAndCity">
	| EnumItem<number, Genre, "Fantasy">
	| EnumItem<number, Genre, "SciFi">
	| EnumItem<number, Genre, "Ninja">
	| EnumItem<number, Genre, "Scary">
	| EnumItem<number, Genre, "Pirate">
	| EnumItem<number, Genre, "Adventure">
	| EnumItem<number, Genre, "Sports">
	| EnumItem<number, Genre, "Funny">
	| EnumItem<number, Genre, "WildWest">
	| EnumItem<number, Genre, "War">
	| EnumItem<number, Genre, "SkatePark">
	| EnumItem<number, Genre, "Tutorial">
export type GenreRoot = EnumObject<{
	All: EnumItem<number, Genre, "All">,
	TownAndCity: EnumItem<number, Genre, "TownAndCity">,
	Fantasy: EnumItem<number, Genre, "Fantasy">,
	SciFi: EnumItem<number, Genre, "SciFi">,
	Ninja: EnumItem<number, Genre, "Ninja">,
	Scary: EnumItem<number, Genre, "Scary">,
	Pirate: EnumItem<number, Genre, "Pirate">,
	Adventure: EnumItem<number, Genre, "Adventure">,
	Sports: EnumItem<number, Genre, "Sports">,
	Funny: EnumItem<number, Genre, "Funny">,
	WildWest: EnumItem<number, Genre, "WildWest">,
	War: EnumItem<number, Genre, "War">,
	SkatePark: EnumItem<number, Genre, "SkatePark">,
	Tutorial: EnumItem<number, Genre, "Tutorial">,
}, Genre>
Enum.Genre = {
	"All";
	"TownAndCity";
	"Fantasy";
	"SciFi";
	"Ninja";
	"Scary";
	"Pirate";
	"Adventure";
	"Sports";
	"Funny";
	"WildWest";
	"War";
	"SkatePark";
	"Tutorial";
}

export type GraphicsMode =
	| EnumItem<number, GraphicsMode, "Automatic">
	| EnumItem<number, GraphicsMode, "Direct3D11">
	| EnumItem<number, GraphicsMode, "OpenGL">
	| EnumItem<number, GraphicsMode, "Metal">
	| EnumItem<number, GraphicsMode, "Vulkan">
	| EnumItem<number, GraphicsMode, "NoGraphics">
export type GraphicsModeRoot = EnumObject<{
	Automatic: EnumItem<number, GraphicsMode, "Automatic">,
	Direct3D11: EnumItem<number, GraphicsMode, "Direct3D11">,
	OpenGL: EnumItem<number, GraphicsMode, "OpenGL">,
	Metal: EnumItem<number, GraphicsMode, "Metal">,
	Vulkan: EnumItem<number, GraphicsMode, "Vulkan">,
	NoGraphics: EnumItem<number, GraphicsMode, "NoGraphics">,
}, GraphicsMode>
Enum.GraphicsMode = {
	Automatic = 1;
	Direct3D11 = 2;
	OpenGL = 4;
	Metal = 5;
	Vulkan = 6;
	NoGraphics = 9;
}

export type GraphicsOptimizationMode =
	| EnumItem<number, GraphicsOptimizationMode, "Performance">
	| EnumItem<number, GraphicsOptimizationMode, "Balanced">
	| EnumItem<number, GraphicsOptimizationMode, "Quality">
export type GraphicsOptimizationModeRoot = EnumObject<{
	Performance: EnumItem<number, GraphicsOptimizationMode, "Performance">,
	Balanced: EnumItem<number, GraphicsOptimizationMode, "Balanced">,
	Quality: EnumItem<number, GraphicsOptimizationMode, "Quality">,
}, GraphicsOptimizationMode>
Enum.GraphicsOptimizationMode = {"Performance", "Balanced", "Quality"}

export type GuiState =
	| EnumItem<number, GuiState, "Idle">
	| EnumItem<number, GuiState, "Hover">
	| EnumItem<number, GuiState, "Press">
	| EnumItem<number, GuiState, "NonInteractable">
export type GuiStateRoot = EnumObject<{
	Idle: EnumItem<number, GuiState, "Idle">,
	Hover: EnumItem<number, GuiState, "Hover">,
	Press: EnumItem<number, GuiState, "Press">,
	NonInteractable: EnumItem<number, GuiState, "NonInteractable">,
}, GuiState>
Enum.GuiState = {"Idle", "Hover", "Press", "NonInteractable"}

export type GuiType =
	| EnumItem<number, GuiType, "Core">
	| EnumItem<number, GuiType, "Custom">
	| EnumItem<number, GuiType, "PlayerNameplates">
	| EnumItem<number, GuiType, "CustomBillboards">
	| EnumItem<number, GuiType, "CoreBillboards">
export type GuiTypeRoot = EnumObject<{
	Core: EnumItem<number, GuiType, "Core">,
	Custom: EnumItem<number, GuiType, "Custom">,
	PlayerNameplates: EnumItem<number, GuiType, "PlayerNameplates">,
	CustomBillboards: EnumItem<number, GuiType, "CustomBillboards">,
	CoreBillboards: EnumItem<number, GuiType, "CoreBillboards">,
}, GuiType>
Enum.GuiType = {"Core", "Custom", "PlayerNameplates", "CustomBillboards", "CoreBillboards"}

export type HandlesStyle = | EnumItem<number, HandlesStyle, "Resize"> | EnumItem<number, HandlesStyle, "Movement">
export type HandlesStyleRoot = EnumObject<{
	Resize: EnumItem<number, HandlesStyle, "Resize">,
	Movement: EnumItem<number, HandlesStyle, "Movement">,
}, HandlesStyle>
Enum.HandlesStyle = {"Resize", "Movement"}

export type HapticEffectType =
	| EnumItem<number, HapticEffectType, "Custom">
	| EnumItem<number, HapticEffectType, "UIHover">
	| EnumItem<number, HapticEffectType, "UIClick">
	| EnumItem<number, HapticEffectType, "UINotification">
	| EnumItem<number, HapticEffectType, "GameplayExplosion">
	| EnumItem<number, HapticEffectType, "GameplayCollision">
export type HapticEffectTypeRoot = EnumObject<{
	Custom: EnumItem<number, HapticEffectType, "Custom">,
	UIHover: EnumItem<number, HapticEffectType, "UIHover">,
	UIClick: EnumItem<number, HapticEffectType, "UIClick">,
	UINotification: EnumItem<number, HapticEffectType, "UINotification">,
	GameplayExplosion: EnumItem<number, HapticEffectType, "GameplayExplosion">,
	GameplayCollision: EnumItem<number, HapticEffectType, "GameplayCollision">,
}, HapticEffectType>
Enum.HapticEffectType = {"Custom", "UIHover", "UIClick", "UINotification", "GameplayExplosion", "GameplayCollision"}

export type HighlightDepthMode =
	| EnumItem<number, HighlightDepthMode, "AlwaysOnTop">
	| EnumItem<number, HighlightDepthMode, "Occluded">
export type HighlightDepthModeRoot = EnumObject<{
	AlwaysOnTop: EnumItem<number, HighlightDepthMode, "AlwaysOnTop">,
	Occluded: EnumItem<number, HighlightDepthMode, "Occluded">,
}, HighlightDepthMode>
Enum.HighlightDepthMode = {"AlwaysOnTop", "Occluded"}

export type HorizontalAlignment =
	| EnumItem<number, HorizontalAlignment, "Center">
	| EnumItem<number, HorizontalAlignment, "Left">
	| EnumItem<number, HorizontalAlignment, "Right">
export type HorizontalAlignmentRoot = EnumObject<{
	Center: EnumItem<number, HorizontalAlignment, "Center">,
	Left: EnumItem<number, HorizontalAlignment, "Left">,
	Right: EnumItem<number, HorizontalAlignment, "Right">,
}, HorizontalAlignment>
Enum.HorizontalAlignment = {"Center", "Left", "Right"}

export type HoverAnimateSpeed =
	| EnumItem<number, HoverAnimateSpeed, "VerySlow">
	| EnumItem<number, HoverAnimateSpeed, "Slow">
	| EnumItem<number, HoverAnimateSpeed, "Medium">
	| EnumItem<number, HoverAnimateSpeed, "Fast">
	| EnumItem<number, HoverAnimateSpeed, "VeryFast">
export type HoverAnimateSpeedRoot = EnumObject<{
	VerySlow: EnumItem<number, HoverAnimateSpeed, "VerySlow">,
	Slow: EnumItem<number, HoverAnimateSpeed, "Slow">,
	Medium: EnumItem<number, HoverAnimateSpeed, "Medium">,
	Fast: EnumItem<number, HoverAnimateSpeed, "Fast">,
	VeryFast: EnumItem<number, HoverAnimateSpeed, "VeryFast">,
}, HoverAnimateSpeed>
Enum.HoverAnimateSpeed = {"VerySlow", "Slow", "Medium", "Fast", "VeryFast"}

export type HttpCachePolicy =
	| EnumItem<number, HttpCachePolicy, "None">
	| EnumItem<number, HttpCachePolicy, "Full">
	| EnumItem<number, HttpCachePolicy, "DataOnly">
	| EnumItem<number, HttpCachePolicy, "Default">
	| EnumItem<number, HttpCachePolicy, "InternalRedirectRefresh">
export type HttpCachePolicyRoot = EnumObject<{
	None: EnumItem<number, HttpCachePolicy, "None">,
	Full: EnumItem<number, HttpCachePolicy, "Full">,
	DataOnly: EnumItem<number, HttpCachePolicy, "DataOnly">,
	Default: EnumItem<number, HttpCachePolicy, "Default">,
	InternalRedirectRefresh: EnumItem<number, HttpCachePolicy, "InternalRedirectRefresh">,
}, HttpCachePolicy>
Enum.HttpCachePolicy = {"None", "Full", "DataOnly", "Default", "InternalRedirectRefresh"}

export type HttpCompression = | EnumItem<number, HttpCompression, "None"> | EnumItem<number, HttpCompression, "Gzip">
export type HttpCompressionRoot = EnumObject<{
	None: EnumItem<number, HttpCompression, "None">,
	Gzip: EnumItem<number, HttpCompression, "Gzip">,
}, HttpCompression>
Enum.HttpCompression = {"None", "Gzip"}

export type HttpContentType =
	| EnumItem<number, HttpContentType, "ApplicationJson">
	| EnumItem<number, HttpContentType, "ApplicationXml">
	| EnumItem<number, HttpContentType, "ApplicationUrlEncoded">
	| EnumItem<number, HttpContentType, "TextPlain">
	| EnumItem<number, HttpContentType, "TextXml">
export type HttpContentTypeRoot = EnumObject<{
	ApplicationJson: EnumItem<number, HttpContentType, "ApplicationJson">,
	ApplicationXml: EnumItem<number, HttpContentType, "ApplicationXml">,
	ApplicationUrlEncoded: EnumItem<number, HttpContentType, "ApplicationUrlEncoded">,
	TextPlain: EnumItem<number, HttpContentType, "TextPlain">,
	TextXml: EnumItem<number, HttpContentType, "TextXml">,
}, HttpContentType>
Enum.HttpContentType = {"ApplicationJson", "ApplicationXml", "ApplicationUrlEncoded", "TextPlain", "TextXml"}

export type HttpError =
	| EnumItem<number, HttpError, "OK">
	| EnumItem<number, HttpError, "InvalidUrl">
	| EnumItem<number, HttpError, "DnsResolve">
	| EnumItem<number, HttpError, "ConnectFail">
	| EnumItem<number, HttpError, "OutOfMemory">
	| EnumItem<number, HttpError, "TimedOut">
	| EnumItem<number, HttpError, "TooManyRedirects">
	| EnumItem<number, HttpError, "InvalidRedirect">
	| EnumItem<number, HttpError, "NetFail">
	| EnumItem<number, HttpError, "Aborted">
	| EnumItem<number, HttpError, "SslConnectFail">
	| EnumItem<number, HttpError, "SslVerificationFail">
	| EnumItem<number, HttpError, "Unknown">
	| EnumItem<number, HttpError, "ConnectionClosed">
	| EnumItem<number, HttpError, "ServerProtocolError">
export type HttpErrorRoot = EnumObject<{
	OK: EnumItem<number, HttpError, "OK">,
	InvalidUrl: EnumItem<number, HttpError, "InvalidUrl">,
	DnsResolve: EnumItem<number, HttpError, "DnsResolve">,
	ConnectFail: EnumItem<number, HttpError, "ConnectFail">,
	OutOfMemory: EnumItem<number, HttpError, "OutOfMemory">,
	TimedOut: EnumItem<number, HttpError, "TimedOut">,
	TooManyRedirects: EnumItem<number, HttpError, "TooManyRedirects">,
	InvalidRedirect: EnumItem<number, HttpError, "InvalidRedirect">,
	NetFail: EnumItem<number, HttpError, "NetFail">,
	Aborted: EnumItem<number, HttpError, "Aborted">,
	SslConnectFail: EnumItem<number, HttpError, "SslConnectFail">,
	SslVerificationFail: EnumItem<number, HttpError, "SslVerificationFail">,
	Unknown: EnumItem<number, HttpError, "Unknown">,
	ConnectionClosed: EnumItem<number, HttpError, "ConnectionClosed">,
	ServerProtocolError: EnumItem<number, HttpError, "ServerProtocolError">,
}, HttpError>
Enum.HttpError = {
	"OK";
	"InvalidUrl";
	"DnsResolve";
	"ConnectFail";
	"OutOfMemory";
	"TimedOut";
	"TooManyRedirects";
	"InvalidRedirect";
	"NetFail";
	"Aborted";
	"SslConnectFail";
	"SslVerificationFail";
	"Unknown";
	"ConnectionClosed";
	"ServerProtocolError";
}

export type HttpRequestType =
	| EnumItem<number, HttpRequestType, "Default">
	| EnumItem<number, HttpRequestType, "MarketplaceService">
	| EnumItem<number, HttpRequestType, "Players">
	| EnumItem<number, HttpRequestType, "Chat">
	| EnumItem<number, HttpRequestType, "Avatar">
	| EnumItem<number, HttpRequestType, "Analytics">
	| EnumItem<number, HttpRequestType, "Localization">
export type HttpRequestTypeRoot = EnumObject<{
	Default: EnumItem<number, HttpRequestType, "Default">,
	MarketplaceService: EnumItem<number, HttpRequestType, "MarketplaceService">,
	Players: EnumItem<number, HttpRequestType, "Players">,
	Chat: EnumItem<number, HttpRequestType, "Chat">,
	Avatar: EnumItem<number, HttpRequestType, "Avatar">,
	Analytics: EnumItem<number, HttpRequestType, "Analytics">,
	Localization: EnumItem<number, HttpRequestType, "Localization">,
}, HttpRequestType>
Enum.HttpRequestType = {
	Default = 0;
	MarketplaceService = 2;
	Players = 7;
	Chat = 15;
	Avatar = 16;
	Analytics = 23;
	Localization = 25;
}

export type HumanoidCollisionType =
	| EnumItem<number, HumanoidCollisionType, "OuterBox">
	| EnumItem<number, HumanoidCollisionType, "InnerBox">
export type HumanoidCollisionTypeRoot = EnumObject<{
	OuterBox: EnumItem<number, HumanoidCollisionType, "OuterBox">,
	InnerBox: EnumItem<number, HumanoidCollisionType, "InnerBox">,
}, HumanoidCollisionType>
Enum.HumanoidCollisionType = {"OuterBox", "InnerBox"}

export type HumanoidDisplayDistanceType =
	| EnumItem<number, HumanoidDisplayDistanceType, "Viewer">
	| EnumItem<number, HumanoidDisplayDistanceType, "Subject">
	| EnumItem<number, HumanoidDisplayDistanceType, "None">
export type HumanoidDisplayDistanceTypeRoot = EnumObject<{
	Viewer: EnumItem<number, HumanoidDisplayDistanceType, "Viewer">,
	Subject: EnumItem<number, HumanoidDisplayDistanceType, "Subject">,
	None: EnumItem<number, HumanoidDisplayDistanceType, "None">,
}, HumanoidDisplayDistanceType>
Enum.HumanoidDisplayDistanceType = {"Viewer", "Subject", "None"}

export type HumanoidHealthDisplayType =
	| EnumItem<number, HumanoidHealthDisplayType, "DisplayWhenDamaged">
	| EnumItem<number, HumanoidHealthDisplayType, "AlwaysOn">
	| EnumItem<number, HumanoidHealthDisplayType, "AlwaysOff">
export type HumanoidHealthDisplayTypeRoot = EnumObject<{
	DisplayWhenDamaged: EnumItem<number, HumanoidHealthDisplayType, "DisplayWhenDamaged">,
	AlwaysOn: EnumItem<number, HumanoidHealthDisplayType, "AlwaysOn">,
	AlwaysOff: EnumItem<number, HumanoidHealthDisplayType, "AlwaysOff">,
}, HumanoidHealthDisplayType>
Enum.HumanoidHealthDisplayType = {"DisplayWhenDamaged", "AlwaysOn", "AlwaysOff"}

export type HumanoidRigType = | EnumItem<number, HumanoidRigType, "R6"> | EnumItem<number, HumanoidRigType, "R15">
export type HumanoidRigTypeRoot = EnumObject<{
	R6: EnumItem<number, HumanoidRigType, "R6">,
	R15: EnumItem<number, HumanoidRigType, "R15">,
}, HumanoidRigType>
Enum.HumanoidRigType = {"R6", "R15"}

export type HumanoidStateType =
	| EnumItem<number, HumanoidStateType, "FallingDown">
	| EnumItem<number, HumanoidStateType, "Ragdoll">
	| EnumItem<number, HumanoidStateType, "GettingUp">
	| EnumItem<number, HumanoidStateType, "Jumping">
	| EnumItem<number, HumanoidStateType, "Swimming">
	| EnumItem<number, HumanoidStateType, "Freefall">
	| EnumItem<number, HumanoidStateType, "Flying">
	| EnumItem<number, HumanoidStateType, "Landed">
	| EnumItem<number, HumanoidStateType, "Running">
	| EnumItem<number, HumanoidStateType, "RunningNoPhysics">
	| EnumItem<number, HumanoidStateType, "StrafingNoPhysics">
	| EnumItem<number, HumanoidStateType, "Climbing">
	| EnumItem<number, HumanoidStateType, "Seated">
	| EnumItem<number, HumanoidStateType, "PlatformStanding">
	| EnumItem<number, HumanoidStateType, "Dead">
	| EnumItem<number, HumanoidStateType, "Physics">
	| EnumItem<number, HumanoidStateType, "None">
export type HumanoidStateTypeRoot = EnumObject<{
	FallingDown: EnumItem<number, HumanoidStateType, "FallingDown">,
	Ragdoll: EnumItem<number, HumanoidStateType, "Ragdoll">,
	GettingUp: EnumItem<number, HumanoidStateType, "GettingUp">,
	Jumping: EnumItem<number, HumanoidStateType, "Jumping">,
	Swimming: EnumItem<number, HumanoidStateType, "Swimming">,
	Freefall: EnumItem<number, HumanoidStateType, "Freefall">,
	Flying: EnumItem<number, HumanoidStateType, "Flying">,
	Landed: EnumItem<number, HumanoidStateType, "Landed">,
	Running: EnumItem<number, HumanoidStateType, "Running">,
	RunningNoPhysics: EnumItem<number, HumanoidStateType, "RunningNoPhysics">,
	StrafingNoPhysics: EnumItem<number, HumanoidStateType, "StrafingNoPhysics">,
	Climbing: EnumItem<number, HumanoidStateType, "Climbing">,
	Seated: EnumItem<number, HumanoidStateType, "Seated">,
	PlatformStanding: EnumItem<number, HumanoidStateType, "PlatformStanding">,
	Dead: EnumItem<number, HumanoidStateType, "Dead">,
	Physics: EnumItem<number, HumanoidStateType, "Physics">,
	None: EnumItem<number, HumanoidStateType, "None">,
}, HumanoidStateType>
Enum.HumanoidStateType = {
	FallingDown = 0;
	Ragdoll = 1;
	GettingUp = 2;
	Jumping = 3;
	Swimming = 4;
	Freefall = 5;
	Flying = 6;
	Landed = 7;
	Running = 8;
	RunningNoPhysics = 10;
	StrafingNoPhysics = 11;
	Climbing = 12;
	Seated = 13;
	PlatformStanding = 14;
	Dead = 15;
	Physics = 16;
	None = 18;
}

export type IKCollisionsMode =
	| EnumItem<number, IKCollisionsMode, "NoCollisions">
	| EnumItem<number, IKCollisionsMode, "OtherMechanismsAnchored">
	| EnumItem<number, IKCollisionsMode, "IncludeContactedMechanisms">
export type IKCollisionsModeRoot = EnumObject<{
	NoCollisions: EnumItem<number, IKCollisionsMode, "NoCollisions">,
	OtherMechanismsAnchored: EnumItem<number, IKCollisionsMode, "OtherMechanismsAnchored">,
	IncludeContactedMechanisms: EnumItem<number, IKCollisionsMode, "IncludeContactedMechanisms">,
}, IKCollisionsMode>
Enum.IKCollisionsMode = {"NoCollisions", "OtherMechanismsAnchored", "IncludeContactedMechanisms"}

export type IKControlConstraintSupport =
	| EnumItem<number, IKControlConstraintSupport, "Default">
	| EnumItem<number, IKControlConstraintSupport, "Disabled">
	| EnumItem<number, IKControlConstraintSupport, "Enabled">
export type IKControlConstraintSupportRoot = EnumObject<{
	Default: EnumItem<number, IKControlConstraintSupport, "Default">,
	Disabled: EnumItem<number, IKControlConstraintSupport, "Disabled">,
	Enabled: EnumItem<number, IKControlConstraintSupport, "Enabled">,
}, IKControlConstraintSupport>
Enum.IKControlConstraintSupport = {"Default", "Disabled", "Enabled"}

export type IKControlType =
	| EnumItem<number, IKControlType, "Transform">
	| EnumItem<number, IKControlType, "Position">
	| EnumItem<number, IKControlType, "Rotation">
	| EnumItem<number, IKControlType, "LookAt">
export type IKControlTypeRoot = EnumObject<{
	Transform: EnumItem<number, IKControlType, "Transform">,
	Position: EnumItem<number, IKControlType, "Position">,
	Rotation: EnumItem<number, IKControlType, "Rotation">,
	LookAt: EnumItem<number, IKControlType, "LookAt">,
}, IKControlType>
Enum.IKControlType = {"Transform", "Position", "Rotation", "LookAt"}

export type IXPLoadingStatus =
	| EnumItem<number, IXPLoadingStatus, "None">
	| EnumItem<number, IXPLoadingStatus, "Pending">
	| EnumItem<number, IXPLoadingStatus, "Initialized">
	| EnumItem<number, IXPLoadingStatus, "ErrorInvalidUser">
	| EnumItem<number, IXPLoadingStatus, "ErrorConnection">
	| EnumItem<number, IXPLoadingStatus, "ErrorJsonParse">
	| EnumItem<number, IXPLoadingStatus, "ErrorTimedOut">
export type IXPLoadingStatusRoot = EnumObject<{
	None: EnumItem<number, IXPLoadingStatus, "None">,
	Pending: EnumItem<number, IXPLoadingStatus, "Pending">,
	Initialized: EnumItem<number, IXPLoadingStatus, "Initialized">,
	ErrorInvalidUser: EnumItem<number, IXPLoadingStatus, "ErrorInvalidUser">,
	ErrorConnection: EnumItem<number, IXPLoadingStatus, "ErrorConnection">,
	ErrorJsonParse: EnumItem<number, IXPLoadingStatus, "ErrorJsonParse">,
	ErrorTimedOut: EnumItem<number, IXPLoadingStatus, "ErrorTimedOut">,
}, IXPLoadingStatus>
Enum.IXPLoadingStatus =
	{"None", "Pending", "Initialized", "ErrorInvalidUser", "ErrorConnection", "ErrorJsonParse", "ErrorTimedOut"}

export type ImageAlphaType =
	| EnumItem<number, ImageAlphaType, "Default">
	| EnumItem<number, ImageAlphaType, "LockCanvasAlpha">
	| EnumItem<number, ImageAlphaType, "LockCanvasColor">
export type ImageAlphaTypeRoot = EnumObject<{
	Default: EnumItem<number, ImageAlphaType, "Default">,
	LockCanvasAlpha: EnumItem<number, ImageAlphaType, "LockCanvasAlpha">,
	LockCanvasColor: EnumItem<number, ImageAlphaType, "LockCanvasColor">,
}, ImageAlphaType>
Enum.ImageAlphaType = {
	Default = 1;
	LockCanvasAlpha = 2;
	LockCanvasColor = 3;
}

export type ImageCombineType =
	| EnumItem<number, ImageCombineType, "BlendSourceOver">
	| EnumItem<number, ImageCombineType, "Overwrite">
	| EnumItem<number, ImageCombineType, "Add">
	| EnumItem<number, ImageCombineType, "Multiply">
	| EnumItem<number, ImageCombineType, "AlphaBlend">
export type ImageCombineTypeRoot = EnumObject<{
	BlendSourceOver: EnumItem<number, ImageCombineType, "BlendSourceOver">,
	Overwrite: EnumItem<number, ImageCombineType, "Overwrite">,
	Add: EnumItem<number, ImageCombineType, "Add">,
	Multiply: EnumItem<number, ImageCombineType, "Multiply">,
	AlphaBlend: EnumItem<number, ImageCombineType, "AlphaBlend">,
}, ImageCombineType>
Enum.ImageCombineType = {
	BlendSourceOver = 1;
	Overwrite = 2;
	Add = 3;
	Multiply = 4;
	AlphaBlend = 5;
}

export type InOut =
	| EnumItem<number, InOut, "Edge">
	| EnumItem<number, InOut, "Inset">
	| EnumItem<number, InOut, "Center">
export type InOutRoot = EnumObject<{
	Edge: EnumItem<number, InOut, "Edge">,
	Inset: EnumItem<number, InOut, "Inset">,
	Center: EnumItem<number, InOut, "Center">,
}, InOut>
Enum.InOut = {"Edge", "Inset", "Center"}

export type InfoType =
	| EnumItem<number, InfoType, "Asset">
	| EnumItem<number, InfoType, "Product">
	| EnumItem<number, InfoType, "GamePass">
	| EnumItem<number, InfoType, "Subscription">
	| EnumItem<number, InfoType, "Bundle">
export type InfoTypeRoot = EnumObject<{
	Asset: EnumItem<number, InfoType, "Asset">,
	Product: EnumItem<number, InfoType, "Product">,
	GamePass: EnumItem<number, InfoType, "GamePass">,
	Subscription: EnumItem<number, InfoType, "Subscription">,
	Bundle: EnumItem<number, InfoType, "Bundle">,
}, InfoType>
Enum.InfoType = {"Asset", "Product", "GamePass", "Subscription", "Bundle"}

export type InitialDockState =
	| EnumItem<number, InitialDockState, "Top">
	| EnumItem<number, InitialDockState, "Bottom">
	| EnumItem<number, InitialDockState, "Left">
	| EnumItem<number, InitialDockState, "Right">
	| EnumItem<number, InitialDockState, "Float">
export type InitialDockStateRoot = EnumObject<{
	Top: EnumItem<number, InitialDockState, "Top">,
	Bottom: EnumItem<number, InitialDockState, "Bottom">,
	Left: EnumItem<number, InitialDockState, "Left">,
	Right: EnumItem<number, InitialDockState, "Right">,
	Float: EnumItem<number, InitialDockState, "Float">,
}, InitialDockState>
Enum.InitialDockState = {"Top", "Bottom", "Left", "Right", "Float"}

export type InputActionType =
	| EnumItem<number, InputActionType, "Bool">
	| EnumItem<number, InputActionType, "Direction1D">
	| EnumItem<number, InputActionType, "Direction2D">
export type InputActionTypeRoot = EnumObject<{
	Bool: EnumItem<number, InputActionType, "Bool">,
	Direction1D: EnumItem<number, InputActionType, "Direction1D">,
	Direction2D: EnumItem<number, InputActionType, "Direction2D">,
}, InputActionType>
Enum.InputActionType = {"Bool", "Direction1D", "Direction2D"}

export type InputType =
	| EnumItem<number, InputType, "NoInput">
	| EnumItem<number, InputType, "Constant">
	| EnumItem<number, InputType, "Sin">
export type InputTypeRoot = EnumObject<{
	NoInput: EnumItem<number, InputType, "NoInput">,
	Constant: EnumItem<number, InputType, "Constant">,
	Sin: EnumItem<number, InputType, "Sin">,
}, InputType>
Enum.InputType = {
	NoInput = 0;
	Constant = 12;
	Sin = 13;
}

export type IntermediateMeshGenerationResult = | EnumItem<
	number,
	IntermediateMeshGenerationResult,
	"HighQualityMesh"
>
export type IntermediateMeshGenerationResultRoot = EnumObject<{
	HighQualityMesh: EnumItem<number, IntermediateMeshGenerationResult, "HighQualityMesh">,
}, IntermediateMeshGenerationResult>
Enum.IntermediateMeshGenerationResult = {"HighQualityMesh"}

export type InterpolationThrottlingMode =
	| EnumItem<number, InterpolationThrottlingMode, "Default">
	| EnumItem<number, InterpolationThrottlingMode, "Disabled">
	| EnumItem<number, InterpolationThrottlingMode, "Enabled">
export type InterpolationThrottlingModeRoot = EnumObject<{
	Default: EnumItem<number, InterpolationThrottlingMode, "Default">,
	Disabled: EnumItem<number, InterpolationThrottlingMode, "Disabled">,
	Enabled: EnumItem<number, InterpolationThrottlingMode, "Enabled">,
}, InterpolationThrottlingMode>
Enum.InterpolationThrottlingMode = {"Default", "Disabled", "Enabled"}

export type InviteState =
	| EnumItem<number, InviteState, "Placed">
	| EnumItem<number, InviteState, "Accepted">
	| EnumItem<number, InviteState, "Declined">
	| EnumItem<number, InviteState, "Missed">
export type InviteStateRoot = EnumObject<{
	Placed: EnumItem<number, InviteState, "Placed">,
	Accepted: EnumItem<number, InviteState, "Accepted">,
	Declined: EnumItem<number, InviteState, "Declined">,
	Missed: EnumItem<number, InviteState, "Missed">,
}, InviteState>
Enum.InviteState = {"Placed", "Accepted", "Declined", "Missed"}

export type ItemLineAlignment =
	| EnumItem<number, ItemLineAlignment, "Automatic">
	| EnumItem<number, ItemLineAlignment, "Start">
	| EnumItem<number, ItemLineAlignment, "Center">
	| EnumItem<number, ItemLineAlignment, "End">
	| EnumItem<number, ItemLineAlignment, "Stretch">
export type ItemLineAlignmentRoot = EnumObject<{
	Automatic: EnumItem<number, ItemLineAlignment, "Automatic">,
	Start: EnumItem<number, ItemLineAlignment, "Start">,
	Center: EnumItem<number, ItemLineAlignment, "Center">,
	End: EnumItem<number, ItemLineAlignment, "End">,
	Stretch: EnumItem<number, ItemLineAlignment, "Stretch">,
}, ItemLineAlignment>
Enum.ItemLineAlignment = {"Automatic", "Start", "Center", "End", "Stretch"}

export type JoinSource = | EnumItem<number, JoinSource, "CreatedItemAttribution">
export type JoinSourceRoot = EnumObject<{
	CreatedItemAttribution: EnumItem<number, JoinSource, "CreatedItemAttribution">,
}, JoinSource>
Enum.JoinSource = {
	CreatedItemAttribution = 1;
}

export type JointCreationMode =
	| EnumItem<number, JointCreationMode, "All">
	| EnumItem<number, JointCreationMode, "Surface">
	| EnumItem<number, JointCreationMode, "None">
export type JointCreationModeRoot = EnumObject<{
	All: EnumItem<number, JointCreationMode, "All">,
	Surface: EnumItem<number, JointCreationMode, "Surface">,
	None: EnumItem<number, JointCreationMode, "None">,
}, JointCreationMode>
Enum.JointCreationMode = {"All", "Surface", "None"}

export type KeyCode =
	| EnumItem<number, KeyCode, "Unknown">
	| EnumItem<number, KeyCode, "Backspace">
	| EnumItem<number, KeyCode, "Tab">
	| EnumItem<number, KeyCode, "Clear">
	| EnumItem<number, KeyCode, "Return">
	| EnumItem<number, KeyCode, "Pause">
	| EnumItem<number, KeyCode, "Escape">
	| EnumItem<number, KeyCode, "Space">
	| EnumItem<number, KeyCode, "QuotedDouble">
	| EnumItem<number, KeyCode, "Hash">
	| EnumItem<number, KeyCode, "Dollar">
	| EnumItem<number, KeyCode, "Percent">
	| EnumItem<number, KeyCode, "Ampersand">
	| EnumItem<number, KeyCode, "Quote">
	| EnumItem<number, KeyCode, "LeftParenthesis">
	| EnumItem<number, KeyCode, "RightParenthesis">
	| EnumItem<number, KeyCode, "Asterisk">
	| EnumItem<number, KeyCode, "Plus">
	| EnumItem<number, KeyCode, "Comma">
	| EnumItem<number, KeyCode, "Minus">
	| EnumItem<number, KeyCode, "Period">
	| EnumItem<number, KeyCode, "Slash">
	| EnumItem<number, KeyCode, "Zero">
	| EnumItem<number, KeyCode, "One">
	| EnumItem<number, KeyCode, "Two">
	| EnumItem<number, KeyCode, "Three">
	| EnumItem<number, KeyCode, "Four">
	| EnumItem<number, KeyCode, "Five">
	| EnumItem<number, KeyCode, "Six">
	| EnumItem<number, KeyCode, "Seven">
	| EnumItem<number, KeyCode, "Eight">
	| EnumItem<number, KeyCode, "Nine">
	| EnumItem<number, KeyCode, "Colon">
	| EnumItem<number, KeyCode, "Semicolon">
	| EnumItem<number, KeyCode, "LessThan">
	| EnumItem<number, KeyCode, "Equals">
	| EnumItem<number, KeyCode, "GreaterThan">
	| EnumItem<number, KeyCode, "Question">
	| EnumItem<number, KeyCode, "At">
	| EnumItem<number, KeyCode, "LeftBracket">
	| EnumItem<number, KeyCode, "BackSlash">
	| EnumItem<number, KeyCode, "RightBracket">
	| EnumItem<number, KeyCode, "Caret">
	| EnumItem<number, KeyCode, "Underscore">
	| EnumItem<number, KeyCode, "Backquote">
	| EnumItem<number, KeyCode, "A">
	| EnumItem<number, KeyCode, "B">
	| EnumItem<number, KeyCode, "C">
	| EnumItem<number, KeyCode, "D">
	| EnumItem<number, KeyCode, "E">
	| EnumItem<number, KeyCode, "F">
	| EnumItem<number, KeyCode, "G">
	| EnumItem<number, KeyCode, "H">
	| EnumItem<number, KeyCode, "I">
	| EnumItem<number, KeyCode, "J">
	| EnumItem<number, KeyCode, "K">
	| EnumItem<number, KeyCode, "L">
	| EnumItem<number, KeyCode, "M">
	| EnumItem<number, KeyCode, "N">
	| EnumItem<number, KeyCode, "O">
	| EnumItem<number, KeyCode, "P">
	| EnumItem<number, KeyCode, "Q">
	| EnumItem<number, KeyCode, "R">
	| EnumItem<number, KeyCode, "S">
	| EnumItem<number, KeyCode, "T">
	| EnumItem<number, KeyCode, "U">
	| EnumItem<number, KeyCode, "V">
	| EnumItem<number, KeyCode, "W">
	| EnumItem<number, KeyCode, "X">
	| EnumItem<number, KeyCode, "Y">
	| EnumItem<number, KeyCode, "Z">
	| EnumItem<number, KeyCode, "LeftCurly">
	| EnumItem<number, KeyCode, "Pipe">
	| EnumItem<number, KeyCode, "RightCurly">
	| EnumItem<number, KeyCode, "Tilde">
	| EnumItem<number, KeyCode, "Delete">
	| EnumItem<number, KeyCode, "World0">
	| EnumItem<number, KeyCode, "World1">
	| EnumItem<number, KeyCode, "World2">
	| EnumItem<number, KeyCode, "World3">
	| EnumItem<number, KeyCode, "World4">
	| EnumItem<number, KeyCode, "World5">
	| EnumItem<number, KeyCode, "World6">
	| EnumItem<number, KeyCode, "World7">
	| EnumItem<number, KeyCode, "World8">
	| EnumItem<number, KeyCode, "World9">
	| EnumItem<number, KeyCode, "World10">
	| EnumItem<number, KeyCode, "World11">
	| EnumItem<number, KeyCode, "World12">
	| EnumItem<number, KeyCode, "World13">
	| EnumItem<number, KeyCode, "World14">
	| EnumItem<number, KeyCode, "World15">
	| EnumItem<number, KeyCode, "World16">
	| EnumItem<number, KeyCode, "World17">
	| EnumItem<number, KeyCode, "World18">
	| EnumItem<number, KeyCode, "World19">
	| EnumItem<number, KeyCode, "World20">
	| EnumItem<number, KeyCode, "World21">
	| EnumItem<number, KeyCode, "World22">
	| EnumItem<number, KeyCode, "World23">
	| EnumItem<number, KeyCode, "World24">
	| EnumItem<number, KeyCode, "World25">
	| EnumItem<number, KeyCode, "World26">
	| EnumItem<number, KeyCode, "World27">
	| EnumItem<number, KeyCode, "World28">
	| EnumItem<number, KeyCode, "World29">
	| EnumItem<number, KeyCode, "World30">
	| EnumItem<number, KeyCode, "World31">
	| EnumItem<number, KeyCode, "World32">
	| EnumItem<number, KeyCode, "World33">
	| EnumItem<number, KeyCode, "World34">
	| EnumItem<number, KeyCode, "World35">
	| EnumItem<number, KeyCode, "World36">
	| EnumItem<number, KeyCode, "World37">
	| EnumItem<number, KeyCode, "World38">
	| EnumItem<number, KeyCode, "World39">
	| EnumItem<number, KeyCode, "World40">
	| EnumItem<number, KeyCode, "World41">
	| EnumItem<number, KeyCode, "World42">
	| EnumItem<number, KeyCode, "World43">
	| EnumItem<number, KeyCode, "World44">
	| EnumItem<number, KeyCode, "World45">
	| EnumItem<number, KeyCode, "World46">
	| EnumItem<number, KeyCode, "World47">
	| EnumItem<number, KeyCode, "World48">
	| EnumItem<number, KeyCode, "World49">
	| EnumItem<number, KeyCode, "World50">
	| EnumItem<number, KeyCode, "World51">
	| EnumItem<number, KeyCode, "World52">
	| EnumItem<number, KeyCode, "World53">
	| EnumItem<number, KeyCode, "World54">
	| EnumItem<number, KeyCode, "World55">
	| EnumItem<number, KeyCode, "World56">
	| EnumItem<number, KeyCode, "World57">
	| EnumItem<number, KeyCode, "World58">
	| EnumItem<number, KeyCode, "World59">
	| EnumItem<number, KeyCode, "World60">
	| EnumItem<number, KeyCode, "World61">
	| EnumItem<number, KeyCode, "World62">
	| EnumItem<number, KeyCode, "World63">
	| EnumItem<number, KeyCode, "World64">
	| EnumItem<number, KeyCode, "World65">
	| EnumItem<number, KeyCode, "World66">
	| EnumItem<number, KeyCode, "World67">
	| EnumItem<number, KeyCode, "World68">
	| EnumItem<number, KeyCode, "World69">
	| EnumItem<number, KeyCode, "World70">
	| EnumItem<number, KeyCode, "World71">
	| EnumItem<number, KeyCode, "World72">
	| EnumItem<number, KeyCode, "World73">
	| EnumItem<number, KeyCode, "World74">
	| EnumItem<number, KeyCode, "World75">
	| EnumItem<number, KeyCode, "World76">
	| EnumItem<number, KeyCode, "World77">
	| EnumItem<number, KeyCode, "World78">
	| EnumItem<number, KeyCode, "World79">
	| EnumItem<number, KeyCode, "World80">
	| EnumItem<number, KeyCode, "World81">
	| EnumItem<number, KeyCode, "World82">
	| EnumItem<number, KeyCode, "World83">
	| EnumItem<number, KeyCode, "World84">
	| EnumItem<number, KeyCode, "World85">
	| EnumItem<number, KeyCode, "World86">
	| EnumItem<number, KeyCode, "World87">
	| EnumItem<number, KeyCode, "World88">
	| EnumItem<number, KeyCode, "World89">
	| EnumItem<number, KeyCode, "World90">
	| EnumItem<number, KeyCode, "World91">
	| EnumItem<number, KeyCode, "World92">
	| EnumItem<number, KeyCode, "World93">
	| EnumItem<number, KeyCode, "World94">
	| EnumItem<number, KeyCode, "World95">
	| EnumItem<number, KeyCode, "KeypadZero">
	| EnumItem<number, KeyCode, "KeypadOne">
	| EnumItem<number, KeyCode, "KeypadTwo">
	| EnumItem<number, KeyCode, "KeypadThree">
	| EnumItem<number, KeyCode, "KeypadFour">
	| EnumItem<number, KeyCode, "KeypadFive">
	| EnumItem<number, KeyCode, "KeypadSix">
	| EnumItem<number, KeyCode, "KeypadSeven">
	| EnumItem<number, KeyCode, "KeypadEight">
	| EnumItem<number, KeyCode, "KeypadNine">
	| EnumItem<number, KeyCode, "KeypadPeriod">
	| EnumItem<number, KeyCode, "KeypadDivide">
	| EnumItem<number, KeyCode, "KeypadMultiply">
	| EnumItem<number, KeyCode, "KeypadMinus">
	| EnumItem<number, KeyCode, "KeypadPlus">
	| EnumItem<number, KeyCode, "KeypadEnter">
	| EnumItem<number, KeyCode, "KeypadEquals">
	| EnumItem<number, KeyCode, "Up">
	| EnumItem<number, KeyCode, "Down">
	| EnumItem<number, KeyCode, "Right">
	| EnumItem<number, KeyCode, "Left">
	| EnumItem<number, KeyCode, "Insert">
	| EnumItem<number, KeyCode, "Home">
	| EnumItem<number, KeyCode, "End">
	| EnumItem<number, KeyCode, "PageUp">
	| EnumItem<number, KeyCode, "PageDown">
	| EnumItem<number, KeyCode, "F1">
	| EnumItem<number, KeyCode, "F2">
	| EnumItem<number, KeyCode, "F3">
	| EnumItem<number, KeyCode, "F4">
	| EnumItem<number, KeyCode, "F5">
	| EnumItem<number, KeyCode, "F6">
	| EnumItem<number, KeyCode, "F7">
	| EnumItem<number, KeyCode, "F8">
	| EnumItem<number, KeyCode, "F9">
	| EnumItem<number, KeyCode, "F10">
	| EnumItem<number, KeyCode, "F11">
	| EnumItem<number, KeyCode, "F12">
	| EnumItem<number, KeyCode, "F13">
	| EnumItem<number, KeyCode, "F14">
	| EnumItem<number, KeyCode, "F15">
	| EnumItem<number, KeyCode, "NumLock">
	| EnumItem<number, KeyCode, "CapsLock">
	| EnumItem<number, KeyCode, "ScrollLock">
	| EnumItem<number, KeyCode, "RightShift">
	| EnumItem<number, KeyCode, "LeftShift">
	| EnumItem<number, KeyCode, "RightControl">
	| EnumItem<number, KeyCode, "LeftControl">
	| EnumItem<number, KeyCode, "RightAlt">
	| EnumItem<number, KeyCode, "LeftAlt">
	| EnumItem<number, KeyCode, "RightMeta">
	| EnumItem<number, KeyCode, "LeftMeta">
	| EnumItem<number, KeyCode, "LeftSuper">
	| EnumItem<number, KeyCode, "RightSuper">
	| EnumItem<number, KeyCode, "Mode">
	| EnumItem<number, KeyCode, "Compose">
	| EnumItem<number, KeyCode, "Help">
	| EnumItem<number, KeyCode, "Print">
	| EnumItem<number, KeyCode, "SysReq">
	| EnumItem<number, KeyCode, "Break">
	| EnumItem<number, KeyCode, "Menu">
	| EnumItem<number, KeyCode, "Power">
	| EnumItem<number, KeyCode, "Euro">
	| EnumItem<number, KeyCode, "Undo">
	| EnumItem<number, KeyCode, "ButtonX">
	| EnumItem<number, KeyCode, "ButtonY">
	| EnumItem<number, KeyCode, "ButtonA">
	| EnumItem<number, KeyCode, "ButtonB">
	| EnumItem<number, KeyCode, "ButtonR1">
	| EnumItem<number, KeyCode, "ButtonL1">
	| EnumItem<number, KeyCode, "ButtonR2">
	| EnumItem<number, KeyCode, "ButtonL2">
	| EnumItem<number, KeyCode, "ButtonR3">
	| EnumItem<number, KeyCode, "ButtonL3">
	| EnumItem<number, KeyCode, "ButtonStart">
	| EnumItem<number, KeyCode, "ButtonSelect">
	| EnumItem<number, KeyCode, "DPadLeft">
	| EnumItem<number, KeyCode, "DPadRight">
	| EnumItem<number, KeyCode, "DPadUp">
	| EnumItem<number, KeyCode, "DPadDown">
	| EnumItem<number, KeyCode, "Thumbstick1">
	| EnumItem<number, KeyCode, "Thumbstick2">
	| EnumItem<number, KeyCode, "MouseLeftButton">
	| EnumItem<number, KeyCode, "MouseRightButton">
	| EnumItem<number, KeyCode, "MouseMiddleButton">
	| EnumItem<number, KeyCode, "MouseBackButton">
	| EnumItem<number, KeyCode, "MouseNoButton">
	| EnumItem<number, KeyCode, "MouseX">
	| EnumItem<number, KeyCode, "MouseY">
export type KeyCodeRoot = EnumObject<{
	Unknown: EnumItem<number, KeyCode, "Unknown">,
	Backspace: EnumItem<number, KeyCode, "Backspace">,
	Tab: EnumItem<number, KeyCode, "Tab">,
	Clear: EnumItem<number, KeyCode, "Clear">,
	Return: EnumItem<number, KeyCode, "Return">,
	Pause: EnumItem<number, KeyCode, "Pause">,
	Escape: EnumItem<number, KeyCode, "Escape">,
	Space: EnumItem<number, KeyCode, "Space">,
	QuotedDouble: EnumItem<number, KeyCode, "QuotedDouble">,
	Hash: EnumItem<number, KeyCode, "Hash">,
	Dollar: EnumItem<number, KeyCode, "Dollar">,
	Percent: EnumItem<number, KeyCode, "Percent">,
	Ampersand: EnumItem<number, KeyCode, "Ampersand">,
	Quote: EnumItem<number, KeyCode, "Quote">,
	LeftParenthesis: EnumItem<number, KeyCode, "LeftParenthesis">,
	RightParenthesis: EnumItem<number, KeyCode, "RightParenthesis">,
	Asterisk: EnumItem<number, KeyCode, "Asterisk">,
	Plus: EnumItem<number, KeyCode, "Plus">,
	Comma: EnumItem<number, KeyCode, "Comma">,
	Minus: EnumItem<number, KeyCode, "Minus">,
	Period: EnumItem<number, KeyCode, "Period">,
	Slash: EnumItem<number, KeyCode, "Slash">,
	Zero: EnumItem<number, KeyCode, "Zero">,
	One: EnumItem<number, KeyCode, "One">,
	Two: EnumItem<number, KeyCode, "Two">,
	Three: EnumItem<number, KeyCode, "Three">,
	Four: EnumItem<number, KeyCode, "Four">,
	Five: EnumItem<number, KeyCode, "Five">,
	Six: EnumItem<number, KeyCode, "Six">,
	Seven: EnumItem<number, KeyCode, "Seven">,
	Eight: EnumItem<number, KeyCode, "Eight">,
	Nine: EnumItem<number, KeyCode, "Nine">,
	Colon: EnumItem<number, KeyCode, "Colon">,
	Semicolon: EnumItem<number, KeyCode, "Semicolon">,
	LessThan: EnumItem<number, KeyCode, "LessThan">,
	Equals: EnumItem<number, KeyCode, "Equals">,
	GreaterThan: EnumItem<number, KeyCode, "GreaterThan">,
	Question: EnumItem<number, KeyCode, "Question">,
	At: EnumItem<number, KeyCode, "At">,
	LeftBracket: EnumItem<number, KeyCode, "LeftBracket">,
	BackSlash: EnumItem<number, KeyCode, "BackSlash">,
	RightBracket: EnumItem<number, KeyCode, "RightBracket">,
	Caret: EnumItem<number, KeyCode, "Caret">,
	Underscore: EnumItem<number, KeyCode, "Underscore">,
	Backquote: EnumItem<number, KeyCode, "Backquote">,
	A: EnumItem<number, KeyCode, "A">,
	B: EnumItem<number, KeyCode, "B">,
	C: EnumItem<number, KeyCode, "C">,
	D: EnumItem<number, KeyCode, "D">,
	E: EnumItem<number, KeyCode, "E">,
	F: EnumItem<number, KeyCode, "F">,
	G: EnumItem<number, KeyCode, "G">,
	H: EnumItem<number, KeyCode, "H">,
	I: EnumItem<number, KeyCode, "I">,
	J: EnumItem<number, KeyCode, "J">,
	K: EnumItem<number, KeyCode, "K">,
	L: EnumItem<number, KeyCode, "L">,
	M: EnumItem<number, KeyCode, "M">,
	N: EnumItem<number, KeyCode, "N">,
	O: EnumItem<number, KeyCode, "O">,
	P: EnumItem<number, KeyCode, "P">,
	Q: EnumItem<number, KeyCode, "Q">,
	R: EnumItem<number, KeyCode, "R">,
	S: EnumItem<number, KeyCode, "S">,
	T: EnumItem<number, KeyCode, "T">,
	U: EnumItem<number, KeyCode, "U">,
	V: EnumItem<number, KeyCode, "V">,
	W: EnumItem<number, KeyCode, "W">,
	X: EnumItem<number, KeyCode, "X">,
	Y: EnumItem<number, KeyCode, "Y">,
	Z: EnumItem<number, KeyCode, "Z">,
	LeftCurly: EnumItem<number, KeyCode, "LeftCurly">,
	Pipe: EnumItem<number, KeyCode, "Pipe">,
	RightCurly: EnumItem<number, KeyCode, "RightCurly">,
	Tilde: EnumItem<number, KeyCode, "Tilde">,
	Delete: EnumItem<number, KeyCode, "Delete">,
	World0: EnumItem<number, KeyCode, "World0">,
	World1: EnumItem<number, KeyCode, "World1">,
	World2: EnumItem<number, KeyCode, "World2">,
	World3: EnumItem<number, KeyCode, "World3">,
	World4: EnumItem<number, KeyCode, "World4">,
	World5: EnumItem<number, KeyCode, "World5">,
	World6: EnumItem<number, KeyCode, "World6">,
	World7: EnumItem<number, KeyCode, "World7">,
	World8: EnumItem<number, KeyCode, "World8">,
	World9: EnumItem<number, KeyCode, "World9">,
	World10: EnumItem<number, KeyCode, "World10">,
	World11: EnumItem<number, KeyCode, "World11">,
	World12: EnumItem<number, KeyCode, "World12">,
	World13: EnumItem<number, KeyCode, "World13">,
	World14: EnumItem<number, KeyCode, "World14">,
	World15: EnumItem<number, KeyCode, "World15">,
	World16: EnumItem<number, KeyCode, "World16">,
	World17: EnumItem<number, KeyCode, "World17">,
	World18: EnumItem<number, KeyCode, "World18">,
	World19: EnumItem<number, KeyCode, "World19">,
	World20: EnumItem<number, KeyCode, "World20">,
	World21: EnumItem<number, KeyCode, "World21">,
	World22: EnumItem<number, KeyCode, "World22">,
	World23: EnumItem<number, KeyCode, "World23">,
	World24: EnumItem<number, KeyCode, "World24">,
	World25: EnumItem<number, KeyCode, "World25">,
	World26: EnumItem<number, KeyCode, "World26">,
	World27: EnumItem<number, KeyCode, "World27">,
	World28: EnumItem<number, KeyCode, "World28">,
	World29: EnumItem<number, KeyCode, "World29">,
	World30: EnumItem<number, KeyCode, "World30">,
	World31: EnumItem<number, KeyCode, "World31">,
	World32: EnumItem<number, KeyCode, "World32">,
	World33: EnumItem<number, KeyCode, "World33">,
	World34: EnumItem<number, KeyCode, "World34">,
	World35: EnumItem<number, KeyCode, "World35">,
	World36: EnumItem<number, KeyCode, "World36">,
	World37: EnumItem<number, KeyCode, "World37">,
	World38: EnumItem<number, KeyCode, "World38">,
	World39: EnumItem<number, KeyCode, "World39">,
	World40: EnumItem<number, KeyCode, "World40">,
	World41: EnumItem<number, KeyCode, "World41">,
	World42: EnumItem<number, KeyCode, "World42">,
	World43: EnumItem<number, KeyCode, "World43">,
	World44: EnumItem<number, KeyCode, "World44">,
	World45: EnumItem<number, KeyCode, "World45">,
	World46: EnumItem<number, KeyCode, "World46">,
	World47: EnumItem<number, KeyCode, "World47">,
	World48: EnumItem<number, KeyCode, "World48">,
	World49: EnumItem<number, KeyCode, "World49">,
	World50: EnumItem<number, KeyCode, "World50">,
	World51: EnumItem<number, KeyCode, "World51">,
	World52: EnumItem<number, KeyCode, "World52">,
	World53: EnumItem<number, KeyCode, "World53">,
	World54: EnumItem<number, KeyCode, "World54">,
	World55: EnumItem<number, KeyCode, "World55">,
	World56: EnumItem<number, KeyCode, "World56">,
	World57: EnumItem<number, KeyCode, "World57">,
	World58: EnumItem<number, KeyCode, "World58">,
	World59: EnumItem<number, KeyCode, "World59">,
	World60: EnumItem<number, KeyCode, "World60">,
	World61: EnumItem<number, KeyCode, "World61">,
	World62: EnumItem<number, KeyCode, "World62">,
	World63: EnumItem<number, KeyCode, "World63">,
	World64: EnumItem<number, KeyCode, "World64">,
	World65: EnumItem<number, KeyCode, "World65">,
	World66: EnumItem<number, KeyCode, "World66">,
	World67: EnumItem<number, KeyCode, "World67">,
	World68: EnumItem<number, KeyCode, "World68">,
	World69: EnumItem<number, KeyCode, "World69">,
	World70: EnumItem<number, KeyCode, "World70">,
	World71: EnumItem<number, KeyCode, "World71">,
	World72: EnumItem<number, KeyCode, "World72">,
	World73: EnumItem<number, KeyCode, "World73">,
	World74: EnumItem<number, KeyCode, "World74">,
	World75: EnumItem<number, KeyCode, "World75">,
	World76: EnumItem<number, KeyCode, "World76">,
	World77: EnumItem<number, KeyCode, "World77">,
	World78: EnumItem<number, KeyCode, "World78">,
	World79: EnumItem<number, KeyCode, "World79">,
	World80: EnumItem<number, KeyCode, "World80">,
	World81: EnumItem<number, KeyCode, "World81">,
	World82: EnumItem<number, KeyCode, "World82">,
	World83: EnumItem<number, KeyCode, "World83">,
	World84: EnumItem<number, KeyCode, "World84">,
	World85: EnumItem<number, KeyCode, "World85">,
	World86: EnumItem<number, KeyCode, "World86">,
	World87: EnumItem<number, KeyCode, "World87">,
	World88: EnumItem<number, KeyCode, "World88">,
	World89: EnumItem<number, KeyCode, "World89">,
	World90: EnumItem<number, KeyCode, "World90">,
	World91: EnumItem<number, KeyCode, "World91">,
	World92: EnumItem<number, KeyCode, "World92">,
	World93: EnumItem<number, KeyCode, "World93">,
	World94: EnumItem<number, KeyCode, "World94">,
	World95: EnumItem<number, KeyCode, "World95">,
	KeypadZero: EnumItem<number, KeyCode, "KeypadZero">,
	KeypadOne: EnumItem<number, KeyCode, "KeypadOne">,
	KeypadTwo: EnumItem<number, KeyCode, "KeypadTwo">,
	KeypadThree: EnumItem<number, KeyCode, "KeypadThree">,
	KeypadFour: EnumItem<number, KeyCode, "KeypadFour">,
	KeypadFive: EnumItem<number, KeyCode, "KeypadFive">,
	KeypadSix: EnumItem<number, KeyCode, "KeypadSix">,
	KeypadSeven: EnumItem<number, KeyCode, "KeypadSeven">,
	KeypadEight: EnumItem<number, KeyCode, "KeypadEight">,
	KeypadNine: EnumItem<number, KeyCode, "KeypadNine">,
	KeypadPeriod: EnumItem<number, KeyCode, "KeypadPeriod">,
	KeypadDivide: EnumItem<number, KeyCode, "KeypadDivide">,
	KeypadMultiply: EnumItem<number, KeyCode, "KeypadMultiply">,
	KeypadMinus: EnumItem<number, KeyCode, "KeypadMinus">,
	KeypadPlus: EnumItem<number, KeyCode, "KeypadPlus">,
	KeypadEnter: EnumItem<number, KeyCode, "KeypadEnter">,
	KeypadEquals: EnumItem<number, KeyCode, "KeypadEquals">,
	Up: EnumItem<number, KeyCode, "Up">,
	Down: EnumItem<number, KeyCode, "Down">,
	Right: EnumItem<number, KeyCode, "Right">,
	Left: EnumItem<number, KeyCode, "Left">,
	Insert: EnumItem<number, KeyCode, "Insert">,
	Home: EnumItem<number, KeyCode, "Home">,
	End: EnumItem<number, KeyCode, "End">,
	PageUp: EnumItem<number, KeyCode, "PageUp">,
	PageDown: EnumItem<number, KeyCode, "PageDown">,
	F1: EnumItem<number, KeyCode, "F1">,
	F2: EnumItem<number, KeyCode, "F2">,
	F3: EnumItem<number, KeyCode, "F3">,
	F4: EnumItem<number, KeyCode, "F4">,
	F5: EnumItem<number, KeyCode, "F5">,
	F6: EnumItem<number, KeyCode, "F6">,
	F7: EnumItem<number, KeyCode, "F7">,
	F8: EnumItem<number, KeyCode, "F8">,
	F9: EnumItem<number, KeyCode, "F9">,
	F10: EnumItem<number, KeyCode, "F10">,
	F11: EnumItem<number, KeyCode, "F11">,
	F12: EnumItem<number, KeyCode, "F12">,
	F13: EnumItem<number, KeyCode, "F13">,
	F14: EnumItem<number, KeyCode, "F14">,
	F15: EnumItem<number, KeyCode, "F15">,
	NumLock: EnumItem<number, KeyCode, "NumLock">,
	CapsLock: EnumItem<number, KeyCode, "CapsLock">,
	ScrollLock: EnumItem<number, KeyCode, "ScrollLock">,
	RightShift: EnumItem<number, KeyCode, "RightShift">,
	LeftShift: EnumItem<number, KeyCode, "LeftShift">,
	RightControl: EnumItem<number, KeyCode, "RightControl">,
	LeftControl: EnumItem<number, KeyCode, "LeftControl">,
	RightAlt: EnumItem<number, KeyCode, "RightAlt">,
	LeftAlt: EnumItem<number, KeyCode, "LeftAlt">,
	RightMeta: EnumItem<number, KeyCode, "RightMeta">,
	LeftMeta: EnumItem<number, KeyCode, "LeftMeta">,
	LeftSuper: EnumItem<number, KeyCode, "LeftSuper">,
	RightSuper: EnumItem<number, KeyCode, "RightSuper">,
	Mode: EnumItem<number, KeyCode, "Mode">,
	Compose: EnumItem<number, KeyCode, "Compose">,
	Help: EnumItem<number, KeyCode, "Help">,
	Print: EnumItem<number, KeyCode, "Print">,
	SysReq: EnumItem<number, KeyCode, "SysReq">,
	Break: EnumItem<number, KeyCode, "Break">,
	Menu: EnumItem<number, KeyCode, "Menu">,
	Power: EnumItem<number, KeyCode, "Power">,
	Euro: EnumItem<number, KeyCode, "Euro">,
	Undo: EnumItem<number, KeyCode, "Undo">,
	ButtonX: EnumItem<number, KeyCode, "ButtonX">,
	ButtonY: EnumItem<number, KeyCode, "ButtonY">,
	ButtonA: EnumItem<number, KeyCode, "ButtonA">,
	ButtonB: EnumItem<number, KeyCode, "ButtonB">,
	ButtonR1: EnumItem<number, KeyCode, "ButtonR1">,
	ButtonL1: EnumItem<number, KeyCode, "ButtonL1">,
	ButtonR2: EnumItem<number, KeyCode, "ButtonR2">,
	ButtonL2: EnumItem<number, KeyCode, "ButtonL2">,
	ButtonR3: EnumItem<number, KeyCode, "ButtonR3">,
	ButtonL3: EnumItem<number, KeyCode, "ButtonL3">,
	ButtonStart: EnumItem<number, KeyCode, "ButtonStart">,
	ButtonSelect: EnumItem<number, KeyCode, "ButtonSelect">,
	DPadLeft: EnumItem<number, KeyCode, "DPadLeft">,
	DPadRight: EnumItem<number, KeyCode, "DPadRight">,
	DPadUp: EnumItem<number, KeyCode, "DPadUp">,
	DPadDown: EnumItem<number, KeyCode, "DPadDown">,
	Thumbstick1: EnumItem<number, KeyCode, "Thumbstick1">,
	Thumbstick2: EnumItem<number, KeyCode, "Thumbstick2">,
	MouseLeftButton: EnumItem<number, KeyCode, "MouseLeftButton">,
	MouseRightButton: EnumItem<number, KeyCode, "MouseRightButton">,
	MouseMiddleButton: EnumItem<number, KeyCode, "MouseMiddleButton">,
	MouseBackButton: EnumItem<number, KeyCode, "MouseBackButton">,
	MouseNoButton: EnumItem<number, KeyCode, "MouseNoButton">,
	MouseX: EnumItem<number, KeyCode, "MouseX">,
	MouseY: EnumItem<number, KeyCode, "MouseY">,
}, KeyCode>
Enum.KeyCode = {
	Unknown = 0;
	Backspace = 8;
	Tab = 9;
	Clear = 12;
	Return = 13;
	Pause = 19;
	Escape = 27;
	Space = 32;
	QuotedDouble = 34;
	Hash = 35;
	Dollar = 36;
	Percent = 37;
	Ampersand = 38;
	Quote = 39;
	LeftParenthesis = 40;
	RightParenthesis = 41;
	Asterisk = 42;
	Plus = 43;
	Comma = 44;
	Minus = 45;
	Period = 46;
	Slash = 47;
	Zero = 48;
	One = 49;
	Two = 50;
	Three = 51;
	Four = 52;
	Five = 53;
	Six = 54;
	Seven = 55;
	Eight = 56;
	Nine = 57;
	Colon = 58;
	Semicolon = 59;
	LessThan = 60;
	Equals = 61;
	GreaterThan = 62;
	Question = 63;
	At = 64;
	LeftBracket = 91;
	BackSlash = 92;
	RightBracket = 93;
	Caret = 94;
	Underscore = 95;
	Backquote = 96;
	A = 97;
	B = 98;
	C = 99;
	D = 100;
	E = 101;
	F = 102;
	G = 103;
	H = 104;
	I = 105;
	J = 106;
	K = 107;
	L = 108;
	M = 109;
	N = 110;
	O = 111;
	P = 112;
	Q = 113;
	R = 114;
	S = 115;
	T = 116;
	U = 117;
	V = 118;
	W = 119;
	X = 120;
	Y = 121;
	Z = 122;
	LeftCurly = 123;
	Pipe = 124;
	RightCurly = 125;
	Tilde = 126;
	Delete = 127;
	World0 = 160;
	World1 = 161;
	World2 = 162;
	World3 = 163;
	World4 = 164;
	World5 = 165;
	World6 = 166;
	World7 = 167;
	World8 = 168;
	World9 = 169;
	World10 = 170;
	World11 = 171;
	World12 = 172;
	World13 = 173;
	World14 = 174;
	World15 = 175;
	World16 = 176;
	World17 = 177;
	World18 = 178;
	World19 = 179;
	World20 = 180;
	World21 = 181;
	World22 = 182;
	World23 = 183;
	World24 = 184;
	World25 = 185;
	World26 = 186;
	World27 = 187;
	World28 = 188;
	World29 = 189;
	World30 = 190;
	World31 = 191;
	World32 = 192;
	World33 = 193;
	World34 = 194;
	World35 = 195;
	World36 = 196;
	World37 = 197;
	World38 = 198;
	World39 = 199;
	World40 = 200;
	World41 = 201;
	World42 = 202;
	World43 = 203;
	World44 = 204;
	World45 = 205;
	World46 = 206;
	World47 = 207;
	World48 = 208;
	World49 = 209;
	World50 = 210;
	World51 = 211;
	World52 = 212;
	World53 = 213;
	World54 = 214;
	World55 = 215;
	World56 = 216;
	World57 = 217;
	World58 = 218;
	World59 = 219;
	World60 = 220;
	World61 = 221;
	World62 = 222;
	World63 = 223;
	World64 = 224;
	World65 = 225;
	World66 = 226;
	World67 = 227;
	World68 = 228;
	World69 = 229;
	World70 = 230;
	World71 = 231;
	World72 = 232;
	World73 = 233;
	World74 = 234;
	World75 = 235;
	World76 = 236;
	World77 = 237;
	World78 = 238;
	World79 = 239;
	World80 = 240;
	World81 = 241;
	World82 = 242;
	World83 = 243;
	World84 = 244;
	World85 = 245;
	World86 = 246;
	World87 = 247;
	World88 = 248;
	World89 = 249;
	World90 = 250;
	World91 = 251;
	World92 = 252;
	World93 = 253;
	World94 = 254;
	World95 = 255;
	KeypadZero = 256;
	KeypadOne = 257;
	KeypadTwo = 258;
	KeypadThree = 259;
	KeypadFour = 260;
	KeypadFive = 261;
	KeypadSix = 262;
	KeypadSeven = 263;
	KeypadEight = 264;
	KeypadNine = 265;
	KeypadPeriod = 266;
	KeypadDivide = 267;
	KeypadMultiply = 268;
	KeypadMinus = 269;
	KeypadPlus = 270;
	KeypadEnter = 271;
	KeypadEquals = 272;
	Up = 273;
	Down = 274;
	Right = 275;
	Left = 276;
	Insert = 277;
	Home = 278;
	End = 279;
	PageUp = 280;
	PageDown = 281;
	F1 = 282;
	F2 = 283;
	F3 = 284;
	F4 = 285;
	F5 = 286;
	F6 = 287;
	F7 = 288;
	F8 = 289;
	F9 = 290;
	F10 = 291;
	F11 = 292;
	F12 = 293;
	F13 = 294;
	F14 = 295;
	F15 = 296;
	NumLock = 300;
	CapsLock = 301;
	ScrollLock = 302;
	RightShift = 303;
	LeftShift = 304;
	RightControl = 305;
	LeftControl = 306;
	RightAlt = 307;
	LeftAlt = 308;
	RightMeta = 309;
	LeftMeta = 310;
	LeftSuper = 311;
	RightSuper = 312;
	Mode = 313;
	Compose = 314;
	Help = 315;
	Print = 316;
	SysReq = 317;
	Break = 318;
	Menu = 319;
	Power = 320;
	Euro = 321;
	Undo = 322;
	ButtonX = 1000;
	ButtonY = 1001;
	ButtonA = 1002;
	ButtonB = 1003;
	ButtonR1 = 1004;
	ButtonL1 = 1005;
	ButtonR2 = 1006;
	ButtonL2 = 1007;
	ButtonR3 = 1008;
	ButtonL3 = 1009;
	ButtonStart = 1010;
	ButtonSelect = 1011;
	DPadLeft = 1012;
	DPadRight = 1013;
	DPadUp = 1014;
	DPadDown = 1015;
	Thumbstick1 = 1016;
	Thumbstick2 = 1017;
	MouseLeftButton = 1018;
	MouseRightButton = 1019;
	MouseMiddleButton = 1020;
	MouseBackButton = 1021;
	MouseNoButton = 1022;
	MouseX = 1023;
	MouseY = 1024;
}

export type KeyInterpolationMode =
	| EnumItem<number, KeyInterpolationMode, "Constant">
	| EnumItem<number, KeyInterpolationMode, "Linear">
	| EnumItem<number, KeyInterpolationMode, "Cubic">
export type KeyInterpolationModeRoot = EnumObject<{
	Constant: EnumItem<number, KeyInterpolationMode, "Constant">,
	Linear: EnumItem<number, KeyInterpolationMode, "Linear">,
	Cubic: EnumItem<number, KeyInterpolationMode, "Cubic">,
}, KeyInterpolationMode>
Enum.KeyInterpolationMode = {"Constant", "Linear", "Cubic"}

export type KeywordFilterType =
	| EnumItem<number, KeywordFilterType, "Include">
	| EnumItem<number, KeywordFilterType, "Exclude">
export type KeywordFilterTypeRoot = EnumObject<{
	Include: EnumItem<number, KeywordFilterType, "Include">,
	Exclude: EnumItem<number, KeywordFilterType, "Exclude">,
}, KeywordFilterType>
Enum.KeywordFilterType = {"Include", "Exclude"}

export type Language = | EnumItem<number, Language, "Default">
export type LanguageRoot = EnumObject<{
	Default: EnumItem<number, Language, "Default">,
}, Language>
Enum.Language = {"Default"}

export type LeftRight =
	| EnumItem<number, LeftRight, "Left">
	| EnumItem<number, LeftRight, "Center">
	| EnumItem<number, LeftRight, "Right">
export type LeftRightRoot = EnumObject<{
	Left: EnumItem<number, LeftRight, "Left">,
	Center: EnumItem<number, LeftRight, "Center">,
	Right: EnumItem<number, LeftRight, "Right">,
}, LeftRight>
Enum.LeftRight = {"Left", "Center", "Right"}

export type LexemeType =
	| EnumItem<number, LexemeType, "Eof">
	| EnumItem<number, LexemeType, "Name">
	| EnumItem<number, LexemeType, "QuotedString">
	| EnumItem<number, LexemeType, "Number">
	| EnumItem<number, LexemeType, "And">
	| EnumItem<number, LexemeType, "Or">
	| EnumItem<number, LexemeType, "Equal">
	| EnumItem<number, LexemeType, "TildeEqual">
	| EnumItem<number, LexemeType, "GreaterThan">
	| EnumItem<number, LexemeType, "GreaterThanEqual">
	| EnumItem<number, LexemeType, "LessThan">
	| EnumItem<number, LexemeType, "LessThanEqual">
	| EnumItem<number, LexemeType, "Colon">
	| EnumItem<number, LexemeType, "Dot">
	| EnumItem<number, LexemeType, "LeftParenthesis">
	| EnumItem<number, LexemeType, "RightParenthesis">
	| EnumItem<number, LexemeType, "Star">
	| EnumItem<number, LexemeType, "DoubleStar">
	| EnumItem<number, LexemeType, "ReservedSpecial">
export type LexemeTypeRoot = EnumObject<{
	Eof: EnumItem<number, LexemeType, "Eof">,
	Name: EnumItem<number, LexemeType, "Name">,
	QuotedString: EnumItem<number, LexemeType, "QuotedString">,
	Number: EnumItem<number, LexemeType, "Number">,
	And: EnumItem<number, LexemeType, "And">,
	Or: EnumItem<number, LexemeType, "Or">,
	Equal: EnumItem<number, LexemeType, "Equal">,
	TildeEqual: EnumItem<number, LexemeType, "TildeEqual">,
	GreaterThan: EnumItem<number, LexemeType, "GreaterThan">,
	GreaterThanEqual: EnumItem<number, LexemeType, "GreaterThanEqual">,
	LessThan: EnumItem<number, LexemeType, "LessThan">,
	LessThanEqual: EnumItem<number, LexemeType, "LessThanEqual">,
	Colon: EnumItem<number, LexemeType, "Colon">,
	Dot: EnumItem<number, LexemeType, "Dot">,
	LeftParenthesis: EnumItem<number, LexemeType, "LeftParenthesis">,
	RightParenthesis: EnumItem<number, LexemeType, "RightParenthesis">,
	Star: EnumItem<number, LexemeType, "Star">,
	DoubleStar: EnumItem<number, LexemeType, "DoubleStar">,
	ReservedSpecial: EnumItem<number, LexemeType, "ReservedSpecial">,
}, LexemeType>
Enum.LexemeType = {
	"Eof";
	"Name";
	"QuotedString";
	"Number";
	"And";
	"Or";
	"Equal";
	"TildeEqual";
	"GreaterThan";
	"GreaterThanEqual";
	"LessThan";
	"LessThanEqual";
	"Colon";
	"Dot";
	"LeftParenthesis";
	"RightParenthesis";
	"Star";
	"DoubleStar";
	"ReservedSpecial";
}

export type LightingStyle = | EnumItem<number, LightingStyle, "Realistic"> | EnumItem<number, LightingStyle, "Soft">
export type LightingStyleRoot = EnumObject<{
	Realistic: EnumItem<number, LightingStyle, "Realistic">,
	Soft: EnumItem<number, LightingStyle, "Soft">,
}, LightingStyle>
Enum.LightingStyle = {"Realistic", "Soft"}

export type Limb =
	| EnumItem<number, Limb, "Head">
	| EnumItem<number, Limb, "Torso">
	| EnumItem<number, Limb, "LeftArm">
	| EnumItem<number, Limb, "RightArm">
	| EnumItem<number, Limb, "LeftLeg">
	| EnumItem<number, Limb, "RightLeg">
	| EnumItem<number, Limb, "Unknown">
export type LimbRoot = EnumObject<{
	Head: EnumItem<number, Limb, "Head">,
	Torso: EnumItem<number, Limb, "Torso">,
	LeftArm: EnumItem<number, Limb, "LeftArm">,
	RightArm: EnumItem<number, Limb, "RightArm">,
	LeftLeg: EnumItem<number, Limb, "LeftLeg">,
	RightLeg: EnumItem<number, Limb, "RightLeg">,
	Unknown: EnumItem<number, Limb, "Unknown">,
}, Limb>
Enum.Limb = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Unknown"}

export type LineJoinMode =
	| EnumItem<number, LineJoinMode, "Round">
	| EnumItem<number, LineJoinMode, "Bevel">
	| EnumItem<number, LineJoinMode, "Miter">
export type LineJoinModeRoot = EnumObject<{
	Round: EnumItem<number, LineJoinMode, "Round">,
	Bevel: EnumItem<number, LineJoinMode, "Bevel">,
	Miter: EnumItem<number, LineJoinMode, "Miter">,
}, LineJoinMode>
Enum.LineJoinMode = {"Round", "Bevel", "Miter"}

export type ListDisplayMode =
	| EnumItem<number, ListDisplayMode, "Horizontal">
	| EnumItem<number, ListDisplayMode, "Vertical">
export type ListDisplayModeRoot = EnumObject<{
	Horizontal: EnumItem<number, ListDisplayMode, "Horizontal">,
	Vertical: EnumItem<number, ListDisplayMode, "Vertical">,
}, ListDisplayMode>
Enum.ListDisplayMode = {"Horizontal", "Vertical"}

export type ListenerLocation =
	| EnumItem<number, ListenerLocation, "Default">
	| EnumItem<number, ListenerLocation, "None">
	| EnumItem<number, ListenerLocation, "Character">
	| EnumItem<number, ListenerLocation, "Camera">
export type ListenerLocationRoot = EnumObject<{
	Default: EnumItem<number, ListenerLocation, "Default">,
	None: EnumItem<number, ListenerLocation, "None">,
	Character: EnumItem<number, ListenerLocation, "Character">,
	Camera: EnumItem<number, ListenerLocation, "Camera">,
}, ListenerLocation>
Enum.ListenerLocation = {"Default", "None", "Character", "Camera"}

export type ListenerType =
	| EnumItem<number, ListenerType, "Camera">
	| EnumItem<number, ListenerType, "CFrame">
	| EnumItem<number, ListenerType, "ObjectPosition">
	| EnumItem<number, ListenerType, "ObjectCFrame">
export type ListenerTypeRoot = EnumObject<{
	Camera: EnumItem<number, ListenerType, "Camera">,
	CFrame: EnumItem<number, ListenerType, "CFrame">,
	ObjectPosition: EnumItem<number, ListenerType, "ObjectPosition">,
	ObjectCFrame: EnumItem<number, ListenerType, "ObjectCFrame">,
}, ListenerType>
Enum.ListenerType = {"Camera", "CFrame", "ObjectPosition", "ObjectCFrame"}

export type LiveEditingAtomicUpdateResponse =
	| EnumItem<number, LiveEditingAtomicUpdateResponse, "Success">
	| EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureGuidNotFound">
	| EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureHashMismatch">
	| EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureOperationIllegal">
export type LiveEditingAtomicUpdateResponseRoot = EnumObject<{
	Success: EnumItem<number, LiveEditingAtomicUpdateResponse, "Success">,
	FailureGuidNotFound: EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureGuidNotFound">,
	FailureHashMismatch: EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureHashMismatch">,
	FailureOperationIllegal: EnumItem<number, LiveEditingAtomicUpdateResponse, "FailureOperationIllegal">,
}, LiveEditingAtomicUpdateResponse>
Enum.LiveEditingAtomicUpdateResponse =
	{"Success", "FailureGuidNotFound", "FailureHashMismatch", "FailureOperationIllegal"}

export type LiveEditingBroadcastMessageType =
	| EnumItem<number, LiveEditingBroadcastMessageType, "Normal">
	| EnumItem<number, LiveEditingBroadcastMessageType, "Warning">
	| EnumItem<number, LiveEditingBroadcastMessageType, "Error">
export type LiveEditingBroadcastMessageTypeRoot = EnumObject<{
	Normal: EnumItem<number, LiveEditingBroadcastMessageType, "Normal">,
	Warning: EnumItem<number, LiveEditingBroadcastMessageType, "Warning">,
	Error: EnumItem<number, LiveEditingBroadcastMessageType, "Error">,
}, LiveEditingBroadcastMessageType>
Enum.LiveEditingBroadcastMessageType = {"Normal", "Warning", "Error"}

export type LoadCharacterLayeredClothing =
	| EnumItem<number, LoadCharacterLayeredClothing, "Default">
	| EnumItem<number, LoadCharacterLayeredClothing, "Disabled">
	| EnumItem<number, LoadCharacterLayeredClothing, "Enabled">
export type LoadCharacterLayeredClothingRoot = EnumObject<{
	Default: EnumItem<number, LoadCharacterLayeredClothing, "Default">,
	Disabled: EnumItem<number, LoadCharacterLayeredClothing, "Disabled">,
	Enabled: EnumItem<number, LoadCharacterLayeredClothing, "Enabled">,
}, LoadCharacterLayeredClothing>
Enum.LoadCharacterLayeredClothing = {"Default", "Disabled", "Enabled"}

export type LoadDynamicHeads =
	| EnumItem<number, LoadDynamicHeads, "Default">
	| EnumItem<number, LoadDynamicHeads, "Disabled">
	| EnumItem<number, LoadDynamicHeads, "Enabled">
export type LoadDynamicHeadsRoot = EnumObject<{
	Default: EnumItem<number, LoadDynamicHeads, "Default">,
	Disabled: EnumItem<number, LoadDynamicHeads, "Disabled">,
	Enabled: EnumItem<number, LoadDynamicHeads, "Enabled">,
}, LoadDynamicHeads>
Enum.LoadDynamicHeads = {"Default", "Disabled", "Enabled"}

export type LocationType =
	| EnumItem<number, LocationType, "Character">
	| EnumItem<number, LocationType, "Camera">
	| EnumItem<number, LocationType, "ObjectPosition">
export type LocationTypeRoot = EnumObject<{
	Character: EnumItem<number, LocationType, "Character">,
	Camera: EnumItem<number, LocationType, "Camera">,
	ObjectPosition: EnumItem<number, LocationType, "ObjectPosition">,
}, LocationType>
Enum.LocationType = {"Character", "Camera", "ObjectPosition"}

export type MarketplaceBulkPurchasePromptStatus =
	| EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Completed">
	| EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Aborted">
	| EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Error">
export type MarketplaceBulkPurchasePromptStatusRoot = EnumObject<{
	Completed: EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Completed">,
	Aborted: EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Aborted">,
	Error: EnumItem<number, MarketplaceBulkPurchasePromptStatus, "Error">,
}, MarketplaceBulkPurchasePromptStatus>
Enum.MarketplaceBulkPurchasePromptStatus = {
	Completed = 1;
	Aborted = 2;
	Error = 3;
}

export type MarketplaceItemPurchaseStatus =
	| EnumItem<number, MarketplaceItemPurchaseStatus, "Success">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "SystemError">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "AlreadyOwned">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "InsufficientRobux">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "QuantityLimitExceeded">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "QuotaExceeded">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "NotForSale">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "NotAvailableForPurchaser">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "PriceMismatch">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "SoldOut">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "PurchaserIsSeller">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "InsufficientMembership">
	| EnumItem<number, MarketplaceItemPurchaseStatus, "PlaceInvalid">
export type MarketplaceItemPurchaseStatusRoot = EnumObject<{
	Success: EnumItem<number, MarketplaceItemPurchaseStatus, "Success">,
	SystemError: EnumItem<number, MarketplaceItemPurchaseStatus, "SystemError">,
	AlreadyOwned: EnumItem<number, MarketplaceItemPurchaseStatus, "AlreadyOwned">,
	InsufficientRobux: EnumItem<number, MarketplaceItemPurchaseStatus, "InsufficientRobux">,
	QuantityLimitExceeded: EnumItem<number, MarketplaceItemPurchaseStatus, "QuantityLimitExceeded">,
	QuotaExceeded: EnumItem<number, MarketplaceItemPurchaseStatus, "QuotaExceeded">,
	NotForSale: EnumItem<number, MarketplaceItemPurchaseStatus, "NotForSale">,
	NotAvailableForPurchaser: EnumItem<number, MarketplaceItemPurchaseStatus, "NotAvailableForPurchaser">,
	PriceMismatch: EnumItem<number, MarketplaceItemPurchaseStatus, "PriceMismatch">,
	SoldOut: EnumItem<number, MarketplaceItemPurchaseStatus, "SoldOut">,
	PurchaserIsSeller: EnumItem<number, MarketplaceItemPurchaseStatus, "PurchaserIsSeller">,
	InsufficientMembership: EnumItem<number, MarketplaceItemPurchaseStatus, "InsufficientMembership">,
	PlaceInvalid: EnumItem<number, MarketplaceItemPurchaseStatus, "PlaceInvalid">,
}, MarketplaceItemPurchaseStatus>
Enum.MarketplaceItemPurchaseStatus = {
	Success = 1;
	SystemError = 2;
	AlreadyOwned = 3;
	InsufficientRobux = 4;
	QuantityLimitExceeded = 5;
	QuotaExceeded = 6;
	NotForSale = 7;
	NotAvailableForPurchaser = 8;
	PriceMismatch = 9;
	SoldOut = 10;
	PurchaserIsSeller = 11;
	InsufficientMembership = 12;
	PlaceInvalid = 13;
}

export type MarketplaceProductType =
	| EnumItem<number, MarketplaceProductType, "AvatarAsset">
	| EnumItem<number, MarketplaceProductType, "AvatarBundle">
export type MarketplaceProductTypeRoot = EnumObject<{
	AvatarAsset: EnumItem<number, MarketplaceProductType, "AvatarAsset">,
	AvatarBundle: EnumItem<number, MarketplaceProductType, "AvatarBundle">,
}, MarketplaceProductType>
Enum.MarketplaceProductType = {
	AvatarAsset = 1;
	AvatarBundle = 2;
}

export type MarkupKind = | EnumItem<number, MarkupKind, "PlainText"> | EnumItem<number, MarkupKind, "Markdown">
export type MarkupKindRoot = EnumObject<{
	PlainText: EnumItem<number, MarkupKind, "PlainText">,
	Markdown: EnumItem<number, MarkupKind, "Markdown">,
}, MarkupKind>
Enum.MarkupKind = {"PlainText", "Markdown"}

export type MatchmakingType =
	| EnumItem<number, MatchmakingType, "Default">
	| EnumItem<number, MatchmakingType, "XboxOnly">
	| EnumItem<number, MatchmakingType, "PlayStationOnly">
export type MatchmakingTypeRoot = EnumObject<{
	Default: EnumItem<number, MatchmakingType, "Default">,
	XboxOnly: EnumItem<number, MatchmakingType, "XboxOnly">,
	PlayStationOnly: EnumItem<number, MatchmakingType, "PlayStationOnly">,
}, MatchmakingType>
Enum.MatchmakingType = {
	Default = 1;
	XboxOnly = 2;
	PlayStationOnly = 3;
}

export type Material =
	| EnumItem<number, Material, "Plastic">
	| EnumItem<number, Material, "SmoothPlastic">
	| EnumItem<number, Material, "Neon">
	| EnumItem<number, Material, "Wood">
	| EnumItem<number, Material, "WoodPlanks">
	| EnumItem<number, Material, "Marble">
	| EnumItem<number, Material, "Basalt">
	| EnumItem<number, Material, "Slate">
	| EnumItem<number, Material, "CrackedLava">
	| EnumItem<number, Material, "Concrete">
	| EnumItem<number, Material, "Limestone">
	| EnumItem<number, Material, "Granite">
	| EnumItem<number, Material, "Pavement">
	| EnumItem<number, Material, "Brick">
	| EnumItem<number, Material, "Pebble">
	| EnumItem<number, Material, "Cobblestone">
	| EnumItem<number, Material, "Rock">
	| EnumItem<number, Material, "Sandstone">
	| EnumItem<number, Material, "CorrodedMetal">
	| EnumItem<number, Material, "DiamondPlate">
	| EnumItem<number, Material, "Foil">
	| EnumItem<number, Material, "Metal">
	| EnumItem<number, Material, "Grass">
	| EnumItem<number, Material, "LeafyGrass">
	| EnumItem<number, Material, "Sand">
	| EnumItem<number, Material, "Fabric">
	| EnumItem<number, Material, "Snow">
	| EnumItem<number, Material, "Mud">
	| EnumItem<number, Material, "Ground">
	| EnumItem<number, Material, "Asphalt">
	| EnumItem<number, Material, "Salt">
	| EnumItem<number, Material, "Ice">
	| EnumItem<number, Material, "Glacier">
	| EnumItem<number, Material, "Glass">
	| EnumItem<number, Material, "ForceField">
	| EnumItem<number, Material, "Air">
	| EnumItem<number, Material, "Water">
	| EnumItem<number, Material, "Cardboard">
	| EnumItem<number, Material, "Carpet">
	| EnumItem<number, Material, "CeramicTiles">
	| EnumItem<number, Material, "ClayRoofTiles">
	| EnumItem<number, Material, "RoofShingles">
	| EnumItem<number, Material, "Leather">
	| EnumItem<number, Material, "Plaster">
	| EnumItem<number, Material, "Rubber">
export type MaterialRoot = EnumObject<{
	Plastic: EnumItem<number, Material, "Plastic">,
	SmoothPlastic: EnumItem<number, Material, "SmoothPlastic">,
	Neon: EnumItem<number, Material, "Neon">,
	Wood: EnumItem<number, Material, "Wood">,
	WoodPlanks: EnumItem<number, Material, "WoodPlanks">,
	Marble: EnumItem<number, Material, "Marble">,
	Basalt: EnumItem<number, Material, "Basalt">,
	Slate: EnumItem<number, Material, "Slate">,
	CrackedLava: EnumItem<number, Material, "CrackedLava">,
	Concrete: EnumItem<number, Material, "Concrete">,
	Limestone: EnumItem<number, Material, "Limestone">,
	Granite: EnumItem<number, Material, "Granite">,
	Pavement: EnumItem<number, Material, "Pavement">,
	Brick: EnumItem<number, Material, "Brick">,
	Pebble: EnumItem<number, Material, "Pebble">,
	Cobblestone: EnumItem<number, Material, "Cobblestone">,
	Rock: EnumItem<number, Material, "Rock">,
	Sandstone: EnumItem<number, Material, "Sandstone">,
	CorrodedMetal: EnumItem<number, Material, "CorrodedMetal">,
	DiamondPlate: EnumItem<number, Material, "DiamondPlate">,
	Foil: EnumItem<number, Material, "Foil">,
	Metal: EnumItem<number, Material, "Metal">,
	Grass: EnumItem<number, Material, "Grass">,
	LeafyGrass: EnumItem<number, Material, "LeafyGrass">,
	Sand: EnumItem<number, Material, "Sand">,
	Fabric: EnumItem<number, Material, "Fabric">,
	Snow: EnumItem<number, Material, "Snow">,
	Mud: EnumItem<number, Material, "Mud">,
	Ground: EnumItem<number, Material, "Ground">,
	Asphalt: EnumItem<number, Material, "Asphalt">,
	Salt: EnumItem<number, Material, "Salt">,
	Ice: EnumItem<number, Material, "Ice">,
	Glacier: EnumItem<number, Material, "Glacier">,
	Glass: EnumItem<number, Material, "Glass">,
	ForceField: EnumItem<number, Material, "ForceField">,
	Air: EnumItem<number, Material, "Air">,
	Water: EnumItem<number, Material, "Water">,
	Cardboard: EnumItem<number, Material, "Cardboard">,
	Carpet: EnumItem<number, Material, "Carpet">,
	CeramicTiles: EnumItem<number, Material, "CeramicTiles">,
	ClayRoofTiles: EnumItem<number, Material, "ClayRoofTiles">,
	RoofShingles: EnumItem<number, Material, "RoofShingles">,
	Leather: EnumItem<number, Material, "Leather">,
	Plaster: EnumItem<number, Material, "Plaster">,
	Rubber: EnumItem<number, Material, "Rubber">,
}, Material>
Enum.Material = {
	Plastic = 256;
	SmoothPlastic = 272;
	Neon = 288;
	Wood = 512;
	WoodPlanks = 528;
	Marble = 784;
	Basalt = 788;
	Slate = 800;
	CrackedLava = 804;
	Concrete = 816;
	Limestone = 820;
	Granite = 832;
	Pavement = 836;
	Brick = 848;
	Pebble = 864;
	Cobblestone = 880;
	Rock = 896;
	Sandstone = 912;
	CorrodedMetal = 1040;
	DiamondPlate = 1056;
	Foil = 1072;
	Metal = 1088;
	Grass = 1280;
	LeafyGrass = 1284;
	Sand = 1296;
	Fabric = 1312;
	Snow = 1328;
	Mud = 1344;
	Ground = 1360;
	Asphalt = 1376;
	Salt = 1392;
	Ice = 1536;
	Glacier = 1552;
	Glass = 1568;
	ForceField = 1584;
	Air = 1792;
	Water = 2048;
	Cardboard = 2304;
	Carpet = 2305;
	CeramicTiles = 2306;
	ClayRoofTiles = 2307;
	RoofShingles = 2308;
	Leather = 2309;
	Plaster = 2310;
	Rubber = 2311;
}

export type MaterialPattern = | EnumItem<number, MaterialPattern, "Regular"> | EnumItem<number, MaterialPattern, "Organic">
export type MaterialPatternRoot = EnumObject<{
	Regular: EnumItem<number, MaterialPattern, "Regular">,
	Organic: EnumItem<number, MaterialPattern, "Organic">,
}, MaterialPattern>
Enum.MaterialPattern = {"Regular", "Organic"}

export type MembershipType =
	| EnumItem<number, MembershipType, "None">
	| EnumItem<number, MembershipType, "BuildersClub">
	| EnumItem<number, MembershipType, "TurboBuildersClub">
	| EnumItem<number, MembershipType, "OutrageousBuildersClub">
	| EnumItem<number, MembershipType, "Premium">
export type MembershipTypeRoot = EnumObject<{
	None: EnumItem<number, MembershipType, "None">,
	BuildersClub: EnumItem<number, MembershipType, "BuildersClub">,
	TurboBuildersClub: EnumItem<number, MembershipType, "TurboBuildersClub">,
	OutrageousBuildersClub: EnumItem<number, MembershipType, "OutrageousBuildersClub">,
	Premium: EnumItem<number, MembershipType, "Premium">,
}, MembershipType>
Enum.MembershipType = {"None", "BuildersClub", "TurboBuildersClub", "OutrageousBuildersClub", "Premium"}

export type MeshPartDetailLevel =
	| EnumItem<number, MeshPartDetailLevel, "DistanceBased">
	| EnumItem<number, MeshPartDetailLevel, "Level00">
	| EnumItem<number, MeshPartDetailLevel, "Level01">
	| EnumItem<number, MeshPartDetailLevel, "Level02">
	| EnumItem<number, MeshPartDetailLevel, "Level03">
	| EnumItem<number, MeshPartDetailLevel, "Level04">
export type MeshPartDetailLevelRoot = EnumObject<{
	DistanceBased: EnumItem<number, MeshPartDetailLevel, "DistanceBased">,
	Level00: EnumItem<number, MeshPartDetailLevel, "Level00">,
	Level01: EnumItem<number, MeshPartDetailLevel, "Level01">,
	Level02: EnumItem<number, MeshPartDetailLevel, "Level02">,
	Level03: EnumItem<number, MeshPartDetailLevel, "Level03">,
	Level04: EnumItem<number, MeshPartDetailLevel, "Level04">,
}, MeshPartDetailLevel>
Enum.MeshPartDetailLevel = {"DistanceBased", "Level00", "Level01", "Level02", "Level03", "Level04"}

export type MeshPartHeadsAndAccessories =
	| EnumItem<number, MeshPartHeadsAndAccessories, "Default">
	| EnumItem<number, MeshPartHeadsAndAccessories, "Disabled">
	| EnumItem<number, MeshPartHeadsAndAccessories, "Enabled">
export type MeshPartHeadsAndAccessoriesRoot = EnumObject<{
	Default: EnumItem<number, MeshPartHeadsAndAccessories, "Default">,
	Disabled: EnumItem<number, MeshPartHeadsAndAccessories, "Disabled">,
	Enabled: EnumItem<number, MeshPartHeadsAndAccessories, "Enabled">,
}, MeshPartHeadsAndAccessories>
Enum.MeshPartHeadsAndAccessories = {"Default", "Disabled", "Enabled"}

export type MeshScaleUnit =
	| EnumItem<number, MeshScaleUnit, "Stud">
	| EnumItem<number, MeshScaleUnit, "Meter">
	| EnumItem<number, MeshScaleUnit, "CM">
	| EnumItem<number, MeshScaleUnit, "MM">
	| EnumItem<number, MeshScaleUnit, "Foot">
	| EnumItem<number, MeshScaleUnit, "Inch">
export type MeshScaleUnitRoot = EnumObject<{
	Stud: EnumItem<number, MeshScaleUnit, "Stud">,
	Meter: EnumItem<number, MeshScaleUnit, "Meter">,
	CM: EnumItem<number, MeshScaleUnit, "CM">,
	MM: EnumItem<number, MeshScaleUnit, "MM">,
	Foot: EnumItem<number, MeshScaleUnit, "Foot">,
	Inch: EnumItem<number, MeshScaleUnit, "Inch">,
}, MeshScaleUnit>
Enum.MeshScaleUnit = {"Stud", "Meter", "CM", "MM", "Foot", "Inch"}

export type MeshType =
	| EnumItem<number, MeshType, "Head">
	| EnumItem<number, MeshType, "Torso">
	| EnumItem<number, MeshType, "Wedge">
	| EnumItem<number, MeshType, "Sphere">
	| EnumItem<number, MeshType, "Cylinder">
	| EnumItem<number, MeshType, "FileMesh">
	| EnumItem<number, MeshType, "Brick">
	| EnumItem<number, MeshType, "Prism">
	| EnumItem<number, MeshType, "Pyramid">
	| EnumItem<number, MeshType, "ParallelRamp">
	| EnumItem<number, MeshType, "RightAngleRamp">
	| EnumItem<number, MeshType, "CornerWedge">
export type MeshTypeRoot = EnumObject<{
	Head: EnumItem<number, MeshType, "Head">,
	Torso: EnumItem<number, MeshType, "Torso">,
	Wedge: EnumItem<number, MeshType, "Wedge">,
	Sphere: EnumItem<number, MeshType, "Sphere">,
	Cylinder: EnumItem<number, MeshType, "Cylinder">,
	FileMesh: EnumItem<number, MeshType, "FileMesh">,
	Brick: EnumItem<number, MeshType, "Brick">,
	Prism: EnumItem<number, MeshType, "Prism">,
	Pyramid: EnumItem<number, MeshType, "Pyramid">,
	ParallelRamp: EnumItem<number, MeshType, "ParallelRamp">,
	RightAngleRamp: EnumItem<number, MeshType, "RightAngleRamp">,
	CornerWedge: EnumItem<number, MeshType, "CornerWedge">,
}, MeshType>
Enum.MeshType = {
	"Head";
	"Torso";
	"Wedge";
	"Sphere";
	"Cylinder";
	"FileMesh";
	"Brick";
	"Prism";
	"Pyramid";
	"ParallelRamp";
	"RightAngleRamp";
	"CornerWedge";
}

export type MessageType =
	| EnumItem<number, MessageType, "MessageOutput">
	| EnumItem<number, MessageType, "MessageInfo">
	| EnumItem<number, MessageType, "MessageWarning">
	| EnumItem<number, MessageType, "MessageError">
export type MessageTypeRoot = EnumObject<{
	MessageOutput: EnumItem<number, MessageType, "MessageOutput">,
	MessageInfo: EnumItem<number, MessageType, "MessageInfo">,
	MessageWarning: EnumItem<number, MessageType, "MessageWarning">,
	MessageError: EnumItem<number, MessageType, "MessageError">,
}, MessageType>
Enum.MessageType = {"MessageOutput", "MessageInfo", "MessageWarning", "MessageError"}

export type ModelLevelOfDetail =
	| EnumItem<number, ModelLevelOfDetail, "Automatic">
	| EnumItem<number, ModelLevelOfDetail, "StreamingMesh">
	| EnumItem<number, ModelLevelOfDetail, "Disabled">
export type ModelLevelOfDetailRoot = EnumObject<{
	Automatic: EnumItem<number, ModelLevelOfDetail, "Automatic">,
	StreamingMesh: EnumItem<number, ModelLevelOfDetail, "StreamingMesh">,
	Disabled: EnumItem<number, ModelLevelOfDetail, "Disabled">,
}, ModelLevelOfDetail>
Enum.ModelLevelOfDetail = {"Automatic", "StreamingMesh", "Disabled"}

export type ModelStreamingBehavior =
	| EnumItem<number, ModelStreamingBehavior, "Default">
	| EnumItem<number, ModelStreamingBehavior, "Legacy">
	| EnumItem<number, ModelStreamingBehavior, "Improved">
export type ModelStreamingBehaviorRoot = EnumObject<{
	Default: EnumItem<number, ModelStreamingBehavior, "Default">,
	Legacy: EnumItem<number, ModelStreamingBehavior, "Legacy">,
	Improved: EnumItem<number, ModelStreamingBehavior, "Improved">,
}, ModelStreamingBehavior>
Enum.ModelStreamingBehavior = {"Default", "Legacy", "Improved"}

export type ModelStreamingMode =
	| EnumItem<number, ModelStreamingMode, "Default">
	| EnumItem<number, ModelStreamingMode, "Atomic">
	| EnumItem<number, ModelStreamingMode, "Persistent">
	| EnumItem<number, ModelStreamingMode, "PersistentPerPlayer">
	| EnumItem<number, ModelStreamingMode, "Nonatomic">
export type ModelStreamingModeRoot = EnumObject<{
	Default: EnumItem<number, ModelStreamingMode, "Default">,
	Atomic: EnumItem<number, ModelStreamingMode, "Atomic">,
	Persistent: EnumItem<number, ModelStreamingMode, "Persistent">,
	PersistentPerPlayer: EnumItem<number, ModelStreamingMode, "PersistentPerPlayer">,
	Nonatomic: EnumItem<number, ModelStreamingMode, "Nonatomic">,
}, ModelStreamingMode>
Enum.ModelStreamingMode = {"Default", "Atomic", "Persistent", "PersistentPerPlayer", "Nonatomic"}

export type ModerationStatus =
	| EnumItem<number, ModerationStatus, "ReviewedApproved">
	| EnumItem<number, ModerationStatus, "ReviewedRejected">
	| EnumItem<number, ModerationStatus, "NotReviewed">
	| EnumItem<number, ModerationStatus, "NotApplicable">
	| EnumItem<number, ModerationStatus, "Invalid">
export type ModerationStatusRoot = EnumObject<{
	ReviewedApproved: EnumItem<number, ModerationStatus, "ReviewedApproved">,
	ReviewedRejected: EnumItem<number, ModerationStatus, "ReviewedRejected">,
	NotReviewed: EnumItem<number, ModerationStatus, "NotReviewed">,
	NotApplicable: EnumItem<number, ModerationStatus, "NotApplicable">,
	Invalid: EnumItem<number, ModerationStatus, "Invalid">,
}, ModerationStatus>
Enum.ModerationStatus = {
	ReviewedApproved = 1;
	ReviewedRejected = 2;
	NotReviewed = 3;
	NotApplicable = 4;
	Invalid = 5;
}

export type ModifierKey =
	| EnumItem<number, ModifierKey, "Shift">
	| EnumItem<number, ModifierKey, "Ctrl">
	| EnumItem<number, ModifierKey, "Alt">
	| EnumItem<number, ModifierKey, "Meta">
export type ModifierKeyRoot = EnumObject<{
	Shift: EnumItem<number, ModifierKey, "Shift">,
	Ctrl: EnumItem<number, ModifierKey, "Ctrl">,
	Alt: EnumItem<number, ModifierKey, "Alt">,
	Meta: EnumItem<number, ModifierKey, "Meta">,
}, ModifierKey>
Enum.ModifierKey = {"Shift", "Ctrl", "Alt", "Meta"}

export type MouseBehavior =
	| EnumItem<number, MouseBehavior, "Default">
	| EnumItem<number, MouseBehavior, "LockCenter">
	| EnumItem<number, MouseBehavior, "LockCurrentPosition">
export type MouseBehaviorRoot = EnumObject<{
	Default: EnumItem<number, MouseBehavior, "Default">,
	LockCenter: EnumItem<number, MouseBehavior, "LockCenter">,
	LockCurrentPosition: EnumItem<number, MouseBehavior, "LockCurrentPosition">,
}, MouseBehavior>
Enum.MouseBehavior = {"Default", "LockCenter", "LockCurrentPosition"}

export type MoveState =
	| EnumItem<number, MoveState, "Stopped">
	| EnumItem<number, MoveState, "Coasting">
	| EnumItem<number, MoveState, "Pushing">
	| EnumItem<number, MoveState, "Stopping">
	| EnumItem<number, MoveState, "AirFree">
export type MoveStateRoot = EnumObject<{
	Stopped: EnumItem<number, MoveState, "Stopped">,
	Coasting: EnumItem<number, MoveState, "Coasting">,
	Pushing: EnumItem<number, MoveState, "Pushing">,
	Stopping: EnumItem<number, MoveState, "Stopping">,
	AirFree: EnumItem<number, MoveState, "AirFree">,
}, MoveState>
Enum.MoveState = {"Stopped", "Coasting", "Pushing", "Stopping", "AirFree"}

export type MoverConstraintRootBehaviorMode =
	| EnumItem<number, MoverConstraintRootBehaviorMode, "Default">
	| EnumItem<number, MoverConstraintRootBehaviorMode, "Disabled">
	| EnumItem<number, MoverConstraintRootBehaviorMode, "Enabled">
export type MoverConstraintRootBehaviorModeRoot = EnumObject<{
	Default: EnumItem<number, MoverConstraintRootBehaviorMode, "Default">,
	Disabled: EnumItem<number, MoverConstraintRootBehaviorMode, "Disabled">,
	Enabled: EnumItem<number, MoverConstraintRootBehaviorMode, "Enabled">,
}, MoverConstraintRootBehaviorMode>
Enum.MoverConstraintRootBehaviorMode = {"Default", "Disabled", "Enabled"}

export type MuteState = | EnumItem<number, MuteState, "Unmuted"> | EnumItem<number, MuteState, "Muted">
export type MuteStateRoot = EnumObject<{
	Unmuted: EnumItem<number, MuteState, "Unmuted">,
	Muted: EnumItem<number, MuteState, "Muted">,
}, MuteState>
Enum.MuteState = {"Unmuted", "Muted"}

export type NameOcclusion =
	| EnumItem<number, NameOcclusion, "NoOcclusion">
	| EnumItem<number, NameOcclusion, "EnemyOcclusion">
	| EnumItem<number, NameOcclusion, "OccludeAll">
export type NameOcclusionRoot = EnumObject<{
	NoOcclusion: EnumItem<number, NameOcclusion, "NoOcclusion">,
	EnemyOcclusion: EnumItem<number, NameOcclusion, "EnemyOcclusion">,
	OccludeAll: EnumItem<number, NameOcclusion, "OccludeAll">,
}, NameOcclusion>
Enum.NameOcclusion = {"NoOcclusion", "EnemyOcclusion", "OccludeAll"}

export type NetworkOwnership =
	| EnumItem<number, NetworkOwnership, "Automatic">
	| EnumItem<number, NetworkOwnership, "Manual">
	| EnumItem<number, NetworkOwnership, "OnContact">
export type NetworkOwnershipRoot = EnumObject<{
	Automatic: EnumItem<number, NetworkOwnership, "Automatic">,
	Manual: EnumItem<number, NetworkOwnership, "Manual">,
	OnContact: EnumItem<number, NetworkOwnership, "OnContact">,
}, NetworkOwnership>
Enum.NetworkOwnership = {"Automatic", "Manual", "OnContact"}

export type NetworkStatus =
	| EnumItem<number, NetworkStatus, "Unknown">
	| EnumItem<number, NetworkStatus, "Connected">
	| EnumItem<number, NetworkStatus, "Disconnected">
export type NetworkStatusRoot = EnumObject<{
	Unknown: EnumItem<number, NetworkStatus, "Unknown">,
	Connected: EnumItem<number, NetworkStatus, "Connected">,
	Disconnected: EnumItem<number, NetworkStatus, "Disconnected">,
}, NetworkStatus>
Enum.NetworkStatus = {"Unknown", "Connected", "Disconnected"}

export type NoiseType = | EnumItem<number, NoiseType, "SimplexGabor">
export type NoiseTypeRoot = EnumObject<{
	SimplexGabor: EnumItem<number, NoiseType, "SimplexGabor">,
}, NoiseType>
Enum.NoiseType = {"SimplexGabor"}

export type NormalId =
	| EnumItem<number, NormalId, "Right">
	| EnumItem<number, NormalId, "Top">
	| EnumItem<number, NormalId, "Back">
	| EnumItem<number, NormalId, "Left">
	| EnumItem<number, NormalId, "Bottom">
	| EnumItem<number, NormalId, "Front">
export type NormalIdRoot = EnumObject<{
	Right: EnumItem<number, NormalId, "Right">,
	Top: EnumItem<number, NormalId, "Top">,
	Back: EnumItem<number, NormalId, "Back">,
	Left: EnumItem<number, NormalId, "Left">,
	Bottom: EnumItem<number, NormalId, "Bottom">,
	Front: EnumItem<number, NormalId, "Front">,
}, NormalId>
Enum.NormalId = {"Right", "Top", "Back", "Left", "Bottom", "Front"}

export type NotificationButtonType =
	| EnumItem<number, NotificationButtonType, "Primary">
	| EnumItem<number, NotificationButtonType, "Secondary">
export type NotificationButtonTypeRoot = EnumObject<{
	Primary: EnumItem<number, NotificationButtonType, "Primary">,
	Secondary: EnumItem<number, NotificationButtonType, "Secondary">,
}, NotificationButtonType>
Enum.NotificationButtonType = {"Primary", "Secondary"}

export type OperationType =
	| EnumItem<number, OperationType, "Null">
	| EnumItem<number, OperationType, "Union">
	| EnumItem<number, OperationType, "Subtraction">
	| EnumItem<number, OperationType, "Intersection">
	| EnumItem<number, OperationType, "Primitive">
export type OperationTypeRoot = EnumObject<{
	Null: EnumItem<number, OperationType, "Null">,
	Union: EnumItem<number, OperationType, "Union">,
	Subtraction: EnumItem<number, OperationType, "Subtraction">,
	Intersection: EnumItem<number, OperationType, "Intersection">,
	Primitive: EnumItem<number, OperationType, "Primitive">,
}, OperationType>
Enum.OperationType = {"Null", "Union", "Subtraction", "Intersection", "Primitive"}

export type OrientationAlignmentMode =
	| EnumItem<number, OrientationAlignmentMode, "OneAttachment">
	| EnumItem<number, OrientationAlignmentMode, "TwoAttachment">
export type OrientationAlignmentModeRoot = EnumObject<{
	OneAttachment: EnumItem<number, OrientationAlignmentMode, "OneAttachment">,
	TwoAttachment: EnumItem<number, OrientationAlignmentMode, "TwoAttachment">,
}, OrientationAlignmentMode>
Enum.OrientationAlignmentMode = {"OneAttachment", "TwoAttachment"}

export type OutfitSource =
	| EnumItem<number, OutfitSource, "All">
	| EnumItem<number, OutfitSource, "Created">
	| EnumItem<number, OutfitSource, "Purchased">
export type OutfitSourceRoot = EnumObject<{
	All: EnumItem<number, OutfitSource, "All">,
	Created: EnumItem<number, OutfitSource, "Created">,
	Purchased: EnumItem<number, OutfitSource, "Purchased">,
}, OutfitSource>
Enum.OutfitSource = {
	All = 1;
	Created = 2;
	Purchased = 3;
}

export type OutfitType =
	| EnumItem<number, OutfitType, "All">
	| EnumItem<number, OutfitType, "Avatar">
	| EnumItem<number, OutfitType, "DynamicHead">
export type OutfitTypeRoot = EnumObject<{
	All: EnumItem<number, OutfitType, "All">,
	Avatar: EnumItem<number, OutfitType, "Avatar">,
	DynamicHead: EnumItem<number, OutfitType, "DynamicHead">,
}, OutfitType>
Enum.OutfitType = {
	All = 1;
	Avatar = 2;
	DynamicHead = 3;
}

export type OutputLayoutMode =
	| EnumItem<number, OutputLayoutMode, "Horizontal">
	| EnumItem<number, OutputLayoutMode, "Vertical">
export type OutputLayoutModeRoot = EnumObject<{
	Horizontal: EnumItem<number, OutputLayoutMode, "Horizontal">,
	Vertical: EnumItem<number, OutputLayoutMode, "Vertical">,
}, OutputLayoutMode>
Enum.OutputLayoutMode = {"Horizontal", "Vertical"}

export type OverrideMouseIconBehavior =
	| EnumItem<number, OverrideMouseIconBehavior, "None">
	| EnumItem<number, OverrideMouseIconBehavior, "ForceShow">
	| EnumItem<number, OverrideMouseIconBehavior, "ForceHide">
export type OverrideMouseIconBehaviorRoot = EnumObject<{
	None: EnumItem<number, OverrideMouseIconBehavior, "None">,
	ForceShow: EnumItem<number, OverrideMouseIconBehavior, "ForceShow">,
	ForceHide: EnumItem<number, OverrideMouseIconBehavior, "ForceHide">,
}, OverrideMouseIconBehavior>
Enum.OverrideMouseIconBehavior = {"None", "ForceShow", "ForceHide"}

export type PackagePermission =
	| EnumItem<number, PackagePermission, "None">
	| EnumItem<number, PackagePermission, "NoAccess">
	| EnumItem<number, PackagePermission, "Revoked">
	| EnumItem<number, PackagePermission, "UseView">
	| EnumItem<number, PackagePermission, "Edit">
	| EnumItem<number, PackagePermission, "Own">
export type PackagePermissionRoot = EnumObject<{
	None: EnumItem<number, PackagePermission, "None">,
	NoAccess: EnumItem<number, PackagePermission, "NoAccess">,
	Revoked: EnumItem<number, PackagePermission, "Revoked">,
	UseView: EnumItem<number, PackagePermission, "UseView">,
	Edit: EnumItem<number, PackagePermission, "Edit">,
	Own: EnumItem<number, PackagePermission, "Own">,
}, PackagePermission>
Enum.PackagePermission = {"None", "NoAccess", "Revoked", "UseView", "Edit", "Own"}

export type PartType =
	| EnumItem<number, PartType, "Ball">
	| EnumItem<number, PartType, "Block">
	| EnumItem<number, PartType, "Cylinder">
	| EnumItem<number, PartType, "Wedge">
	| EnumItem<number, PartType, "CornerWedge">
export type PartTypeRoot = EnumObject<{
	Ball: EnumItem<number, PartType, "Ball">,
	Block: EnumItem<number, PartType, "Block">,
	Cylinder: EnumItem<number, PartType, "Cylinder">,
	Wedge: EnumItem<number, PartType, "Wedge">,
	CornerWedge: EnumItem<number, PartType, "CornerWedge">,
}, PartType>
Enum.PartType = {"Ball", "Block", "Cylinder", "Wedge", "CornerWedge"}

export type ParticleEmitterShape =
	| EnumItem<number, ParticleEmitterShape, "Box">
	| EnumItem<number, ParticleEmitterShape, "Sphere">
	| EnumItem<number, ParticleEmitterShape, "Cylinder">
	| EnumItem<number, ParticleEmitterShape, "Disc">
export type ParticleEmitterShapeRoot = EnumObject<{
	Box: EnumItem<number, ParticleEmitterShape, "Box">,
	Sphere: EnumItem<number, ParticleEmitterShape, "Sphere">,
	Cylinder: EnumItem<number, ParticleEmitterShape, "Cylinder">,
	Disc: EnumItem<number, ParticleEmitterShape, "Disc">,
}, ParticleEmitterShape>
Enum.ParticleEmitterShape = {"Box", "Sphere", "Cylinder", "Disc"}

export type ParticleEmitterShapeInOut =
	| EnumItem<number, ParticleEmitterShapeInOut, "Outward">
	| EnumItem<number, ParticleEmitterShapeInOut, "Inward">
	| EnumItem<number, ParticleEmitterShapeInOut, "InAndOut">
export type ParticleEmitterShapeInOutRoot = EnumObject<{
	Outward: EnumItem<number, ParticleEmitterShapeInOut, "Outward">,
	Inward: EnumItem<number, ParticleEmitterShapeInOut, "Inward">,
	InAndOut: EnumItem<number, ParticleEmitterShapeInOut, "InAndOut">,
}, ParticleEmitterShapeInOut>
Enum.ParticleEmitterShapeInOut = {"Outward", "Inward", "InAndOut"}

export type ParticleEmitterShapeStyle =
	| EnumItem<number, ParticleEmitterShapeStyle, "Volume">
	| EnumItem<number, ParticleEmitterShapeStyle, "Surface">
export type ParticleEmitterShapeStyleRoot = EnumObject<{
	Volume: EnumItem<number, ParticleEmitterShapeStyle, "Volume">,
	Surface: EnumItem<number, ParticleEmitterShapeStyle, "Surface">,
}, ParticleEmitterShapeStyle>
Enum.ParticleEmitterShapeStyle = {"Volume", "Surface"}

export type ParticleFlipbookLayout =
	| EnumItem<number, ParticleFlipbookLayout, "None">
	| EnumItem<number, ParticleFlipbookLayout, "Grid2x2">
	| EnumItem<number, ParticleFlipbookLayout, "Grid4x4">
	| EnumItem<number, ParticleFlipbookLayout, "Grid8x8">
export type ParticleFlipbookLayoutRoot = EnumObject<{
	None: EnumItem<number, ParticleFlipbookLayout, "None">,
	Grid2x2: EnumItem<number, ParticleFlipbookLayout, "Grid2x2">,
	Grid4x4: EnumItem<number, ParticleFlipbookLayout, "Grid4x4">,
	Grid8x8: EnumItem<number, ParticleFlipbookLayout, "Grid8x8">,
}, ParticleFlipbookLayout>
Enum.ParticleFlipbookLayout = {"None", "Grid2x2", "Grid4x4", "Grid8x8"}

export type ParticleFlipbookMode =
	| EnumItem<number, ParticleFlipbookMode, "Loop">
	| EnumItem<number, ParticleFlipbookMode, "OneShot">
	| EnumItem<number, ParticleFlipbookMode, "PingPong">
	| EnumItem<number, ParticleFlipbookMode, "Random">
export type ParticleFlipbookModeRoot = EnumObject<{
	Loop: EnumItem<number, ParticleFlipbookMode, "Loop">,
	OneShot: EnumItem<number, ParticleFlipbookMode, "OneShot">,
	PingPong: EnumItem<number, ParticleFlipbookMode, "PingPong">,
	Random: EnumItem<number, ParticleFlipbookMode, "Random">,
}, ParticleFlipbookMode>
Enum.ParticleFlipbookMode = {"Loop", "OneShot", "PingPong", "Random"}

export type ParticleFlipbookTextureCompatible =
	| EnumItem<number, ParticleFlipbookTextureCompatible, "NotCompatible">
	| EnumItem<number, ParticleFlipbookTextureCompatible, "Compatible">
	| EnumItem<number, ParticleFlipbookTextureCompatible, "Unknown">
export type ParticleFlipbookTextureCompatibleRoot = EnumObject<{
	NotCompatible: EnumItem<number, ParticleFlipbookTextureCompatible, "NotCompatible">,
	Compatible: EnumItem<number, ParticleFlipbookTextureCompatible, "Compatible">,
	Unknown: EnumItem<number, ParticleFlipbookTextureCompatible, "Unknown">,
}, ParticleFlipbookTextureCompatible>
Enum.ParticleFlipbookTextureCompatible = {"NotCompatible", "Compatible", "Unknown"}

export type ParticleOrientation =
	| EnumItem<number, ParticleOrientation, "FacingCamera">
	| EnumItem<number, ParticleOrientation, "FacingCameraWorldUp">
	| EnumItem<number, ParticleOrientation, "VelocityParallel">
	| EnumItem<number, ParticleOrientation, "VelocityPerpendicular">
export type ParticleOrientationRoot = EnumObject<{
	FacingCamera: EnumItem<number, ParticleOrientation, "FacingCamera">,
	FacingCameraWorldUp: EnumItem<number, ParticleOrientation, "FacingCameraWorldUp">,
	VelocityParallel: EnumItem<number, ParticleOrientation, "VelocityParallel">,
	VelocityPerpendicular: EnumItem<number, ParticleOrientation, "VelocityPerpendicular">,
}, ParticleOrientation>
Enum.ParticleOrientation = {"FacingCamera", "FacingCameraWorldUp", "VelocityParallel", "VelocityPerpendicular"}

export type PathStatus =
	| EnumItem<number, PathStatus, "Success">
	| EnumItem<number, PathStatus, "ClosestNoPath">
	| EnumItem<number, PathStatus, "ClosestOutOfRange">
	| EnumItem<number, PathStatus, "FailStartNotEmpty">
	| EnumItem<number, PathStatus, "FailFinishNotEmpty">
	| EnumItem<number, PathStatus, "NoPath">
export type PathStatusRoot = EnumObject<{
	Success: EnumItem<number, PathStatus, "Success">,
	ClosestNoPath: EnumItem<number, PathStatus, "ClosestNoPath">,
	ClosestOutOfRange: EnumItem<number, PathStatus, "ClosestOutOfRange">,
	FailStartNotEmpty: EnumItem<number, PathStatus, "FailStartNotEmpty">,
	FailFinishNotEmpty: EnumItem<number, PathStatus, "FailFinishNotEmpty">,
	NoPath: EnumItem<number, PathStatus, "NoPath">,
}, PathStatus>
Enum.PathStatus = {"Success", "ClosestNoPath", "ClosestOutOfRange", "FailStartNotEmpty", "FailFinishNotEmpty", "NoPath"}

export type PathWaypointAction =
	| EnumItem<number, PathWaypointAction, "Walk">
	| EnumItem<number, PathWaypointAction, "Jump">
	| EnumItem<number, PathWaypointAction, "Custom">
export type PathWaypointActionRoot = EnumObject<{
	Walk: EnumItem<number, PathWaypointAction, "Walk">,
	Jump: EnumItem<number, PathWaypointAction, "Jump">,
	Custom: EnumItem<number, PathWaypointAction, "Custom">,
}, PathWaypointAction>
Enum.PathWaypointAction = {"Walk", "Jump", "Custom"}

export type PathfindingUseImprovedSearch =
	| EnumItem<number, PathfindingUseImprovedSearch, "Default">
	| EnumItem<number, PathfindingUseImprovedSearch, "Disabled">
	| EnumItem<number, PathfindingUseImprovedSearch, "Enabled">
export type PathfindingUseImprovedSearchRoot = EnumObject<{
	Default: EnumItem<number, PathfindingUseImprovedSearch, "Default">,
	Disabled: EnumItem<number, PathfindingUseImprovedSearch, "Disabled">,
	Enabled: EnumItem<number, PathfindingUseImprovedSearch, "Enabled">,
}, PathfindingUseImprovedSearch>
Enum.PathfindingUseImprovedSearch = {"Default", "Disabled", "Enabled"}

export type PermissionLevelShown =
	| EnumItem<number, PermissionLevelShown, "Game">
	| EnumItem<number, PermissionLevelShown, "RobloxGame">
	| EnumItem<number, PermissionLevelShown, "RobloxScript">
	| EnumItem<number, PermissionLevelShown, "Studio">
	| EnumItem<number, PermissionLevelShown, "Roblox">
export type PermissionLevelShownRoot = EnumObject<{
	Game: EnumItem<number, PermissionLevelShown, "Game">,
	RobloxGame: EnumItem<number, PermissionLevelShown, "RobloxGame">,
	RobloxScript: EnumItem<number, PermissionLevelShown, "RobloxScript">,
	Studio: EnumItem<number, PermissionLevelShown, "Studio">,
	Roblox: EnumItem<number, PermissionLevelShown, "Roblox">,
}, PermissionLevelShown>
Enum.PermissionLevelShown = {"Game", "RobloxGame", "RobloxScript", "Studio", "Roblox"}

export type PhysicsSimulationRate =
	| EnumItem<number, PhysicsSimulationRate, "Fixed240Hz">
	| EnumItem<number, PhysicsSimulationRate, "Fixed120Hz">
	| EnumItem<number, PhysicsSimulationRate, "Fixed60Hz">
export type PhysicsSimulationRateRoot = EnumObject<{
	Fixed240Hz: EnumItem<number, PhysicsSimulationRate, "Fixed240Hz">,
	Fixed120Hz: EnumItem<number, PhysicsSimulationRate, "Fixed120Hz">,
	Fixed60Hz: EnumItem<number, PhysicsSimulationRate, "Fixed60Hz">,
}, PhysicsSimulationRate>
Enum.PhysicsSimulationRate = {"Fixed240Hz", "Fixed120Hz", "Fixed60Hz"}

export type PhysicsSteppingMethod =
	| EnumItem<number, PhysicsSteppingMethod, "Default">
	| EnumItem<number, PhysicsSteppingMethod, "Fixed">
	| EnumItem<number, PhysicsSteppingMethod, "Adaptive">
export type PhysicsSteppingMethodRoot = EnumObject<{
	Default: EnumItem<number, PhysicsSteppingMethod, "Default">,
	Fixed: EnumItem<number, PhysicsSteppingMethod, "Fixed">,
	Adaptive: EnumItem<number, PhysicsSteppingMethod, "Adaptive">,
}, PhysicsSteppingMethod>
Enum.PhysicsSteppingMethod = {"Default", "Fixed", "Adaptive"}

export type Platform =
	| EnumItem<number, Platform, "Windows">
	| EnumItem<number, Platform, "OSX">
	| EnumItem<number, Platform, "IOS">
	| EnumItem<number, Platform, "Android">
	| EnumItem<number, Platform, "XBoxOne">
	| EnumItem<number, Platform, "PS4">
	| EnumItem<number, Platform, "PS3">
	| EnumItem<number, Platform, "XBox360">
	| EnumItem<number, Platform, "WiiU">
	| EnumItem<number, Platform, "NX">
	| EnumItem<number, Platform, "Ouya">
	| EnumItem<number, Platform, "AndroidTV">
	| EnumItem<number, Platform, "Chromecast">
	| EnumItem<number, Platform, "Linux">
	| EnumItem<number, Platform, "SteamOS">
	| EnumItem<number, Platform, "WebOS">
	| EnumItem<number, Platform, "DOS">
	| EnumItem<number, Platform, "BeOS">
	| EnumItem<number, Platform, "UWP">
	| EnumItem<number, Platform, "PS5">
	| EnumItem<number, Platform, "MetaOS">
	| EnumItem<number, Platform, "None">
export type PlatformRoot = EnumObject<{
	Windows: EnumItem<number, Platform, "Windows">,
	OSX: EnumItem<number, Platform, "OSX">,
	IOS: EnumItem<number, Platform, "IOS">,
	Android: EnumItem<number, Platform, "Android">,
	XBoxOne: EnumItem<number, Platform, "XBoxOne">,
	PS4: EnumItem<number, Platform, "PS4">,
	PS3: EnumItem<number, Platform, "PS3">,
	XBox360: EnumItem<number, Platform, "XBox360">,
	WiiU: EnumItem<number, Platform, "WiiU">,
	NX: EnumItem<number, Platform, "NX">,
	Ouya: EnumItem<number, Platform, "Ouya">,
	AndroidTV: EnumItem<number, Platform, "AndroidTV">,
	Chromecast: EnumItem<number, Platform, "Chromecast">,
	Linux: EnumItem<number, Platform, "Linux">,
	SteamOS: EnumItem<number, Platform, "SteamOS">,
	WebOS: EnumItem<number, Platform, "WebOS">,
	DOS: EnumItem<number, Platform, "DOS">,
	BeOS: EnumItem<number, Platform, "BeOS">,
	UWP: EnumItem<number, Platform, "UWP">,
	PS5: EnumItem<number, Platform, "PS5">,
	MetaOS: EnumItem<number, Platform, "MetaOS">,
	None: EnumItem<number, Platform, "None">,
}, Platform>
Enum.Platform = {
	"Windows";
	"OSX";
	"IOS";
	"Android";
	"XBoxOne";
	"PS4";
	"PS3";
	"XBox360";
	"WiiU";
	"NX";
	"Ouya";
	"AndroidTV";
	"Chromecast";
	"Linux";
	"SteamOS";
	"WebOS";
	"DOS";
	"BeOS";
	"UWP";
	"PS5";
	"MetaOS";
	"None";
}

export type PlaybackState =
	| EnumItem<number, PlaybackState, "Begin">
	| EnumItem<number, PlaybackState, "Delayed">
	| EnumItem<number, PlaybackState, "Playing">
	| EnumItem<number, PlaybackState, "Paused">
	| EnumItem<number, PlaybackState, "Completed">
	| EnumItem<number, PlaybackState, "Cancelled">
export type PlaybackStateRoot = EnumObject<{
	Begin: EnumItem<number, PlaybackState, "Begin">,
	Delayed: EnumItem<number, PlaybackState, "Delayed">,
	Playing: EnumItem<number, PlaybackState, "Playing">,
	Paused: EnumItem<number, PlaybackState, "Paused">,
	Completed: EnumItem<number, PlaybackState, "Completed">,
	Cancelled: EnumItem<number, PlaybackState, "Cancelled">,
}, PlaybackState>
Enum.PlaybackState = {"Begin", "Delayed", "Playing", "Paused", "Completed", "Cancelled"}

export type PlayerActions =
	| EnumItem<number, PlayerActions, "CharacterForward">
	| EnumItem<number, PlayerActions, "CharacterBackward">
	| EnumItem<number, PlayerActions, "CharacterLeft">
	| EnumItem<number, PlayerActions, "CharacterRight">
	| EnumItem<number, PlayerActions, "CharacterJump">
export type PlayerActionsRoot = EnumObject<{
	CharacterForward: EnumItem<number, PlayerActions, "CharacterForward">,
	CharacterBackward: EnumItem<number, PlayerActions, "CharacterBackward">,
	CharacterLeft: EnumItem<number, PlayerActions, "CharacterLeft">,
	CharacterRight: EnumItem<number, PlayerActions, "CharacterRight">,
	CharacterJump: EnumItem<number, PlayerActions, "CharacterJump">,
}, PlayerActions>
Enum.PlayerActions = {"CharacterForward", "CharacterBackward", "CharacterLeft", "CharacterRight", "CharacterJump"}

export type PlayerCharacterDestroyBehavior =
	| EnumItem<number, PlayerCharacterDestroyBehavior, "Default">
	| EnumItem<number, PlayerCharacterDestroyBehavior, "Disabled">
	| EnumItem<number, PlayerCharacterDestroyBehavior, "Enabled">
export type PlayerCharacterDestroyBehaviorRoot = EnumObject<{
	Default: EnumItem<number, PlayerCharacterDestroyBehavior, "Default">,
	Disabled: EnumItem<number, PlayerCharacterDestroyBehavior, "Disabled">,
	Enabled: EnumItem<number, PlayerCharacterDestroyBehavior, "Enabled">,
}, PlayerCharacterDestroyBehavior>
Enum.PlayerCharacterDestroyBehavior = {"Default", "Disabled", "Enabled"}

export type PlayerChatType =
	| EnumItem<number, PlayerChatType, "All">
	| EnumItem<number, PlayerChatType, "Team">
	| EnumItem<number, PlayerChatType, "Whisper">
export type PlayerChatTypeRoot = EnumObject<{
	All: EnumItem<number, PlayerChatType, "All">,
	Team: EnumItem<number, PlayerChatType, "Team">,
	Whisper: EnumItem<number, PlayerChatType, "Whisper">,
}, PlayerChatType>
Enum.PlayerChatType = {"All", "Team", "Whisper"}

export type PlayerDataErrorState =
	| EnumItem<number, PlayerDataErrorState, "LoadFailed">
	| EnumItem<number, PlayerDataErrorState, "FlushFailed">
	| EnumItem<number, PlayerDataErrorState, "ReleaseFailed">
	| EnumItem<number, PlayerDataErrorState, "None">
export type PlayerDataErrorStateRoot = EnumObject<{
	LoadFailed: EnumItem<number, PlayerDataErrorState, "LoadFailed">,
	FlushFailed: EnumItem<number, PlayerDataErrorState, "FlushFailed">,
	ReleaseFailed: EnumItem<number, PlayerDataErrorState, "ReleaseFailed">,
	None: EnumItem<number, PlayerDataErrorState, "None">,
}, PlayerDataErrorState>
Enum.PlayerDataErrorState = {"LoadFailed", "FlushFailed", "ReleaseFailed", "None"}

export type PlayerDataLoadFailureBehavior =
	| EnumItem<number, PlayerDataLoadFailureBehavior, "Failure">
	| EnumItem<number, PlayerDataLoadFailureBehavior, "FallbackToDefault">
	| EnumItem<number, PlayerDataLoadFailureBehavior, "Kick">
export type PlayerDataLoadFailureBehaviorRoot = EnumObject<{
	Failure: EnumItem<number, PlayerDataLoadFailureBehavior, "Failure">,
	FallbackToDefault: EnumItem<number, PlayerDataLoadFailureBehavior, "FallbackToDefault">,
	Kick: EnumItem<number, PlayerDataLoadFailureBehavior, "Kick">,
}, PlayerDataLoadFailureBehavior>
Enum.PlayerDataLoadFailureBehavior = {"Failure", "FallbackToDefault", "Kick"}

export type PoseEasingDirection =
	| EnumItem<number, PoseEasingDirection, "In">
	| EnumItem<number, PoseEasingDirection, "Out">
	| EnumItem<number, PoseEasingDirection, "InOut">
export type PoseEasingDirectionRoot = EnumObject<{
	In: EnumItem<number, PoseEasingDirection, "In">,
	Out: EnumItem<number, PoseEasingDirection, "Out">,
	InOut: EnumItem<number, PoseEasingDirection, "InOut">,
}, PoseEasingDirection>
Enum.PoseEasingDirection = {"In", "Out", "InOut"}

export type PoseEasingStyle =
	| EnumItem<number, PoseEasingStyle, "Linear">
	| EnumItem<number, PoseEasingStyle, "Constant">
	| EnumItem<number, PoseEasingStyle, "Elastic">
	| EnumItem<number, PoseEasingStyle, "Cubic">
	| EnumItem<number, PoseEasingStyle, "Bounce">
	| EnumItem<number, PoseEasingStyle, "CubicV2">
export type PoseEasingStyleRoot = EnumObject<{
	Linear: EnumItem<number, PoseEasingStyle, "Linear">,
	Constant: EnumItem<number, PoseEasingStyle, "Constant">,
	Elastic: EnumItem<number, PoseEasingStyle, "Elastic">,
	Cubic: EnumItem<number, PoseEasingStyle, "Cubic">,
	Bounce: EnumItem<number, PoseEasingStyle, "Bounce">,
	CubicV2: EnumItem<number, PoseEasingStyle, "CubicV2">,
}, PoseEasingStyle>
Enum.PoseEasingStyle = {"Linear", "Constant", "Elastic", "Cubic", "Bounce", "CubicV2"}

export type PositionAlignmentMode =
	| EnumItem<number, PositionAlignmentMode, "OneAttachment">
	| EnumItem<number, PositionAlignmentMode, "TwoAttachment">
export type PositionAlignmentModeRoot = EnumObject<{
	OneAttachment: EnumItem<number, PositionAlignmentMode, "OneAttachment">,
	TwoAttachment: EnumItem<number, PositionAlignmentMode, "TwoAttachment">,
}, PositionAlignmentMode>
Enum.PositionAlignmentMode = {"OneAttachment", "TwoAttachment"}

export type PreferredTextSize =
	| EnumItem<number, PreferredTextSize, "Medium">
	| EnumItem<number, PreferredTextSize, "Large">
	| EnumItem<number, PreferredTextSize, "Larger">
	| EnumItem<number, PreferredTextSize, "Largest">
export type PreferredTextSizeRoot = EnumObject<{
	Medium: EnumItem<number, PreferredTextSize, "Medium">,
	Large: EnumItem<number, PreferredTextSize, "Large">,
	Larger: EnumItem<number, PreferredTextSize, "Larger">,
	Largest: EnumItem<number, PreferredTextSize, "Largest">,
}, PreferredTextSize>
Enum.PreferredTextSize = {
	Medium = 1;
	Large = 2;
	Larger = 3;
	Largest = 4;
}

export type PrimalPhysicsSolver =
	| EnumItem<number, PrimalPhysicsSolver, "Default">
	| EnumItem<number, PrimalPhysicsSolver, "Experimental">
	| EnumItem<number, PrimalPhysicsSolver, "Disabled">
export type PrimalPhysicsSolverRoot = EnumObject<{
	Default: EnumItem<number, PrimalPhysicsSolver, "Default">,
	Experimental: EnumItem<number, PrimalPhysicsSolver, "Experimental">,
	Disabled: EnumItem<number, PrimalPhysicsSolver, "Disabled">,
}, PrimalPhysicsSolver>
Enum.PrimalPhysicsSolver = {"Default", "Experimental", "Disabled"}

export type PrimitiveType =
	| EnumItem<number, PrimitiveType, "Null">
	| EnumItem<number, PrimitiveType, "Ball">
	| EnumItem<number, PrimitiveType, "Cylinder">
	| EnumItem<number, PrimitiveType, "Block">
	| EnumItem<number, PrimitiveType, "Wedge">
	| EnumItem<number, PrimitiveType, "CornerWedge">
export type PrimitiveTypeRoot = EnumObject<{
	Null: EnumItem<number, PrimitiveType, "Null">,
	Ball: EnumItem<number, PrimitiveType, "Ball">,
	Cylinder: EnumItem<number, PrimitiveType, "Cylinder">,
	Block: EnumItem<number, PrimitiveType, "Block">,
	Wedge: EnumItem<number, PrimitiveType, "Wedge">,
	CornerWedge: EnumItem<number, PrimitiveType, "CornerWedge">,
}, PrimitiveType>
Enum.PrimitiveType = {"Null", "Ball", "Cylinder", "Block", "Wedge", "CornerWedge"}

export type PrivilegeType =
	| EnumItem<number, PrivilegeType, "Banned">
	| EnumItem<number, PrivilegeType, "Visitor">
	| EnumItem<number, PrivilegeType, "Member">
	| EnumItem<number, PrivilegeType, "Admin">
	| EnumItem<number, PrivilegeType, "Owner">
export type PrivilegeTypeRoot = EnumObject<{
	Banned: EnumItem<number, PrivilegeType, "Banned">,
	Visitor: EnumItem<number, PrivilegeType, "Visitor">,
	Member: EnumItem<number, PrivilegeType, "Member">,
	Admin: EnumItem<number, PrivilegeType, "Admin">,
	Owner: EnumItem<number, PrivilegeType, "Owner">,
}, PrivilegeType>
Enum.PrivilegeType = {
	Banned = 0;
	Visitor = 10;
	Member = 128;
	Admin = 240;
	Owner = 255;
}

export type ProductLocationRestriction =
	| EnumItem<number, ProductLocationRestriction, "AvatarShop">
	| EnumItem<number, ProductLocationRestriction, "AllowedGames">
	| EnumItem<number, ProductLocationRestriction, "AllGames">
export type ProductLocationRestrictionRoot = EnumObject<{
	AvatarShop: EnumItem<number, ProductLocationRestriction, "AvatarShop">,
	AllowedGames: EnumItem<number, ProductLocationRestriction, "AllowedGames">,
	AllGames: EnumItem<number, ProductLocationRestriction, "AllGames">,
}, ProductLocationRestriction>
Enum.ProductLocationRestriction = {"AvatarShop", "AllowedGames", "AllGames"}

export type ProductPurchaseChannel =
	| EnumItem<number, ProductPurchaseChannel, "InExperience">
	| EnumItem<number, ProductPurchaseChannel, "ExperienceDetailsPage">
	| EnumItem<number, ProductPurchaseChannel, "AdReward">
	| EnumItem<number, ProductPurchaseChannel, "CommerceProduct">
export type ProductPurchaseChannelRoot = EnumObject<{
	InExperience: EnumItem<number, ProductPurchaseChannel, "InExperience">,
	ExperienceDetailsPage: EnumItem<number, ProductPurchaseChannel, "ExperienceDetailsPage">,
	AdReward: EnumItem<number, ProductPurchaseChannel, "AdReward">,
	CommerceProduct: EnumItem<number, ProductPurchaseChannel, "CommerceProduct">,
}, ProductPurchaseChannel>
Enum.ProductPurchaseChannel = {
	InExperience = 1;
	ExperienceDetailsPage = 2;
	AdReward = 3;
	CommerceProduct = 4;
}

export type ProductPurchaseDecision =
	| EnumItem<number, ProductPurchaseDecision, "NotProcessedYet">
	| EnumItem<number, ProductPurchaseDecision, "PurchaseGranted">
export type ProductPurchaseDecisionRoot = EnumObject<{
	NotProcessedYet: EnumItem<number, ProductPurchaseDecision, "NotProcessedYet">,
	PurchaseGranted: EnumItem<number, ProductPurchaseDecision, "PurchaseGranted">,
}, ProductPurchaseDecision>
Enum.ProductPurchaseDecision = {"NotProcessedYet", "PurchaseGranted"}

export type PromptCreateAssetResult =
	| EnumItem<number, PromptCreateAssetResult, "Success">
	| EnumItem<number, PromptCreateAssetResult, "PermissionDenied">
	| EnumItem<number, PromptCreateAssetResult, "Timeout">
	| EnumItem<number, PromptCreateAssetResult, "UploadFailed">
	| EnumItem<number, PromptCreateAssetResult, "NoUserInput">
	| EnumItem<number, PromptCreateAssetResult, "UnknownFailure">
export type PromptCreateAssetResultRoot = EnumObject<{
	Success: EnumItem<number, PromptCreateAssetResult, "Success">,
	PermissionDenied: EnumItem<number, PromptCreateAssetResult, "PermissionDenied">,
	Timeout: EnumItem<number, PromptCreateAssetResult, "Timeout">,
	UploadFailed: EnumItem<number, PromptCreateAssetResult, "UploadFailed">,
	NoUserInput: EnumItem<number, PromptCreateAssetResult, "NoUserInput">,
	UnknownFailure: EnumItem<number, PromptCreateAssetResult, "UnknownFailure">,
}, PromptCreateAssetResult>
Enum.PromptCreateAssetResult = {
	Success = 1;
	PermissionDenied = 2;
	Timeout = 3;
	UploadFailed = 4;
	NoUserInput = 5;
	UnknownFailure = 6;
}

export type PromptCreateAvatarResult =
	| EnumItem<number, PromptCreateAvatarResult, "Success">
	| EnumItem<number, PromptCreateAvatarResult, "PermissionDenied">
	| EnumItem<number, PromptCreateAvatarResult, "Timeout">
	| EnumItem<number, PromptCreateAvatarResult, "UploadFailed">
	| EnumItem<number, PromptCreateAvatarResult, "NoUserInput">
	| EnumItem<number, PromptCreateAvatarResult, "InvalidHumanoidDescription">
	| EnumItem<number, PromptCreateAvatarResult, "UGCValidationFailed">
	| EnumItem<number, PromptCreateAvatarResult, "ModeratedName">
	| EnumItem<number, PromptCreateAvatarResult, "MaxOutfits">
	| EnumItem<number, PromptCreateAvatarResult, "PurchaseFailure">
	| EnumItem<number, PromptCreateAvatarResult, "UnknownFailure">
	| EnumItem<number, PromptCreateAvatarResult, "TokenInvalid">
export type PromptCreateAvatarResultRoot = EnumObject<{
	Success: EnumItem<number, PromptCreateAvatarResult, "Success">,
	PermissionDenied: EnumItem<number, PromptCreateAvatarResult, "PermissionDenied">,
	Timeout: EnumItem<number, PromptCreateAvatarResult, "Timeout">,
	UploadFailed: EnumItem<number, PromptCreateAvatarResult, "UploadFailed">,
	NoUserInput: EnumItem<number, PromptCreateAvatarResult, "NoUserInput">,
	InvalidHumanoidDescription: EnumItem<number, PromptCreateAvatarResult, "InvalidHumanoidDescription">,
	UGCValidationFailed: EnumItem<number, PromptCreateAvatarResult, "UGCValidationFailed">,
	ModeratedName: EnumItem<number, PromptCreateAvatarResult, "ModeratedName">,
	MaxOutfits: EnumItem<number, PromptCreateAvatarResult, "MaxOutfits">,
	PurchaseFailure: EnumItem<number, PromptCreateAvatarResult, "PurchaseFailure">,
	UnknownFailure: EnumItem<number, PromptCreateAvatarResult, "UnknownFailure">,
	TokenInvalid: EnumItem<number, PromptCreateAvatarResult, "TokenInvalid">,
}, PromptCreateAvatarResult>
Enum.PromptCreateAvatarResult = {
	Success = 1;
	PermissionDenied = 2;
	Timeout = 3;
	UploadFailed = 4;
	NoUserInput = 5;
	InvalidHumanoidDescription = 6;
	UGCValidationFailed = 7;
	ModeratedName = 8;
	MaxOutfits = 9;
	PurchaseFailure = 10;
	UnknownFailure = 11;
	TokenInvalid = 12;
}

export type PromptPublishAssetResult =
	| EnumItem<number, PromptPublishAssetResult, "Success">
	| EnumItem<number, PromptPublishAssetResult, "PermissionDenied">
	| EnumItem<number, PromptPublishAssetResult, "Timeout">
	| EnumItem<number, PromptPublishAssetResult, "UploadFailed">
	| EnumItem<number, PromptPublishAssetResult, "NoUserInput">
	| EnumItem<number, PromptPublishAssetResult, "UnknownFailure">
export type PromptPublishAssetResultRoot = EnumObject<{
	Success: EnumItem<number, PromptPublishAssetResult, "Success">,
	PermissionDenied: EnumItem<number, PromptPublishAssetResult, "PermissionDenied">,
	Timeout: EnumItem<number, PromptPublishAssetResult, "Timeout">,
	UploadFailed: EnumItem<number, PromptPublishAssetResult, "UploadFailed">,
	NoUserInput: EnumItem<number, PromptPublishAssetResult, "NoUserInput">,
	UnknownFailure: EnumItem<number, PromptPublishAssetResult, "UnknownFailure">,
}, PromptPublishAssetResult>
Enum.PromptPublishAssetResult = {
	Success = 1;
	PermissionDenied = 2;
	Timeout = 3;
	UploadFailed = 4;
	NoUserInput = 5;
	UnknownFailure = 6;
}

export type PropertyStatus =
	| EnumItem<number, PropertyStatus, "Ok">
	| EnumItem<number, PropertyStatus, "Warning">
	| EnumItem<number, PropertyStatus, "Error">
export type PropertyStatusRoot = EnumObject<{
	Ok: EnumItem<number, PropertyStatus, "Ok">,
	Warning: EnumItem<number, PropertyStatus, "Warning">,
	Error: EnumItem<number, PropertyStatus, "Error">,
}, PropertyStatus>
Enum.PropertyStatus = {"Ok", "Warning", "Error"}

export type ProximityPromptExclusivity =
	| EnumItem<number, ProximityPromptExclusivity, "OnePerButton">
	| EnumItem<number, ProximityPromptExclusivity, "OneGlobally">
	| EnumItem<number, ProximityPromptExclusivity, "AlwaysShow">
export type ProximityPromptExclusivityRoot = EnumObject<{
	OnePerButton: EnumItem<number, ProximityPromptExclusivity, "OnePerButton">,
	OneGlobally: EnumItem<number, ProximityPromptExclusivity, "OneGlobally">,
	AlwaysShow: EnumItem<number, ProximityPromptExclusivity, "AlwaysShow">,
}, ProximityPromptExclusivity>
Enum.ProximityPromptExclusivity = {"OnePerButton", "OneGlobally", "AlwaysShow"}

export type ProximityPromptInputType =
	| EnumItem<number, ProximityPromptInputType, "Keyboard">
	| EnumItem<number, ProximityPromptInputType, "Gamepad">
	| EnumItem<number, ProximityPromptInputType, "Touch">
export type ProximityPromptInputTypeRoot = EnumObject<{
	Keyboard: EnumItem<number, ProximityPromptInputType, "Keyboard">,
	Gamepad: EnumItem<number, ProximityPromptInputType, "Gamepad">,
	Touch: EnumItem<number, ProximityPromptInputType, "Touch">,
}, ProximityPromptInputType>
Enum.ProximityPromptInputType = {"Keyboard", "Gamepad", "Touch"}

export type ProximityPromptStyle =
	| EnumItem<number, ProximityPromptStyle, "Default">
	| EnumItem<number, ProximityPromptStyle, "Custom">
export type ProximityPromptStyleRoot = EnumObject<{
	Default: EnumItem<number, ProximityPromptStyle, "Default">,
	Custom: EnumItem<number, ProximityPromptStyle, "Custom">,
}, ProximityPromptStyle>
Enum.ProximityPromptStyle = {"Default", "Custom"}

export type QualityLevel =
	| EnumItem<number, QualityLevel, "Automatic">
	| EnumItem<number, QualityLevel, "Level01">
	| EnumItem<number, QualityLevel, "Level02">
	| EnumItem<number, QualityLevel, "Level03">
	| EnumItem<number, QualityLevel, "Level04">
	| EnumItem<number, QualityLevel, "Level05">
	| EnumItem<number, QualityLevel, "Level06">
	| EnumItem<number, QualityLevel, "Level07">
	| EnumItem<number, QualityLevel, "Level08">
	| EnumItem<number, QualityLevel, "Level09">
	| EnumItem<number, QualityLevel, "Level10">
	| EnumItem<number, QualityLevel, "Level11">
	| EnumItem<number, QualityLevel, "Level12">
	| EnumItem<number, QualityLevel, "Level13">
	| EnumItem<number, QualityLevel, "Level14">
	| EnumItem<number, QualityLevel, "Level15">
	| EnumItem<number, QualityLevel, "Level16">
	| EnumItem<number, QualityLevel, "Level17">
	| EnumItem<number, QualityLevel, "Level18">
	| EnumItem<number, QualityLevel, "Level19">
	| EnumItem<number, QualityLevel, "Level20">
	| EnumItem<number, QualityLevel, "Level21">
export type QualityLevelRoot = EnumObject<{
	Automatic: EnumItem<number, QualityLevel, "Automatic">,
	Level01: EnumItem<number, QualityLevel, "Level01">,
	Level02: EnumItem<number, QualityLevel, "Level02">,
	Level03: EnumItem<number, QualityLevel, "Level03">,
	Level04: EnumItem<number, QualityLevel, "Level04">,
	Level05: EnumItem<number, QualityLevel, "Level05">,
	Level06: EnumItem<number, QualityLevel, "Level06">,
	Level07: EnumItem<number, QualityLevel, "Level07">,
	Level08: EnumItem<number, QualityLevel, "Level08">,
	Level09: EnumItem<number, QualityLevel, "Level09">,
	Level10: EnumItem<number, QualityLevel, "Level10">,
	Level11: EnumItem<number, QualityLevel, "Level11">,
	Level12: EnumItem<number, QualityLevel, "Level12">,
	Level13: EnumItem<number, QualityLevel, "Level13">,
	Level14: EnumItem<number, QualityLevel, "Level14">,
	Level15: EnumItem<number, QualityLevel, "Level15">,
	Level16: EnumItem<number, QualityLevel, "Level16">,
	Level17: EnumItem<number, QualityLevel, "Level17">,
	Level18: EnumItem<number, QualityLevel, "Level18">,
	Level19: EnumItem<number, QualityLevel, "Level19">,
	Level20: EnumItem<number, QualityLevel, "Level20">,
	Level21: EnumItem<number, QualityLevel, "Level21">,
}, QualityLevel>
Enum.QualityLevel = {
	"Automatic";
	"Level01";
	"Level02";
	"Level03";
	"Level04";
	"Level05";
	"Level06";
	"Level07";
	"Level08";
	"Level09";
	"Level10";
	"Level11";
	"Level12";
	"Level13";
	"Level14";
	"Level15";
	"Level16";
	"Level17";
	"Level18";
	"Level19";
	"Level20";
	"Level21";
}

export type R15CollisionType =
	| EnumItem<number, R15CollisionType, "OuterBox">
	| EnumItem<number, R15CollisionType, "InnerBox">
export type R15CollisionTypeRoot = EnumObject<{
	OuterBox: EnumItem<number, R15CollisionType, "OuterBox">,
	InnerBox: EnumItem<number, R15CollisionType, "InnerBox">,
}, R15CollisionType>
Enum.R15CollisionType = {"OuterBox", "InnerBox"}

export type RaycastFilterType =
	| EnumItem<number, RaycastFilterType, "Exclude">
	| EnumItem<number, RaycastFilterType, "Include">
export type RaycastFilterTypeRoot = EnumObject<{
	Exclude: EnumItem<number, RaycastFilterType, "Exclude">,
	Include: EnumItem<number, RaycastFilterType, "Include">,
}, RaycastFilterType>
Enum.RaycastFilterType = {"Exclude", "Include"}

export type RejectCharacterDeletions =
	| EnumItem<number, RejectCharacterDeletions, "Default">
	| EnumItem<number, RejectCharacterDeletions, "Disabled">
	| EnumItem<number, RejectCharacterDeletions, "Enabled">
export type RejectCharacterDeletionsRoot = EnumObject<{
	Default: EnumItem<number, RejectCharacterDeletions, "Default">,
	Disabled: EnumItem<number, RejectCharacterDeletions, "Disabled">,
	Enabled: EnumItem<number, RejectCharacterDeletions, "Enabled">,
}, RejectCharacterDeletions>
Enum.RejectCharacterDeletions = {"Default", "Disabled", "Enabled"}

export type RenderFidelity =
	| EnumItem<number, RenderFidelity, "Automatic">
	| EnumItem<number, RenderFidelity, "Precise">
	| EnumItem<number, RenderFidelity, "Performance">
export type RenderFidelityRoot = EnumObject<{
	Automatic: EnumItem<number, RenderFidelity, "Automatic">,
	Precise: EnumItem<number, RenderFidelity, "Precise">,
	Performance: EnumItem<number, RenderFidelity, "Performance">,
}, RenderFidelity>
Enum.RenderFidelity = {"Automatic", "Precise", "Performance"}

export type RenderPriority =
	| EnumItem<number, RenderPriority, "First">
	| EnumItem<number, RenderPriority, "Input">
	| EnumItem<number, RenderPriority, "Camera">
	| EnumItem<number, RenderPriority, "Character">
	| EnumItem<number, RenderPriority, "Last">
export type RenderPriorityRoot = EnumObject<{
	First: EnumItem<number, RenderPriority, "First">,
	Input: EnumItem<number, RenderPriority, "Input">,
	Camera: EnumItem<number, RenderPriority, "Camera">,
	Character: EnumItem<number, RenderPriority, "Character">,
	Last: EnumItem<number, RenderPriority, "Last">,
}, RenderPriority>
Enum.RenderPriority = {
	First = 0;
	Input = 100;
	Camera = 200;
	Character = 300;
	Last = 2000;
}

export type RenderingCacheOptimizationMode =
	| EnumItem<number, RenderingCacheOptimizationMode, "Default">
	| EnumItem<number, RenderingCacheOptimizationMode, "Disabled">
	| EnumItem<number, RenderingCacheOptimizationMode, "Enabled">
export type RenderingCacheOptimizationModeRoot = EnumObject<{
	Default: EnumItem<number, RenderingCacheOptimizationMode, "Default">,
	Disabled: EnumItem<number, RenderingCacheOptimizationMode, "Disabled">,
	Enabled: EnumItem<number, RenderingCacheOptimizationMode, "Enabled">,
}, RenderingCacheOptimizationMode>
Enum.RenderingCacheOptimizationMode = {"Default", "Disabled", "Enabled"}

export type RenderingTestComparisonMethod =
	| EnumItem<number, RenderingTestComparisonMethod, "psnr">
	| EnumItem<number, RenderingTestComparisonMethod, "diff">
export type RenderingTestComparisonMethodRoot = EnumObject<{
	psnr: EnumItem<number, RenderingTestComparisonMethod, "psnr">,
	diff: EnumItem<number, RenderingTestComparisonMethod, "diff">,
}, RenderingTestComparisonMethod>
Enum.RenderingTestComparisonMethod = {"psnr", "diff"}

export type ReplicateInstanceDestroySetting =
	| EnumItem<number, ReplicateInstanceDestroySetting, "Default">
	| EnumItem<number, ReplicateInstanceDestroySetting, "Disabled">
	| EnumItem<number, ReplicateInstanceDestroySetting, "Enabled">
export type ReplicateInstanceDestroySettingRoot = EnumObject<{
	Default: EnumItem<number, ReplicateInstanceDestroySetting, "Default">,
	Disabled: EnumItem<number, ReplicateInstanceDestroySetting, "Disabled">,
	Enabled: EnumItem<number, ReplicateInstanceDestroySetting, "Enabled">,
}, ReplicateInstanceDestroySetting>
Enum.ReplicateInstanceDestroySetting = {"Default", "Disabled", "Enabled"}

export type ResamplerMode = | EnumItem<number, ResamplerMode, "Default"> | EnumItem<number, ResamplerMode, "Pixelated">
export type ResamplerModeRoot = EnumObject<{
	Default: EnumItem<number, ResamplerMode, "Default">,
	Pixelated: EnumItem<number, ResamplerMode, "Pixelated">,
}, ResamplerMode>
Enum.ResamplerMode = {"Default", "Pixelated"}

export type ReservedHighlightId =
	| EnumItem<number, ReservedHighlightId, "Standard">
	| EnumItem<number, ReservedHighlightId, "Active">
	| EnumItem<number, ReservedHighlightId, "Hover">
	| EnumItem<number, ReservedHighlightId, "Selection">
export type ReservedHighlightIdRoot = EnumObject<{
	Standard: EnumItem<number, ReservedHighlightId, "Standard">,
	Active: EnumItem<number, ReservedHighlightId, "Active">,
	Hover: EnumItem<number, ReservedHighlightId, "Hover">,
	Selection: EnumItem<number, ReservedHighlightId, "Selection">,
}, ReservedHighlightId>
Enum.ReservedHighlightId = {
	Standard = 0;
	Active = 131072;
	Hover = 262144;
	Selection = 524288;
}

export type RestPose =
	| EnumItem<number, RestPose, "Default">
	| EnumItem<number, RestPose, "RotationsReset">
	| EnumItem<number, RestPose, "Custom">
export type RestPoseRoot = EnumObject<{
	Default: EnumItem<number, RestPose, "Default">,
	RotationsReset: EnumItem<number, RestPose, "RotationsReset">,
	Custom: EnumItem<number, RestPose, "Custom">,
}, RestPose>
Enum.RestPose = {"Default", "RotationsReset", "Custom"}

export type ReturnKeyType =
	| EnumItem<number, ReturnKeyType, "Default">
	| EnumItem<number, ReturnKeyType, "Done">
	| EnumItem<number, ReturnKeyType, "Go">
	| EnumItem<number, ReturnKeyType, "Next">
	| EnumItem<number, ReturnKeyType, "Search">
	| EnumItem<number, ReturnKeyType, "Send">
export type ReturnKeyTypeRoot = EnumObject<{
	Default: EnumItem<number, ReturnKeyType, "Default">,
	Done: EnumItem<number, ReturnKeyType, "Done">,
	Go: EnumItem<number, ReturnKeyType, "Go">,
	Next: EnumItem<number, ReturnKeyType, "Next">,
	Search: EnumItem<number, ReturnKeyType, "Search">,
	Send: EnumItem<number, ReturnKeyType, "Send">,
}, ReturnKeyType>
Enum.ReturnKeyType = {"Default", "Done", "Go", "Next", "Search", "Send"}

export type ReverbType =
	| EnumItem<number, ReverbType, "NoReverb">
	| EnumItem<number, ReverbType, "GenericReverb">
	| EnumItem<number, ReverbType, "PaddedCell">
	| EnumItem<number, ReverbType, "Room">
	| EnumItem<number, ReverbType, "Bathroom">
	| EnumItem<number, ReverbType, "LivingRoom">
	| EnumItem<number, ReverbType, "StoneRoom">
	| EnumItem<number, ReverbType, "Auditorium">
	| EnumItem<number, ReverbType, "ConcertHall">
	| EnumItem<number, ReverbType, "Cave">
	| EnumItem<number, ReverbType, "Arena">
	| EnumItem<number, ReverbType, "Hangar">
	| EnumItem<number, ReverbType, "CarpettedHallway">
	| EnumItem<number, ReverbType, "Hallway">
	| EnumItem<number, ReverbType, "StoneCorridor">
	| EnumItem<number, ReverbType, "Alley">
	| EnumItem<number, ReverbType, "Forest">
	| EnumItem<number, ReverbType, "City">
	| EnumItem<number, ReverbType, "Mountains">
	| EnumItem<number, ReverbType, "Quarry">
	| EnumItem<number, ReverbType, "Plain">
	| EnumItem<number, ReverbType, "ParkingLot">
	| EnumItem<number, ReverbType, "SewerPipe">
	| EnumItem<number, ReverbType, "UnderWater">
export type ReverbTypeRoot = EnumObject<{
	NoReverb: EnumItem<number, ReverbType, "NoReverb">,
	GenericReverb: EnumItem<number, ReverbType, "GenericReverb">,
	PaddedCell: EnumItem<number, ReverbType, "PaddedCell">,
	Room: EnumItem<number, ReverbType, "Room">,
	Bathroom: EnumItem<number, ReverbType, "Bathroom">,
	LivingRoom: EnumItem<number, ReverbType, "LivingRoom">,
	StoneRoom: EnumItem<number, ReverbType, "StoneRoom">,
	Auditorium: EnumItem<number, ReverbType, "Auditorium">,
	ConcertHall: EnumItem<number, ReverbType, "ConcertHall">,
	Cave: EnumItem<number, ReverbType, "Cave">,
	Arena: EnumItem<number, ReverbType, "Arena">,
	Hangar: EnumItem<number, ReverbType, "Hangar">,
	CarpettedHallway: EnumItem<number, ReverbType, "CarpettedHallway">,
	Hallway: EnumItem<number, ReverbType, "Hallway">,
	StoneCorridor: EnumItem<number, ReverbType, "StoneCorridor">,
	Alley: EnumItem<number, ReverbType, "Alley">,
	Forest: EnumItem<number, ReverbType, "Forest">,
	City: EnumItem<number, ReverbType, "City">,
	Mountains: EnumItem<number, ReverbType, "Mountains">,
	Quarry: EnumItem<number, ReverbType, "Quarry">,
	Plain: EnumItem<number, ReverbType, "Plain">,
	ParkingLot: EnumItem<number, ReverbType, "ParkingLot">,
	SewerPipe: EnumItem<number, ReverbType, "SewerPipe">,
	UnderWater: EnumItem<number, ReverbType, "UnderWater">,
}, ReverbType>
Enum.ReverbType = {
	"NoReverb";
	"GenericReverb";
	"PaddedCell";
	"Room";
	"Bathroom";
	"LivingRoom";
	"StoneRoom";
	"Auditorium";
	"ConcertHall";
	"Cave";
	"Arena";
	"Hangar";
	"CarpettedHallway";
	"Hallway";
	"StoneCorridor";
	"Alley";
	"Forest";
	"City";
	"Mountains";
	"Quarry";
	"Plain";
	"ParkingLot";
	"SewerPipe";
	"UnderWater";
}

export type RibbonTool =
	| EnumItem<number, RibbonTool, "Select">
	| EnumItem<number, RibbonTool, "Scale">
	| EnumItem<number, RibbonTool, "Rotate">
	| EnumItem<number, RibbonTool, "Move">
	| EnumItem<number, RibbonTool, "Transform">
	| EnumItem<number, RibbonTool, "ColorPicker">
	| EnumItem<number, RibbonTool, "MaterialPicker">
	| EnumItem<number, RibbonTool, "Group">
	| EnumItem<number, RibbonTool, "Ungroup">
	| EnumItem<number, RibbonTool, "None">
	| EnumItem<number, RibbonTool, "PivotEditor">
export type RibbonToolRoot = EnumObject<{
	Select: EnumItem<number, RibbonTool, "Select">,
	Scale: EnumItem<number, RibbonTool, "Scale">,
	Rotate: EnumItem<number, RibbonTool, "Rotate">,
	Move: EnumItem<number, RibbonTool, "Move">,
	Transform: EnumItem<number, RibbonTool, "Transform">,
	ColorPicker: EnumItem<number, RibbonTool, "ColorPicker">,
	MaterialPicker: EnumItem<number, RibbonTool, "MaterialPicker">,
	Group: EnumItem<number, RibbonTool, "Group">,
	Ungroup: EnumItem<number, RibbonTool, "Ungroup">,
	None: EnumItem<number, RibbonTool, "None">,
	PivotEditor: EnumItem<number, RibbonTool, "PivotEditor">,
}, RibbonTool>
Enum.RibbonTool = {
	"Select";
	"Scale";
	"Rotate";
	"Move";
	"Transform";
	"ColorPicker";
	"MaterialPicker";
	"Group";
	"Ungroup";
	"None";
	"PivotEditor";
}

export type RigScale =
	| EnumItem<number, RigScale, "Default">
	| EnumItem<number, RigScale, "Rthro">
	| EnumItem<number, RigScale, "RthroNarrow">
export type RigScaleRoot = EnumObject<{
	Default: EnumItem<number, RigScale, "Default">,
	Rthro: EnumItem<number, RigScale, "Rthro">,
	RthroNarrow: EnumItem<number, RigScale, "RthroNarrow">,
}, RigScale>
Enum.RigScale = {"Default", "Rthro", "RthroNarrow"}

export type RigType =
	| EnumItem<number, RigType, "R15">
	| EnumItem<number, RigType, "Custom">
	| EnumItem<number, RigType, "None">
export type RigTypeRoot = EnumObject<{
	R15: EnumItem<number, RigType, "R15">,
	Custom: EnumItem<number, RigType, "Custom">,
	None: EnumItem<number, RigType, "None">,
}, RigType>
Enum.RigType = {"R15", "Custom", "None"}

export type RollOffMode =
	| EnumItem<number, RollOffMode, "Inverse">
	| EnumItem<number, RollOffMode, "Linear">
	| EnumItem<number, RollOffMode, "LinearSquare">
	| EnumItem<number, RollOffMode, "InverseTapered">
export type RollOffModeRoot = EnumObject<{
	Inverse: EnumItem<number, RollOffMode, "Inverse">,
	Linear: EnumItem<number, RollOffMode, "Linear">,
	LinearSquare: EnumItem<number, RollOffMode, "LinearSquare">,
	InverseTapered: EnumItem<number, RollOffMode, "InverseTapered">,
}, RollOffMode>
Enum.RollOffMode = {"Inverse", "Linear", "LinearSquare", "InverseTapered"}

export type RolloutState =
	| EnumItem<number, RolloutState, "Default">
	| EnumItem<number, RolloutState, "Disabled">
	| EnumItem<number, RolloutState, "Enabled">
export type RolloutStateRoot = EnumObject<{
	Default: EnumItem<number, RolloutState, "Default">,
	Disabled: EnumItem<number, RolloutState, "Disabled">,
	Enabled: EnumItem<number, RolloutState, "Enabled">,
}, RolloutState>
Enum.RolloutState = {"Default", "Disabled", "Enabled"}

export type RotationOrder =
	| EnumItem<number, RotationOrder, "XYZ">
	| EnumItem<number, RotationOrder, "XZY">
	| EnumItem<number, RotationOrder, "YZX">
	| EnumItem<number, RotationOrder, "YXZ">
	| EnumItem<number, RotationOrder, "ZXY">
	| EnumItem<number, RotationOrder, "ZYX">
export type RotationOrderRoot = EnumObject<{
	XYZ: EnumItem<number, RotationOrder, "XYZ">,
	XZY: EnumItem<number, RotationOrder, "XZY">,
	YZX: EnumItem<number, RotationOrder, "YZX">,
	YXZ: EnumItem<number, RotationOrder, "YXZ">,
	ZXY: EnumItem<number, RotationOrder, "ZXY">,
	ZYX: EnumItem<number, RotationOrder, "ZYX">,
}, RotationOrder>
Enum.RotationOrder = {"XYZ", "XZY", "YZX", "YXZ", "ZXY", "ZYX"}

export type RotationType =
	| EnumItem<number, RotationType, "MovementRelative">
	| EnumItem<number, RotationType, "CameraRelative">
export type RotationTypeRoot = EnumObject<{
	MovementRelative: EnumItem<number, RotationType, "MovementRelative">,
	CameraRelative: EnumItem<number, RotationType, "CameraRelative">,
}, RotationType>
Enum.RotationType = {"MovementRelative", "CameraRelative"}

export type RtlTextSupport =
	| EnumItem<number, RtlTextSupport, "Default">
	| EnumItem<number, RtlTextSupport, "Disabled">
	| EnumItem<number, RtlTextSupport, "Enabled">
export type RtlTextSupportRoot = EnumObject<{
	Default: EnumItem<number, RtlTextSupport, "Default">,
	Disabled: EnumItem<number, RtlTextSupport, "Disabled">,
	Enabled: EnumItem<number, RtlTextSupport, "Enabled">,
}, RtlTextSupport>
Enum.RtlTextSupport = {"Default", "Disabled", "Enabled"}

export type RunContext =
	| EnumItem<number, RunContext, "Legacy">
	| EnumItem<number, RunContext, "Server">
	| EnumItem<number, RunContext, "Client">
	| EnumItem<number, RunContext, "Plugin">
export type RunContextRoot = EnumObject<{
	Legacy: EnumItem<number, RunContext, "Legacy">,
	Server: EnumItem<number, RunContext, "Server">,
	Client: EnumItem<number, RunContext, "Client">,
	Plugin: EnumItem<number, RunContext, "Plugin">,
}, RunContext>
Enum.RunContext = {"Legacy", "Server", "Client", "Plugin"}

export type RunState =
	| EnumItem<number, RunState, "Stopped">
	| EnumItem<number, RunState, "Running">
	| EnumItem<number, RunState, "Paused">
export type RunStateRoot = EnumObject<{
	Stopped: EnumItem<number, RunState, "Stopped">,
	Running: EnumItem<number, RunState, "Running">,
	Paused: EnumItem<number, RunState, "Paused">,
}, RunState>
Enum.RunState = {"Stopped", "Running", "Paused"}

export type RuntimeUndoBehavior =
	| EnumItem<number, RuntimeUndoBehavior, "Aggregate">
	| EnumItem<number, RuntimeUndoBehavior, "Snapshot">
	| EnumItem<number, RuntimeUndoBehavior, "Hybrid">
export type RuntimeUndoBehaviorRoot = EnumObject<{
	Aggregate: EnumItem<number, RuntimeUndoBehavior, "Aggregate">,
	Snapshot: EnumItem<number, RuntimeUndoBehavior, "Snapshot">,
	Hybrid: EnumItem<number, RuntimeUndoBehavior, "Hybrid">,
}, RuntimeUndoBehavior>
Enum.RuntimeUndoBehavior = {"Aggregate", "Snapshot", "Hybrid"}

export type SafeAreaCompatibility =
	| EnumItem<number, SafeAreaCompatibility, "None">
	| EnumItem<number, SafeAreaCompatibility, "FullscreenExtension">
export type SafeAreaCompatibilityRoot = EnumObject<{
	None: EnumItem<number, SafeAreaCompatibility, "None">,
	FullscreenExtension: EnumItem<number, SafeAreaCompatibility, "FullscreenExtension">,
}, SafeAreaCompatibility>
Enum.SafeAreaCompatibility = {"None", "FullscreenExtension"}

export type SalesTypeFilter =
	| EnumItem<number, SalesTypeFilter, "All">
	| EnumItem<number, SalesTypeFilter, "Collectibles">
	| EnumItem<number, SalesTypeFilter, "Premium">
export type SalesTypeFilterRoot = EnumObject<{
	All: EnumItem<number, SalesTypeFilter, "All">,
	Collectibles: EnumItem<number, SalesTypeFilter, "Collectibles">,
	Premium: EnumItem<number, SalesTypeFilter, "Premium">,
}, SalesTypeFilter>
Enum.SalesTypeFilter = {
	All = 1;
	Collectibles = 2;
	Premium = 3;
}

export type SandboxedInstanceMode =
	| EnumItem<number, SandboxedInstanceMode, "Default">
	| EnumItem<number, SandboxedInstanceMode, "Experimental">
export type SandboxedInstanceModeRoot = EnumObject<{
	Default: EnumItem<number, SandboxedInstanceMode, "Default">,
	Experimental: EnumItem<number, SandboxedInstanceMode, "Experimental">,
}, SandboxedInstanceMode>
Enum.SandboxedInstanceMode = {"Default", "Experimental"}

export type SaveAvatarThumbnailCustomizationFailure =
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadThumbnailType">
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadYRotDeg">
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadFieldOfViewDeg">
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadDistanceScale">
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "Other">
	| EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "Throttled">
export type SaveAvatarThumbnailCustomizationFailureRoot = EnumObject<{
	BadThumbnailType: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadThumbnailType">,
	BadYRotDeg: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadYRotDeg">,
	BadFieldOfViewDeg: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadFieldOfViewDeg">,
	BadDistanceScale: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "BadDistanceScale">,
	Other: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "Other">,
	Throttled: EnumItem<number, SaveAvatarThumbnailCustomizationFailure, "Throttled">,
}, SaveAvatarThumbnailCustomizationFailure>
Enum.SaveAvatarThumbnailCustomizationFailure = {
	BadThumbnailType = 1;
	BadYRotDeg = 2;
	BadFieldOfViewDeg = 3;
	BadDistanceScale = 4;
	Other = 5;
	Throttled = 6;
}

export type SaveFilter =
	| EnumItem<number, SaveFilter, "SaveWorld">
	| EnumItem<number, SaveFilter, "SaveGame">
	| EnumItem<number, SaveFilter, "SaveAll">
export type SaveFilterRoot = EnumObject<{
	SaveWorld: EnumItem<number, SaveFilter, "SaveWorld">,
	SaveGame: EnumItem<number, SaveFilter, "SaveGame">,
	SaveAll: EnumItem<number, SaveFilter, "SaveAll">,
}, SaveFilter>
Enum.SaveFilter = {"SaveWorld", "SaveGame", "SaveAll"}

export type SavedQualitySetting =
	| EnumItem<number, SavedQualitySetting, "Automatic">
	| EnumItem<number, SavedQualitySetting, "QualityLevel1">
	| EnumItem<number, SavedQualitySetting, "QualityLevel2">
	| EnumItem<number, SavedQualitySetting, "QualityLevel3">
	| EnumItem<number, SavedQualitySetting, "QualityLevel4">
	| EnumItem<number, SavedQualitySetting, "QualityLevel5">
	| EnumItem<number, SavedQualitySetting, "QualityLevel6">
	| EnumItem<number, SavedQualitySetting, "QualityLevel7">
	| EnumItem<number, SavedQualitySetting, "QualityLevel8">
	| EnumItem<number, SavedQualitySetting, "QualityLevel9">
	| EnumItem<number, SavedQualitySetting, "QualityLevel10">
export type SavedQualitySettingRoot = EnumObject<{
	Automatic: EnumItem<number, SavedQualitySetting, "Automatic">,
	QualityLevel1: EnumItem<number, SavedQualitySetting, "QualityLevel1">,
	QualityLevel2: EnumItem<number, SavedQualitySetting, "QualityLevel2">,
	QualityLevel3: EnumItem<number, SavedQualitySetting, "QualityLevel3">,
	QualityLevel4: EnumItem<number, SavedQualitySetting, "QualityLevel4">,
	QualityLevel5: EnumItem<number, SavedQualitySetting, "QualityLevel5">,
	QualityLevel6: EnumItem<number, SavedQualitySetting, "QualityLevel6">,
	QualityLevel7: EnumItem<number, SavedQualitySetting, "QualityLevel7">,
	QualityLevel8: EnumItem<number, SavedQualitySetting, "QualityLevel8">,
	QualityLevel9: EnumItem<number, SavedQualitySetting, "QualityLevel9">,
	QualityLevel10: EnumItem<number, SavedQualitySetting, "QualityLevel10">,
}, SavedQualitySetting>
Enum.SavedQualitySetting = {
	"Automatic";
	"QualityLevel1";
	"QualityLevel2";
	"QualityLevel3";
	"QualityLevel4";
	"QualityLevel5";
	"QualityLevel6";
	"QualityLevel7";
	"QualityLevel8";
	"QualityLevel9";
	"QualityLevel10";
}

export type ScaleType =
	| EnumItem<number, ScaleType, "Stretch">
	| EnumItem<number, ScaleType, "Slice">
	| EnumItem<number, ScaleType, "Tile">
	| EnumItem<number, ScaleType, "Fit">
	| EnumItem<number, ScaleType, "Crop">
export type ScaleTypeRoot = EnumObject<{
	Stretch: EnumItem<number, ScaleType, "Stretch">,
	Slice: EnumItem<number, ScaleType, "Slice">,
	Tile: EnumItem<number, ScaleType, "Tile">,
	Fit: EnumItem<number, ScaleType, "Fit">,
	Crop: EnumItem<number, ScaleType, "Crop">,
}, ScaleType>
Enum.ScaleType = {"Stretch", "Slice", "Tile", "Fit", "Crop"}

export type ScopeCheckResult =
	| EnumItem<number, ScopeCheckResult, "ConsentAccepted">
	| EnumItem<number, ScopeCheckResult, "InvalidScopes">
	| EnumItem<number, ScopeCheckResult, "Timeout">
	| EnumItem<number, ScopeCheckResult, "NoUserInput">
	| EnumItem<number, ScopeCheckResult, "BackendError">
	| EnumItem<number, ScopeCheckResult, "UnexpectedError">
	| EnumItem<number, ScopeCheckResult, "InvalidArgument">
	| EnumItem<number, ScopeCheckResult, "ConsentDenied">
export type ScopeCheckResultRoot = EnumObject<{
	ConsentAccepted: EnumItem<number, ScopeCheckResult, "ConsentAccepted">,
	InvalidScopes: EnumItem<number, ScopeCheckResult, "InvalidScopes">,
	Timeout: EnumItem<number, ScopeCheckResult, "Timeout">,
	NoUserInput: EnumItem<number, ScopeCheckResult, "NoUserInput">,
	BackendError: EnumItem<number, ScopeCheckResult, "BackendError">,
	UnexpectedError: EnumItem<number, ScopeCheckResult, "UnexpectedError">,
	InvalidArgument: EnumItem<number, ScopeCheckResult, "InvalidArgument">,
	ConsentDenied: EnumItem<number, ScopeCheckResult, "ConsentDenied">,
}, ScopeCheckResult>
Enum.ScopeCheckResult = {
	"ConsentAccepted";
	"InvalidScopes";
	"Timeout";
	"NoUserInput";
	"BackendError";
	"UnexpectedError";
	"InvalidArgument";
	"ConsentDenied";
}

export type ScreenInsets =
	| EnumItem<number, ScreenInsets, "None">
	| EnumItem<number, ScreenInsets, "DeviceSafeInsets">
	| EnumItem<number, ScreenInsets, "CoreUISafeInsets">
	| EnumItem<number, ScreenInsets, "TopbarSafeInsets">
export type ScreenInsetsRoot = EnumObject<{
	None: EnumItem<number, ScreenInsets, "None">,
	DeviceSafeInsets: EnumItem<number, ScreenInsets, "DeviceSafeInsets">,
	CoreUISafeInsets: EnumItem<number, ScreenInsets, "CoreUISafeInsets">,
	TopbarSafeInsets: EnumItem<number, ScreenInsets, "TopbarSafeInsets">,
}, ScreenInsets>
Enum.ScreenInsets = {"None", "DeviceSafeInsets", "CoreUISafeInsets", "TopbarSafeInsets"}

export type ScreenOrientation =
	| EnumItem<number, ScreenOrientation, "LandscapeLeft">
	| EnumItem<number, ScreenOrientation, "LandscapeRight">
	| EnumItem<number, ScreenOrientation, "LandscapeSensor">
	| EnumItem<number, ScreenOrientation, "Portrait">
	| EnumItem<number, ScreenOrientation, "Sensor">
export type ScreenOrientationRoot = EnumObject<{
	LandscapeLeft: EnumItem<number, ScreenOrientation, "LandscapeLeft">,
	LandscapeRight: EnumItem<number, ScreenOrientation, "LandscapeRight">,
	LandscapeSensor: EnumItem<number, ScreenOrientation, "LandscapeSensor">,
	Portrait: EnumItem<number, ScreenOrientation, "Portrait">,
	Sensor: EnumItem<number, ScreenOrientation, "Sensor">,
}, ScreenOrientation>
Enum.ScreenOrientation = {"LandscapeLeft", "LandscapeRight", "LandscapeSensor", "Portrait", "Sensor"}

export type ScrollBarInset =
	| EnumItem<number, ScrollBarInset, "None">
	| EnumItem<number, ScrollBarInset, "ScrollBar">
	| EnumItem<number, ScrollBarInset, "Always">
export type ScrollBarInsetRoot = EnumObject<{
	None: EnumItem<number, ScrollBarInset, "None">,
	ScrollBar: EnumItem<number, ScrollBarInset, "ScrollBar">,
	Always: EnumItem<number, ScrollBarInset, "Always">,
}, ScrollBarInset>
Enum.ScrollBarInset = {"None", "ScrollBar", "Always"}

export type ScrollingDirection =
	| EnumItem<number, ScrollingDirection, "X">
	| EnumItem<number, ScrollingDirection, "Y">
	| EnumItem<number, ScrollingDirection, "XY">
export type ScrollingDirectionRoot = EnumObject<{
	X: EnumItem<number, ScrollingDirection, "X">,
	Y: EnumItem<number, ScrollingDirection, "Y">,
	XY: EnumItem<number, ScrollingDirection, "XY">,
}, ScrollingDirection>
Enum.ScrollingDirection = {
	X = 1;
	Y = 2;
	XY = 4;
}

export type SecurityCapability =
	| EnumItem<number, SecurityCapability, "RunClientScript">
	| EnumItem<number, SecurityCapability, "RunServerScript">
	| EnumItem<number, SecurityCapability, "AccessOutsideWrite">
	| EnumItem<number, SecurityCapability, "AssetRequire">
	| EnumItem<number, SecurityCapability, "LoadString">
	| EnumItem<number, SecurityCapability, "ScriptGlobals">
	| EnumItem<number, SecurityCapability, "CreateInstances">
	| EnumItem<number, SecurityCapability, "Basic">
	| EnumItem<number, SecurityCapability, "Audio">
	| EnumItem<number, SecurityCapability, "DataStore">
	| EnumItem<number, SecurityCapability, "Network">
	| EnumItem<number, SecurityCapability, "Physics">
	| EnumItem<number, SecurityCapability, "UI">
	| EnumItem<number, SecurityCapability, "CSG">
	| EnumItem<number, SecurityCapability, "Chat">
	| EnumItem<number, SecurityCapability, "Animation">
	| EnumItem<number, SecurityCapability, "Avatar">
	| EnumItem<number, SecurityCapability, "Input">
	| EnumItem<number, SecurityCapability, "Environment">
	| EnumItem<number, SecurityCapability, "RemoteEvent">
	| EnumItem<number, SecurityCapability, "LegacySound">
	| EnumItem<number, SecurityCapability, "Players">
	| EnumItem<number, SecurityCapability, "CapabilityControl">
export type SecurityCapabilityRoot = EnumObject<{
	RunClientScript: EnumItem<number, SecurityCapability, "RunClientScript">,
	RunServerScript: EnumItem<number, SecurityCapability, "RunServerScript">,
	AccessOutsideWrite: EnumItem<number, SecurityCapability, "AccessOutsideWrite">,
	AssetRequire: EnumItem<number, SecurityCapability, "AssetRequire">,
	LoadString: EnumItem<number, SecurityCapability, "LoadString">,
	ScriptGlobals: EnumItem<number, SecurityCapability, "ScriptGlobals">,
	CreateInstances: EnumItem<number, SecurityCapability, "CreateInstances">,
	Basic: EnumItem<number, SecurityCapability, "Basic">,
	Audio: EnumItem<number, SecurityCapability, "Audio">,
	DataStore: EnumItem<number, SecurityCapability, "DataStore">,
	Network: EnumItem<number, SecurityCapability, "Network">,
	Physics: EnumItem<number, SecurityCapability, "Physics">,
	UI: EnumItem<number, SecurityCapability, "UI">,
	CSG: EnumItem<number, SecurityCapability, "CSG">,
	Chat: EnumItem<number, SecurityCapability, "Chat">,
	Animation: EnumItem<number, SecurityCapability, "Animation">,
	Avatar: EnumItem<number, SecurityCapability, "Avatar">,
	Input: EnumItem<number, SecurityCapability, "Input">,
	Environment: EnumItem<number, SecurityCapability, "Environment">,
	RemoteEvent: EnumItem<number, SecurityCapability, "RemoteEvent">,
	LegacySound: EnumItem<number, SecurityCapability, "LegacySound">,
	Players: EnumItem<number, SecurityCapability, "Players">,
	CapabilityControl: EnumItem<number, SecurityCapability, "CapabilityControl">,
}, SecurityCapability>
Enum.SecurityCapability = {
	"RunClientScript";
	"RunServerScript";
	"AccessOutsideWrite";
	"AssetRequire";
	"LoadString";
	"ScriptGlobals";
	"CreateInstances";
	"Basic";
	"Audio";
	"DataStore";
	"Network";
	"Physics";
	"UI";
	"CSG";
	"Chat";
	"Animation";
	"Avatar";
	"Input";
	"Environment";
	"RemoteEvent";
	"LegacySound";
	"Players";
	"CapabilityControl";
}

export type SelectionBehavior =
	| EnumItem<number, SelectionBehavior, "Escape">
	| EnumItem<number, SelectionBehavior, "Stop">
export type SelectionBehaviorRoot = EnumObject<{
	Escape: EnumItem<number, SelectionBehavior, "Escape">,
	Stop: EnumItem<number, SelectionBehavior, "Stop">,
}, SelectionBehavior>
Enum.SelectionBehavior = {"Escape", "Stop"}

export type SelectionRenderMode =
	| EnumItem<number, SelectionRenderMode, "Outlines">
	| EnumItem<number, SelectionRenderMode, "BoundingBoxes">
	| EnumItem<number, SelectionRenderMode, "Both">
export type SelectionRenderModeRoot = EnumObject<{
	Outlines: EnumItem<number, SelectionRenderMode, "Outlines">,
	BoundingBoxes: EnumItem<number, SelectionRenderMode, "BoundingBoxes">,
	Both: EnumItem<number, SelectionRenderMode, "Both">,
}, SelectionRenderMode>
Enum.SelectionRenderMode = {"Outlines", "BoundingBoxes", "Both"}

export type SelfViewPosition =
	| EnumItem<number, SelfViewPosition, "LastPosition">
	| EnumItem<number, SelfViewPosition, "TopLeft">
	| EnumItem<number, SelfViewPosition, "TopRight">
	| EnumItem<number, SelfViewPosition, "BottomLeft">
	| EnumItem<number, SelfViewPosition, "BottomRight">
export type SelfViewPositionRoot = EnumObject<{
	LastPosition: EnumItem<number, SelfViewPosition, "LastPosition">,
	TopLeft: EnumItem<number, SelfViewPosition, "TopLeft">,
	TopRight: EnumItem<number, SelfViewPosition, "TopRight">,
	BottomLeft: EnumItem<number, SelfViewPosition, "BottomLeft">,
	BottomRight: EnumItem<number, SelfViewPosition, "BottomRight">,
}, SelfViewPosition>
Enum.SelfViewPosition = {"LastPosition", "TopLeft", "TopRight", "BottomLeft", "BottomRight"}

export type SensorMode = | EnumItem<number, SensorMode, "Floor"> | EnumItem<number, SensorMode, "Ladder">
export type SensorModeRoot = EnumObject<{
	Floor: EnumItem<number, SensorMode, "Floor">,
	Ladder: EnumItem<number, SensorMode, "Ladder">,
}, SensorMode>
Enum.SensorMode = {"Floor", "Ladder"}

export type SensorUpdateType =
	| EnumItem<number, SensorUpdateType, "OnRead">
	| EnumItem<number, SensorUpdateType, "Manual">
export type SensorUpdateTypeRoot = EnumObject<{
	OnRead: EnumItem<number, SensorUpdateType, "OnRead">,
	Manual: EnumItem<number, SensorUpdateType, "Manual">,
}, SensorUpdateType>
Enum.SensorUpdateType = {"OnRead", "Manual"}

export type ServerLiveEditingMode =
	| EnumItem<number, ServerLiveEditingMode, "Uninitialized">
	| EnumItem<number, ServerLiveEditingMode, "Enabled">
	| EnumItem<number, ServerLiveEditingMode, "Disabled">
export type ServerLiveEditingModeRoot = EnumObject<{
	Uninitialized: EnumItem<number, ServerLiveEditingMode, "Uninitialized">,
	Enabled: EnumItem<number, ServerLiveEditingMode, "Enabled">,
	Disabled: EnumItem<number, ServerLiveEditingMode, "Disabled">,
}, ServerLiveEditingMode>
Enum.ServerLiveEditingMode = {"Uninitialized", "Enabled", "Disabled"}

export type ServiceVisibility =
	| EnumItem<number, ServiceVisibility, "Always">
	| EnumItem<number, ServiceVisibility, "Off">
	| EnumItem<number, ServiceVisibility, "WithChildren">
export type ServiceVisibilityRoot = EnumObject<{
	Always: EnumItem<number, ServiceVisibility, "Always">,
	Off: EnumItem<number, ServiceVisibility, "Off">,
	WithChildren: EnumItem<number, ServiceVisibility, "WithChildren">,
}, ServiceVisibility>
Enum.ServiceVisibility = {"Always", "Off", "WithChildren"}

export type Severity =
	| EnumItem<number, Severity, "Error">
	| EnumItem<number, Severity, "Warning">
	| EnumItem<number, Severity, "Information">
	| EnumItem<number, Severity, "Hint">
export type SeverityRoot = EnumObject<{
	Error: EnumItem<number, Severity, "Error">,
	Warning: EnumItem<number, Severity, "Warning">,
	Information: EnumItem<number, Severity, "Information">,
	Hint: EnumItem<number, Severity, "Hint">,
}, Severity>
Enum.Severity = {
	Error = 1;
	Warning = 2;
	Information = 3;
	Hint = 4;
}

export type ShowAdResult =
	| EnumItem<number, ShowAdResult, "ShowCompleted">
	| EnumItem<number, ShowAdResult, "AdNotReady">
	| EnumItem<number, ShowAdResult, "AdAlreadyShowing">
	| EnumItem<number, ShowAdResult, "InternalError">
	| EnumItem<number, ShowAdResult, "ShowInterrupted">
	| EnumItem<number, ShowAdResult, "InsufficientMemory">
export type ShowAdResultRoot = EnumObject<{
	ShowCompleted: EnumItem<number, ShowAdResult, "ShowCompleted">,
	AdNotReady: EnumItem<number, ShowAdResult, "AdNotReady">,
	AdAlreadyShowing: EnumItem<number, ShowAdResult, "AdAlreadyShowing">,
	InternalError: EnumItem<number, ShowAdResult, "InternalError">,
	ShowInterrupted: EnumItem<number, ShowAdResult, "ShowInterrupted">,
	InsufficientMemory: EnumItem<number, ShowAdResult, "InsufficientMemory">,
}, ShowAdResult>
Enum.ShowAdResult = {
	ShowCompleted = 1;
	AdNotReady = 2;
	AdAlreadyShowing = 3;
	InternalError = 4;
	ShowInterrupted = 5;
	InsufficientMemory = 6;
}

export type SignalBehavior =
	| EnumItem<number, SignalBehavior, "Default">
	| EnumItem<number, SignalBehavior, "Immediate">
	| EnumItem<number, SignalBehavior, "Deferred">
	| EnumItem<number, SignalBehavior, "AncestryDeferred">
export type SignalBehaviorRoot = EnumObject<{
	Default: EnumItem<number, SignalBehavior, "Default">,
	Immediate: EnumItem<number, SignalBehavior, "Immediate">,
	Deferred: EnumItem<number, SignalBehavior, "Deferred">,
	AncestryDeferred: EnumItem<number, SignalBehavior, "AncestryDeferred">,
}, SignalBehavior>
Enum.SignalBehavior = {"Default", "Immediate", "Deferred", "AncestryDeferred"}

export type SizeConstraint =
	| EnumItem<number, SizeConstraint, "RelativeXY">
	| EnumItem<number, SizeConstraint, "RelativeXX">
	| EnumItem<number, SizeConstraint, "RelativeYY">
export type SizeConstraintRoot = EnumObject<{
	RelativeXY: EnumItem<number, SizeConstraint, "RelativeXY">,
	RelativeXX: EnumItem<number, SizeConstraint, "RelativeXX">,
	RelativeYY: EnumItem<number, SizeConstraint, "RelativeYY">,
}, SizeConstraint>
Enum.SizeConstraint = {"RelativeXY", "RelativeXX", "RelativeYY"}

export type SolverConvergenceMetricType =
	| EnumItem<number, SolverConvergenceMetricType, "IterationBased">
	| EnumItem<number, SolverConvergenceMetricType, "AlgorithmAgnostic">
export type SolverConvergenceMetricTypeRoot = EnumObject<{
	IterationBased: EnumItem<number, SolverConvergenceMetricType, "IterationBased">,
	AlgorithmAgnostic: EnumItem<number, SolverConvergenceMetricType, "AlgorithmAgnostic">,
}, SolverConvergenceMetricType>
Enum.SolverConvergenceMetricType = {"IterationBased", "AlgorithmAgnostic"}

export type SolverConvergenceVisualizationMode =
	| EnumItem<number, SolverConvergenceVisualizationMode, "Disabled">
	| EnumItem<number, SolverConvergenceVisualizationMode, "PerIsland">
	| EnumItem<number, SolverConvergenceVisualizationMode, "PerEdge">
export type SolverConvergenceVisualizationModeRoot = EnumObject<{
	Disabled: EnumItem<number, SolverConvergenceVisualizationMode, "Disabled">,
	PerIsland: EnumItem<number, SolverConvergenceVisualizationMode, "PerIsland">,
	PerEdge: EnumItem<number, SolverConvergenceVisualizationMode, "PerEdge">,
}, SolverConvergenceVisualizationMode>
Enum.SolverConvergenceVisualizationMode = {"Disabled", "PerIsland", "PerEdge"}

export type SortDirection = | EnumItem<number, SortDirection, "Ascending"> | EnumItem<number, SortDirection, "Descending">
export type SortDirectionRoot = EnumObject<{
	Ascending: EnumItem<number, SortDirection, "Ascending">,
	Descending: EnumItem<number, SortDirection, "Descending">,
}, SortDirection>
Enum.SortDirection = {"Ascending", "Descending"}

export type SortOrder =
	| EnumItem<number, SortOrder, "Name">
	| EnumItem<number, SortOrder, "Custom">
	| EnumItem<number, SortOrder, "LayoutOrder">
export type SortOrderRoot = EnumObject<{
	Name: EnumItem<number, SortOrder, "Name">,
	Custom: EnumItem<number, SortOrder, "Custom">,
	LayoutOrder: EnumItem<number, SortOrder, "LayoutOrder">,
}, SortOrder>
Enum.SortOrder = {"Name", "Custom", "LayoutOrder"}

export type SpecialKey =
	| EnumItem<number, SpecialKey, "Insert">
	| EnumItem<number, SpecialKey, "Home">
	| EnumItem<number, SpecialKey, "End">
	| EnumItem<number, SpecialKey, "PageUp">
	| EnumItem<number, SpecialKey, "PageDown">
	| EnumItem<number, SpecialKey, "ChatHotkey">
export type SpecialKeyRoot = EnumObject<{
	Insert: EnumItem<number, SpecialKey, "Insert">,
	Home: EnumItem<number, SpecialKey, "Home">,
	End: EnumItem<number, SpecialKey, "End">,
	PageUp: EnumItem<number, SpecialKey, "PageUp">,
	PageDown: EnumItem<number, SpecialKey, "PageDown">,
	ChatHotkey: EnumItem<number, SpecialKey, "ChatHotkey">,
}, SpecialKey>
Enum.SpecialKey = {"Insert", "Home", "End", "PageUp", "PageDown", "ChatHotkey"}

export type StartCorner =
	| EnumItem<number, StartCorner, "TopLeft">
	| EnumItem<number, StartCorner, "TopRight">
	| EnumItem<number, StartCorner, "BottomLeft">
	| EnumItem<number, StartCorner, "BottomRight">
export type StartCornerRoot = EnumObject<{
	TopLeft: EnumItem<number, StartCorner, "TopLeft">,
	TopRight: EnumItem<number, StartCorner, "TopRight">,
	BottomLeft: EnumItem<number, StartCorner, "BottomLeft">,
	BottomRight: EnumItem<number, StartCorner, "BottomRight">,
}, StartCorner>
Enum.StartCorner = {"TopLeft", "TopRight", "BottomLeft", "BottomRight"}

export type StateObjectFieldType =
	| EnumItem<number, StateObjectFieldType, "Boolean">
	| EnumItem<number, StateObjectFieldType, "CFrame">
	| EnumItem<number, StateObjectFieldType, "Color3">
	| EnumItem<number, StateObjectFieldType, "Float">
	| EnumItem<number, StateObjectFieldType, "Instance">
	| EnumItem<number, StateObjectFieldType, "Random">
	| EnumItem<number, StateObjectFieldType, "Vector2">
	| EnumItem<number, StateObjectFieldType, "Vector3">
	| EnumItem<number, StateObjectFieldType, "INVALID">
export type StateObjectFieldTypeRoot = EnumObject<{
	Boolean: EnumItem<number, StateObjectFieldType, "Boolean">,
	CFrame: EnumItem<number, StateObjectFieldType, "CFrame">,
	Color3: EnumItem<number, StateObjectFieldType, "Color3">,
	Float: EnumItem<number, StateObjectFieldType, "Float">,
	Instance: EnumItem<number, StateObjectFieldType, "Instance">,
	Random: EnumItem<number, StateObjectFieldType, "Random">,
	Vector2: EnumItem<number, StateObjectFieldType, "Vector2">,
	Vector3: EnumItem<number, StateObjectFieldType, "Vector3">,
	INVALID: EnumItem<number, StateObjectFieldType, "INVALID">,
}, StateObjectFieldType>
Enum.StateObjectFieldType =
	{"Boolean", "CFrame", "Color3", "Float", "Instance", "Random", "Vector2", "Vector3", "INVALID"}

export type Status = | EnumItem<number, Status, "Poison"> | EnumItem<number, Status, "Confusion">
export type StatusRoot = EnumObject<{
	Poison: EnumItem<number, Status, "Poison">,
	Confusion: EnumItem<number, Status, "Confusion">,
}, Status>
Enum.Status = {"Poison", "Confusion"}

export type StreamOutBehavior =
	| EnumItem<number, StreamOutBehavior, "Default">
	| EnumItem<number, StreamOutBehavior, "LowMemory">
	| EnumItem<number, StreamOutBehavior, "Opportunistic">
export type StreamOutBehaviorRoot = EnumObject<{
	Default: EnumItem<number, StreamOutBehavior, "Default">,
	LowMemory: EnumItem<number, StreamOutBehavior, "LowMemory">,
	Opportunistic: EnumItem<number, StreamOutBehavior, "Opportunistic">,
}, StreamOutBehavior>
Enum.StreamOutBehavior = {"Default", "LowMemory", "Opportunistic"}

export type StreamingIntegrityMode =
	| EnumItem<number, StreamingIntegrityMode, "Default">
	| EnumItem<number, StreamingIntegrityMode, "Disabled">
	| EnumItem<number, StreamingIntegrityMode, "MinimumRadiusPause">
	| EnumItem<number, StreamingIntegrityMode, "PauseOutsideLoadedArea">
export type StreamingIntegrityModeRoot = EnumObject<{
	Default: EnumItem<number, StreamingIntegrityMode, "Default">,
	Disabled: EnumItem<number, StreamingIntegrityMode, "Disabled">,
	MinimumRadiusPause: EnumItem<number, StreamingIntegrityMode, "MinimumRadiusPause">,
	PauseOutsideLoadedArea: EnumItem<number, StreamingIntegrityMode, "PauseOutsideLoadedArea">,
}, StreamingIntegrityMode>
Enum.StreamingIntegrityMode = {"Default", "Disabled", "MinimumRadiusPause", "PauseOutsideLoadedArea"}

export type StreamingPauseMode =
	| EnumItem<number, StreamingPauseMode, "Default">
	| EnumItem<number, StreamingPauseMode, "Disabled">
	| EnumItem<number, StreamingPauseMode, "ClientPhysicsPause">
export type StreamingPauseModeRoot = EnumObject<{
	Default: EnumItem<number, StreamingPauseMode, "Default">,
	Disabled: EnumItem<number, StreamingPauseMode, "Disabled">,
	ClientPhysicsPause: EnumItem<number, StreamingPauseMode, "ClientPhysicsPause">,
}, StreamingPauseMode>
Enum.StreamingPauseMode = {"Default", "Disabled", "ClientPhysicsPause"}

export type StudioCloseMode =
	| EnumItem<number, StudioCloseMode, "None">
	| EnumItem<number, StudioCloseMode, "CloseStudio">
	| EnumItem<number, StudioCloseMode, "CloseDoc">
	| EnumItem<number, StudioCloseMode, "LogOut">
export type StudioCloseModeRoot = EnumObject<{
	None: EnumItem<number, StudioCloseMode, "None">,
	CloseStudio: EnumItem<number, StudioCloseMode, "CloseStudio">,
	CloseDoc: EnumItem<number, StudioCloseMode, "CloseDoc">,
	LogOut: EnumItem<number, StudioCloseMode, "LogOut">,
}, StudioCloseMode>
Enum.StudioCloseMode = {"None", "CloseStudio", "CloseDoc", "LogOut"}

export type StudioDataModelType =
	| EnumItem<number, StudioDataModelType, "Edit">
	| EnumItem<number, StudioDataModelType, "PlayClient">
	| EnumItem<number, StudioDataModelType, "PlayServer">
	| EnumItem<number, StudioDataModelType, "Standalone">
	| EnumItem<number, StudioDataModelType, "None">
export type StudioDataModelTypeRoot = EnumObject<{
	Edit: EnumItem<number, StudioDataModelType, "Edit">,
	PlayClient: EnumItem<number, StudioDataModelType, "PlayClient">,
	PlayServer: EnumItem<number, StudioDataModelType, "PlayServer">,
	Standalone: EnumItem<number, StudioDataModelType, "Standalone">,
	None: EnumItem<number, StudioDataModelType, "None">,
}, StudioDataModelType>
Enum.StudioDataModelType = {"Edit", "PlayClient", "PlayServer", "Standalone", "None"}

export type StudioPlaceUpdateFailureReason =
	| EnumItem<number, StudioPlaceUpdateFailureReason, "Other">
	| EnumItem<number, StudioPlaceUpdateFailureReason, "TeamCreateConflict">
export type StudioPlaceUpdateFailureReasonRoot = EnumObject<{
	Other: EnumItem<number, StudioPlaceUpdateFailureReason, "Other">,
	TeamCreateConflict: EnumItem<number, StudioPlaceUpdateFailureReason, "TeamCreateConflict">,
}, StudioPlaceUpdateFailureReason>
Enum.StudioPlaceUpdateFailureReason = {"Other", "TeamCreateConflict"}

export type StudioScriptEditorColorCategories =
	| EnumItem<number, StudioScriptEditorColorCategories, "Default">
	| EnumItem<number, StudioScriptEditorColorCategories, "Operator">
	| EnumItem<number, StudioScriptEditorColorCategories, "Number">
	| EnumItem<number, StudioScriptEditorColorCategories, "String">
	| EnumItem<number, StudioScriptEditorColorCategories, "Comment">
	| EnumItem<number, StudioScriptEditorColorCategories, "Keyword">
	| EnumItem<number, StudioScriptEditorColorCategories, "Builtin">
	| EnumItem<number, StudioScriptEditorColorCategories, "Method">
	| EnumItem<number, StudioScriptEditorColorCategories, "Property">
	| EnumItem<number, StudioScriptEditorColorCategories, "Nil">
	| EnumItem<number, StudioScriptEditorColorCategories, "Bool">
	| EnumItem<number, StudioScriptEditorColorCategories, "Function">
	| EnumItem<number, StudioScriptEditorColorCategories, "Local">
	| EnumItem<number, StudioScriptEditorColorCategories, "Self">
	| EnumItem<number, StudioScriptEditorColorCategories, "LuauKeyword">
	| EnumItem<number, StudioScriptEditorColorCategories, "FunctionName">
	| EnumItem<number, StudioScriptEditorColorCategories, "TODO">
	| EnumItem<number, StudioScriptEditorColorCategories, "Background">
	| EnumItem<number, StudioScriptEditorColorCategories, "SelectionText">
	| EnumItem<number, StudioScriptEditorColorCategories, "SelectionBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "FindSelectionBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "MatchingWordBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "Warning">
	| EnumItem<number, StudioScriptEditorColorCategories, "Error">
	| EnumItem<number, StudioScriptEditorColorCategories, "Info">
	| EnumItem<number, StudioScriptEditorColorCategories, "Hint">
	| EnumItem<number, StudioScriptEditorColorCategories, "Whitespace">
	| EnumItem<number, StudioScriptEditorColorCategories, "ActiveLine">
	| EnumItem<number, StudioScriptEditorColorCategories, "DebuggerCurrentLine">
	| EnumItem<number, StudioScriptEditorColorCategories, "DebuggerErrorLine">
	| EnumItem<number, StudioScriptEditorColorCategories, "Ruler">
	| EnumItem<number, StudioScriptEditorColorCategories, "Bracket">
	| EnumItem<number, StudioScriptEditorColorCategories, "Type">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuPrimaryText">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuSecondaryText">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuSelectedText">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuSelectedBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuScrollbarBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuScrollbarHandle">
	| EnumItem<number, StudioScriptEditorColorCategories, "MenuBorder">
	| EnumItem<number, StudioScriptEditorColorCategories, "DocViewCodeBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayText">
	| EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayButtonBackground">
	| EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayButtonBackgroundHover">
	| EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayButtonBackgroundPressed">
	| EnumItem<number, StudioScriptEditorColorCategories, "IndentationRuler">
export type StudioScriptEditorColorCategoriesRoot = EnumObject<
	{
		Default: EnumItem<number, StudioScriptEditorColorCategories, "Default">,
		Operator: EnumItem<number, StudioScriptEditorColorCategories, "Operator">,
		Number: EnumItem<number, StudioScriptEditorColorCategories, "Number">,
		String: EnumItem<number, StudioScriptEditorColorCategories, "String">,
		Comment: EnumItem<number, StudioScriptEditorColorCategories, "Comment">,
		Keyword: EnumItem<number, StudioScriptEditorColorCategories, "Keyword">,
		Builtin: EnumItem<number, StudioScriptEditorColorCategories, "Builtin">,
		Method: EnumItem<number, StudioScriptEditorColorCategories, "Method">,
		Property: EnumItem<number, StudioScriptEditorColorCategories, "Property">,
		Nil: EnumItem<number, StudioScriptEditorColorCategories, "Nil">,
		Bool: EnumItem<number, StudioScriptEditorColorCategories, "Bool">,
		Function: EnumItem<number, StudioScriptEditorColorCategories, "Function">,
		Local: EnumItem<number, StudioScriptEditorColorCategories, "Local">,
		Self: EnumItem<number, StudioScriptEditorColorCategories, "Self">,
		LuauKeyword: EnumItem<number, StudioScriptEditorColorCategories, "LuauKeyword">,
		FunctionName: EnumItem<number, StudioScriptEditorColorCategories, "FunctionName">,
		TODO: EnumItem<number, StudioScriptEditorColorCategories, "TODO">,
		Background: EnumItem<number, StudioScriptEditorColorCategories, "Background">,
		SelectionText: EnumItem<number, StudioScriptEditorColorCategories, "SelectionText">,
		SelectionBackground: EnumItem<number, StudioScriptEditorColorCategories, "SelectionBackground">,
		FindSelectionBackground: EnumItem<number, StudioScriptEditorColorCategories, "FindSelectionBackground">,
		MatchingWordBackground: EnumItem<number, StudioScriptEditorColorCategories, "MatchingWordBackground">,
		Warning: EnumItem<number, StudioScriptEditorColorCategories, "Warning">,
		Error: EnumItem<number, StudioScriptEditorColorCategories, "Error">,
		Info: EnumItem<number, StudioScriptEditorColorCategories, "Info">,
		Hint: EnumItem<number, StudioScriptEditorColorCategories, "Hint">,
		Whitespace: EnumItem<number, StudioScriptEditorColorCategories, "Whitespace">,
		ActiveLine: EnumItem<number, StudioScriptEditorColorCategories, "ActiveLine">,
		DebuggerCurrentLine: EnumItem<number, StudioScriptEditorColorCategories, "DebuggerCurrentLine">,
		DebuggerErrorLine: EnumItem<number, StudioScriptEditorColorCategories, "DebuggerErrorLine">,
		Ruler: EnumItem<number, StudioScriptEditorColorCategories, "Ruler">,
		Bracket: EnumItem<number, StudioScriptEditorColorCategories, "Bracket">,
		Type: EnumItem<number, StudioScriptEditorColorCategories, "Type">,
		MenuPrimaryText: EnumItem<number, StudioScriptEditorColorCategories, "MenuPrimaryText">,
		MenuSecondaryText: EnumItem<number, StudioScriptEditorColorCategories, "MenuSecondaryText">,
		MenuSelectedText: EnumItem<number, StudioScriptEditorColorCategories, "MenuSelectedText">,
		MenuBackground: EnumItem<number, StudioScriptEditorColorCategories, "MenuBackground">,
		MenuSelectedBackground: EnumItem<number, StudioScriptEditorColorCategories, "MenuSelectedBackground">,
		MenuScrollbarBackground: EnumItem<number, StudioScriptEditorColorCategories, "MenuScrollbarBackground">,
		MenuScrollbarHandle: EnumItem<number, StudioScriptEditorColorCategories, "MenuScrollbarHandle">,
		MenuBorder: EnumItem<number, StudioScriptEditorColorCategories, "MenuBorder">,
		DocViewCodeBackground: EnumItem<number, StudioScriptEditorColorCategories, "DocViewCodeBackground">,
		AICOOverlayText: EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayText">,
		AICOOverlayButtonBackground: EnumItem<number, StudioScriptEditorColorCategories, "AICOOverlayButtonBackground">,
		AICOOverlayButtonBackgroundHover: EnumItem<
			number,
			StudioScriptEditorColorCategories,
			"AICOOverlayButtonBackgroundHover"
		>,
		AICOOverlayButtonBackgroundPressed: EnumItem<
			number,
			StudioScriptEditorColorCategories,
			"AICOOverlayButtonBackgroundPressed"
		>,
		IndentationRuler: EnumItem<number, StudioScriptEditorColorCategories, "IndentationRuler">,
	},
	StudioScriptEditorColorCategories
>
Enum.StudioScriptEditorColorCategories = {
	"Default";
	"Operator";
	"Number";
	"String";
	"Comment";
	"Keyword";
	"Builtin";
	"Method";
	"Property";
	"Nil";
	"Bool";
	"Function";
	"Local";
	"Self";
	"LuauKeyword";
	"FunctionName";
	"TODO";
	"Background";
	"SelectionText";
	"SelectionBackground";
	"FindSelectionBackground";
	"MatchingWordBackground";
	"Warning";
	"Error";
	"Info";
	"Hint";
	"Whitespace";
	"ActiveLine";
	"DebuggerCurrentLine";
	"DebuggerErrorLine";
	"Ruler";
	"Bracket";
	"Type";
	"MenuPrimaryText";
	"MenuSecondaryText";
	"MenuSelectedText";
	"MenuBackground";
	"MenuSelectedBackground";
	"MenuScrollbarBackground";
	"MenuScrollbarHandle";
	"MenuBorder";
	"DocViewCodeBackground";
	"AICOOverlayText";
	"AICOOverlayButtonBackground";
	"AICOOverlayButtonBackgroundHover";
	"AICOOverlayButtonBackgroundPressed";
	"IndentationRuler";
}

export type StudioScriptEditorColorPresets =
	| EnumItem<number, StudioScriptEditorColorPresets, "RobloxDefault">
	| EnumItem<number, StudioScriptEditorColorPresets, "Extra1">
	| EnumItem<number, StudioScriptEditorColorPresets, "Extra2">
	| EnumItem<number, StudioScriptEditorColorPresets, "Custom">
export type StudioScriptEditorColorPresetsRoot = EnumObject<{
	RobloxDefault: EnumItem<number, StudioScriptEditorColorPresets, "RobloxDefault">,
	Extra1: EnumItem<number, StudioScriptEditorColorPresets, "Extra1">,
	Extra2: EnumItem<number, StudioScriptEditorColorPresets, "Extra2">,
	Custom: EnumItem<number, StudioScriptEditorColorPresets, "Custom">,
}, StudioScriptEditorColorPresets>
Enum.StudioScriptEditorColorPresets = {"RobloxDefault", "Extra1", "Extra2", "Custom"}

export type StudioStyleGuideColor =
	| EnumItem<number, StudioStyleGuideColor, "MainBackground">
	| EnumItem<number, StudioStyleGuideColor, "Titlebar">
	| EnumItem<number, StudioStyleGuideColor, "Dropdown">
	| EnumItem<number, StudioStyleGuideColor, "Tooltip">
	| EnumItem<number, StudioStyleGuideColor, "Notification">
	| EnumItem<number, StudioStyleGuideColor, "ScrollBar">
	| EnumItem<number, StudioStyleGuideColor, "ScrollBarBackground">
	| EnumItem<number, StudioStyleGuideColor, "TabBar">
	| EnumItem<number, StudioStyleGuideColor, "Tab">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonDefault">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonHover">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonChecked">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonAccent">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonBorder">
	| EnumItem<number, StudioStyleGuideColor, "FilterButtonBorderAlt">
	| EnumItem<number, StudioStyleGuideColor, "RibbonTab">
	| EnumItem<number, StudioStyleGuideColor, "RibbonTabTopBar">
	| EnumItem<number, StudioStyleGuideColor, "Button">
	| EnumItem<number, StudioStyleGuideColor, "MainButton">
	| EnumItem<number, StudioStyleGuideColor, "RibbonButton">
	| EnumItem<number, StudioStyleGuideColor, "ViewPortBackground">
	| EnumItem<number, StudioStyleGuideColor, "InputFieldBackground">
	| EnumItem<number, StudioStyleGuideColor, "Item">
	| EnumItem<number, StudioStyleGuideColor, "TableItem">
	| EnumItem<number, StudioStyleGuideColor, "CategoryItem">
	| EnumItem<number, StudioStyleGuideColor, "GameSettingsTableItem">
	| EnumItem<number, StudioStyleGuideColor, "GameSettingsTooltip">
	| EnumItem<number, StudioStyleGuideColor, "EmulatorBar">
	| EnumItem<number, StudioStyleGuideColor, "EmulatorDropDown">
	| EnumItem<number, StudioStyleGuideColor, "ColorPickerFrame">
	| EnumItem<number, StudioStyleGuideColor, "CurrentMarker">
	| EnumItem<number, StudioStyleGuideColor, "Border">
	| EnumItem<number, StudioStyleGuideColor, "DropShadow">
	| EnumItem<number, StudioStyleGuideColor, "Shadow">
	| EnumItem<number, StudioStyleGuideColor, "Light">
	| EnumItem<number, StudioStyleGuideColor, "Dark">
	| EnumItem<number, StudioStyleGuideColor, "Mid">
	| EnumItem<number, StudioStyleGuideColor, "MainText">
	| EnumItem<number, StudioStyleGuideColor, "SubText">
	| EnumItem<number, StudioStyleGuideColor, "TitlebarText">
	| EnumItem<number, StudioStyleGuideColor, "BrightText">
	| EnumItem<number, StudioStyleGuideColor, "DimmedText">
	| EnumItem<number, StudioStyleGuideColor, "LinkText">
	| EnumItem<number, StudioStyleGuideColor, "WarningText">
	| EnumItem<number, StudioStyleGuideColor, "ErrorText">
	| EnumItem<number, StudioStyleGuideColor, "InfoText">
	| EnumItem<number, StudioStyleGuideColor, "SensitiveText">
	| EnumItem<number, StudioStyleGuideColor, "ScriptSideWidget">
	| EnumItem<number, StudioStyleGuideColor, "ScriptBackground">
	| EnumItem<number, StudioStyleGuideColor, "ScriptText">
	| EnumItem<number, StudioStyleGuideColor, "ScriptSelectionText">
	| EnumItem<number, StudioStyleGuideColor, "ScriptSelectionBackground">
	| EnumItem<number, StudioStyleGuideColor, "ScriptFindSelectionBackground">
	| EnumItem<number, StudioStyleGuideColor, "ScriptMatchingWordSelectionBackground">
	| EnumItem<number, StudioStyleGuideColor, "ScriptOperator">
	| EnumItem<number, StudioStyleGuideColor, "ScriptNumber">
	| EnumItem<number, StudioStyleGuideColor, "ScriptString">
	| EnumItem<number, StudioStyleGuideColor, "ScriptComment">
	| EnumItem<number, StudioStyleGuideColor, "ScriptKeyword">
	| EnumItem<number, StudioStyleGuideColor, "ScriptBuiltInFunction">
	| EnumItem<number, StudioStyleGuideColor, "ScriptWarning">
	| EnumItem<number, StudioStyleGuideColor, "ScriptError">
	| EnumItem<number, StudioStyleGuideColor, "ScriptInformation">
	| EnumItem<number, StudioStyleGuideColor, "ScriptHint">
	| EnumItem<number, StudioStyleGuideColor, "ScriptWhitespace">
	| EnumItem<number, StudioStyleGuideColor, "ScriptRuler">
	| EnumItem<number, StudioStyleGuideColor, "DocViewCodeBackground">
	| EnumItem<number, StudioStyleGuideColor, "DebuggerCurrentLine">
	| EnumItem<number, StudioStyleGuideColor, "DebuggerErrorLine">
	| EnumItem<number, StudioStyleGuideColor, "DiffFilePathText">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextHunkInfo">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextNoChange">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextAddition">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextDeletion">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextSeparatorBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextNoChangeBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextAdditionBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffTextDeletionBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNum">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumSeparatorBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumNoChangeBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumAdditionBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumDeletionBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffFilePathBackground">
	| EnumItem<number, StudioStyleGuideColor, "DiffFilePathBorder">
	| EnumItem<number, StudioStyleGuideColor, "ChatIncomingBgColor">
	| EnumItem<number, StudioStyleGuideColor, "ChatIncomingTextColor">
	| EnumItem<number, StudioStyleGuideColor, "ChatOutgoingBgColor">
	| EnumItem<number, StudioStyleGuideColor, "ChatOutgoingTextColor">
	| EnumItem<number, StudioStyleGuideColor, "ChatModeratedMessageColor">
	| EnumItem<number, StudioStyleGuideColor, "Separator">
	| EnumItem<number, StudioStyleGuideColor, "ButtonBorder">
	| EnumItem<number, StudioStyleGuideColor, "ButtonText">
	| EnumItem<number, StudioStyleGuideColor, "InputFieldBorder">
	| EnumItem<number, StudioStyleGuideColor, "CheckedFieldBackground">
	| EnumItem<number, StudioStyleGuideColor, "CheckedFieldBorder">
	| EnumItem<number, StudioStyleGuideColor, "CheckedFieldIndicator">
	| EnumItem<number, StudioStyleGuideColor, "HeaderSection">
	| EnumItem<number, StudioStyleGuideColor, "Midlight">
	| EnumItem<number, StudioStyleGuideColor, "StatusBar">
	| EnumItem<number, StudioStyleGuideColor, "DialogButton">
	| EnumItem<number, StudioStyleGuideColor, "DialogButtonText">
	| EnumItem<number, StudioStyleGuideColor, "DialogButtonBorder">
	| EnumItem<number, StudioStyleGuideColor, "DialogMainButton">
	| EnumItem<number, StudioStyleGuideColor, "DialogMainButtonText">
	| EnumItem<number, StudioStyleGuideColor, "InfoBarWarningBackground">
	| EnumItem<number, StudioStyleGuideColor, "InfoBarWarningText">
	| EnumItem<number, StudioStyleGuideColor, "ScriptEditorCurrentLine">
	| EnumItem<number, StudioStyleGuideColor, "ScriptMethod">
	| EnumItem<number, StudioStyleGuideColor, "ScriptProperty">
	| EnumItem<number, StudioStyleGuideColor, "ScriptNil">
	| EnumItem<number, StudioStyleGuideColor, "ScriptBool">
	| EnumItem<number, StudioStyleGuideColor, "ScriptFunction">
	| EnumItem<number, StudioStyleGuideColor, "ScriptLocal">
	| EnumItem<number, StudioStyleGuideColor, "ScriptSelf">
	| EnumItem<number, StudioStyleGuideColor, "ScriptLuauKeyword">
	| EnumItem<number, StudioStyleGuideColor, "ScriptFunctionName">
	| EnumItem<number, StudioStyleGuideColor, "ScriptTodo">
	| EnumItem<number, StudioStyleGuideColor, "ScriptBracket">
	| EnumItem<number, StudioStyleGuideColor, "AttributeCog">
	| EnumItem<number, StudioStyleGuideColor, "AICOOverlayText">
	| EnumItem<number, StudioStyleGuideColor, "AICOOverlayButtonBackground">
	| EnumItem<number, StudioStyleGuideColor, "AICOOverlayButtonBackgroundHover">
	| EnumItem<number, StudioStyleGuideColor, "AICOOverlayButtonBackgroundPressed">
	| EnumItem<number, StudioStyleGuideColor, "OnboardingCover">
	| EnumItem<number, StudioStyleGuideColor, "OnboardingHighlight">
	| EnumItem<number, StudioStyleGuideColor, "OnboardingShadow">
	| EnumItem<number, StudioStyleGuideColor, "BreakpointMarker">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumHover">
	| EnumItem<number, StudioStyleGuideColor, "DiffLineNumSeparatorBackgroundHover">
export type StudioStyleGuideColorRoot = EnumObject<
	{
		MainBackground: EnumItem<number, StudioStyleGuideColor, "MainBackground">,
		Titlebar: EnumItem<number, StudioStyleGuideColor, "Titlebar">,
		Dropdown: EnumItem<number, StudioStyleGuideColor, "Dropdown">,
		Tooltip: EnumItem<number, StudioStyleGuideColor, "Tooltip">,
		Notification: EnumItem<number, StudioStyleGuideColor, "Notification">,
		ScrollBar: EnumItem<number, StudioStyleGuideColor, "ScrollBar">,
		ScrollBarBackground: EnumItem<number, StudioStyleGuideColor, "ScrollBarBackground">,
		TabBar: EnumItem<number, StudioStyleGuideColor, "TabBar">,
		Tab: EnumItem<number, StudioStyleGuideColor, "Tab">,
		FilterButtonDefault: EnumItem<number, StudioStyleGuideColor, "FilterButtonDefault">,
		FilterButtonHover: EnumItem<number, StudioStyleGuideColor, "FilterButtonHover">,
		FilterButtonChecked: EnumItem<number, StudioStyleGuideColor, "FilterButtonChecked">,
		FilterButtonAccent: EnumItem<number, StudioStyleGuideColor, "FilterButtonAccent">,
		FilterButtonBorder: EnumItem<number, StudioStyleGuideColor, "FilterButtonBorder">,
		FilterButtonBorderAlt: EnumItem<number, StudioStyleGuideColor, "FilterButtonBorderAlt">,
		RibbonTab: EnumItem<number, StudioStyleGuideColor, "RibbonTab">,
		RibbonTabTopBar: EnumItem<number, StudioStyleGuideColor, "RibbonTabTopBar">,
		Button: EnumItem<number, StudioStyleGuideColor, "Button">,
		MainButton: EnumItem<number, StudioStyleGuideColor, "MainButton">,
		RibbonButton: EnumItem<number, StudioStyleGuideColor, "RibbonButton">,
		ViewPortBackground: EnumItem<number, StudioStyleGuideColor, "ViewPortBackground">,
		InputFieldBackground: EnumItem<number, StudioStyleGuideColor, "InputFieldBackground">,
		Item: EnumItem<number, StudioStyleGuideColor, "Item">,
		TableItem: EnumItem<number, StudioStyleGuideColor, "TableItem">,
		CategoryItem: EnumItem<number, StudioStyleGuideColor, "CategoryItem">,
		GameSettingsTableItem: EnumItem<number, StudioStyleGuideColor, "GameSettingsTableItem">,
		GameSettingsTooltip: EnumItem<number, StudioStyleGuideColor, "GameSettingsTooltip">,
		EmulatorBar: EnumItem<number, StudioStyleGuideColor, "EmulatorBar">,
		EmulatorDropDown: EnumItem<number, StudioStyleGuideColor, "EmulatorDropDown">,
		ColorPickerFrame: EnumItem<number, StudioStyleGuideColor, "ColorPickerFrame">,
		CurrentMarker: EnumItem<number, StudioStyleGuideColor, "CurrentMarker">,
		Border: EnumItem<number, StudioStyleGuideColor, "Border">,
		DropShadow: EnumItem<number, StudioStyleGuideColor, "DropShadow">,
		Shadow: EnumItem<number, StudioStyleGuideColor, "Shadow">,
		Light: EnumItem<number, StudioStyleGuideColor, "Light">,
		Dark: EnumItem<number, StudioStyleGuideColor, "Dark">,
		Mid: EnumItem<number, StudioStyleGuideColor, "Mid">,
		MainText: EnumItem<number, StudioStyleGuideColor, "MainText">,
		SubText: EnumItem<number, StudioStyleGuideColor, "SubText">,
		TitlebarText: EnumItem<number, StudioStyleGuideColor, "TitlebarText">,
		BrightText: EnumItem<number, StudioStyleGuideColor, "BrightText">,
		DimmedText: EnumItem<number, StudioStyleGuideColor, "DimmedText">,
		LinkText: EnumItem<number, StudioStyleGuideColor, "LinkText">,
		WarningText: EnumItem<number, StudioStyleGuideColor, "WarningText">,
		ErrorText: EnumItem<number, StudioStyleGuideColor, "ErrorText">,
		InfoText: EnumItem<number, StudioStyleGuideColor, "InfoText">,
		SensitiveText: EnumItem<number, StudioStyleGuideColor, "SensitiveText">,
		ScriptSideWidget: EnumItem<number, StudioStyleGuideColor, "ScriptSideWidget">,
		ScriptBackground: EnumItem<number, StudioStyleGuideColor, "ScriptBackground">,
		ScriptText: EnumItem<number, StudioStyleGuideColor, "ScriptText">,
		ScriptSelectionText: EnumItem<number, StudioStyleGuideColor, "ScriptSelectionText">,
		ScriptSelectionBackground: EnumItem<number, StudioStyleGuideColor, "ScriptSelectionBackground">,
		ScriptFindSelectionBackground: EnumItem<number, StudioStyleGuideColor, "ScriptFindSelectionBackground">,
		ScriptMatchingWordSelectionBackground: EnumItem<
			number,
			StudioStyleGuideColor,
			"ScriptMatchingWordSelectionBackground"
		>,
		ScriptOperator: EnumItem<number, StudioStyleGuideColor, "ScriptOperator">,
		ScriptNumber: EnumItem<number, StudioStyleGuideColor, "ScriptNumber">,
		ScriptString: EnumItem<number, StudioStyleGuideColor, "ScriptString">,
		ScriptComment: EnumItem<number, StudioStyleGuideColor, "ScriptComment">,
		ScriptKeyword: EnumItem<number, StudioStyleGuideColor, "ScriptKeyword">,
		ScriptBuiltInFunction: EnumItem<number, StudioStyleGuideColor, "ScriptBuiltInFunction">,
		ScriptWarning: EnumItem<number, StudioStyleGuideColor, "ScriptWarning">,
		ScriptError: EnumItem<number, StudioStyleGuideColor, "ScriptError">,
		ScriptInformation: EnumItem<number, StudioStyleGuideColor, "ScriptInformation">,
		ScriptHint: EnumItem<number, StudioStyleGuideColor, "ScriptHint">,
		ScriptWhitespace: EnumItem<number, StudioStyleGuideColor, "ScriptWhitespace">,
		ScriptRuler: EnumItem<number, StudioStyleGuideColor, "ScriptRuler">,
		DocViewCodeBackground: EnumItem<number, StudioStyleGuideColor, "DocViewCodeBackground">,
		DebuggerCurrentLine: EnumItem<number, StudioStyleGuideColor, "DebuggerCurrentLine">,
		DebuggerErrorLine: EnumItem<number, StudioStyleGuideColor, "DebuggerErrorLine">,
		DiffFilePathText: EnumItem<number, StudioStyleGuideColor, "DiffFilePathText">,
		DiffTextHunkInfo: EnumItem<number, StudioStyleGuideColor, "DiffTextHunkInfo">,
		DiffTextNoChange: EnumItem<number, StudioStyleGuideColor, "DiffTextNoChange">,
		DiffTextAddition: EnumItem<number, StudioStyleGuideColor, "DiffTextAddition">,
		DiffTextDeletion: EnumItem<number, StudioStyleGuideColor, "DiffTextDeletion">,
		DiffTextSeparatorBackground: EnumItem<number, StudioStyleGuideColor, "DiffTextSeparatorBackground">,
		DiffTextNoChangeBackground: EnumItem<number, StudioStyleGuideColor, "DiffTextNoChangeBackground">,
		DiffTextAdditionBackground: EnumItem<number, StudioStyleGuideColor, "DiffTextAdditionBackground">,
		DiffTextDeletionBackground: EnumItem<number, StudioStyleGuideColor, "DiffTextDeletionBackground">,
		DiffLineNum: EnumItem<number, StudioStyleGuideColor, "DiffLineNum">,
		DiffLineNumSeparatorBackground: EnumItem<number, StudioStyleGuideColor, "DiffLineNumSeparatorBackground">,
		DiffLineNumNoChangeBackground: EnumItem<number, StudioStyleGuideColor, "DiffLineNumNoChangeBackground">,
		DiffLineNumAdditionBackground: EnumItem<number, StudioStyleGuideColor, "DiffLineNumAdditionBackground">,
		DiffLineNumDeletionBackground: EnumItem<number, StudioStyleGuideColor, "DiffLineNumDeletionBackground">,
		DiffFilePathBackground: EnumItem<number, StudioStyleGuideColor, "DiffFilePathBackground">,
		DiffFilePathBorder: EnumItem<number, StudioStyleGuideColor, "DiffFilePathBorder">,
		ChatIncomingBgColor: EnumItem<number, StudioStyleGuideColor, "ChatIncomingBgColor">,
		ChatIncomingTextColor: EnumItem<number, StudioStyleGuideColor, "ChatIncomingTextColor">,
		ChatOutgoingBgColor: EnumItem<number, StudioStyleGuideColor, "ChatOutgoingBgColor">,
		ChatOutgoingTextColor: EnumItem<number, StudioStyleGuideColor, "ChatOutgoingTextColor">,
		ChatModeratedMessageColor: EnumItem<number, StudioStyleGuideColor, "ChatModeratedMessageColor">,
		Separator: EnumItem<number, StudioStyleGuideColor, "Separator">,
		ButtonBorder: EnumItem<number, StudioStyleGuideColor, "ButtonBorder">,
		ButtonText: EnumItem<number, StudioStyleGuideColor, "ButtonText">,
		InputFieldBorder: EnumItem<number, StudioStyleGuideColor, "InputFieldBorder">,
		CheckedFieldBackground: EnumItem<number, StudioStyleGuideColor, "CheckedFieldBackground">,
		CheckedFieldBorder: EnumItem<number, StudioStyleGuideColor, "CheckedFieldBorder">,
		CheckedFieldIndicator: EnumItem<number, StudioStyleGuideColor, "CheckedFieldIndicator">,
		HeaderSection: EnumItem<number, StudioStyleGuideColor, "HeaderSection">,
		Midlight: EnumItem<number, StudioStyleGuideColor, "Midlight">,
		StatusBar: EnumItem<number, StudioStyleGuideColor, "StatusBar">,
		DialogButton: EnumItem<number, StudioStyleGuideColor, "DialogButton">,
		DialogButtonText: EnumItem<number, StudioStyleGuideColor, "DialogButtonText">,
		DialogButtonBorder: EnumItem<number, StudioStyleGuideColor, "DialogButtonBorder">,
		DialogMainButton: EnumItem<number, StudioStyleGuideColor, "DialogMainButton">,
		DialogMainButtonText: EnumItem<number, StudioStyleGuideColor, "DialogMainButtonText">,
		InfoBarWarningBackground: EnumItem<number, StudioStyleGuideColor, "InfoBarWarningBackground">,
		InfoBarWarningText: EnumItem<number, StudioStyleGuideColor, "InfoBarWarningText">,
		ScriptEditorCurrentLine: EnumItem<number, StudioStyleGuideColor, "ScriptEditorCurrentLine">,
		ScriptMethod: EnumItem<number, StudioStyleGuideColor, "ScriptMethod">,
		ScriptProperty: EnumItem<number, StudioStyleGuideColor, "ScriptProperty">,
		ScriptNil: EnumItem<number, StudioStyleGuideColor, "ScriptNil">,
		ScriptBool: EnumItem<number, StudioStyleGuideColor, "ScriptBool">,
		ScriptFunction: EnumItem<number, StudioStyleGuideColor, "ScriptFunction">,
		ScriptLocal: EnumItem<number, StudioStyleGuideColor, "ScriptLocal">,
		ScriptSelf: EnumItem<number, StudioStyleGuideColor, "ScriptSelf">,
		ScriptLuauKeyword: EnumItem<number, StudioStyleGuideColor, "ScriptLuauKeyword">,
		ScriptFunctionName: EnumItem<number, StudioStyleGuideColor, "ScriptFunctionName">,
		ScriptTodo: EnumItem<number, StudioStyleGuideColor, "ScriptTodo">,
		ScriptBracket: EnumItem<number, StudioStyleGuideColor, "ScriptBracket">,
		AttributeCog: EnumItem<number, StudioStyleGuideColor, "AttributeCog">,
		AICOOverlayText: EnumItem<number, StudioStyleGuideColor, "AICOOverlayText">,
		AICOOverlayButtonBackground: EnumItem<number, StudioStyleGuideColor, "AICOOverlayButtonBackground">,
		AICOOverlayButtonBackgroundHover: EnumItem<number, StudioStyleGuideColor, "AICOOverlayButtonBackgroundHover">,
		AICOOverlayButtonBackgroundPressed: EnumItem<
			number,
			StudioStyleGuideColor,
			"AICOOverlayButtonBackgroundPressed"
		>,
		OnboardingCover: EnumItem<number, StudioStyleGuideColor, "OnboardingCover">,
		OnboardingHighlight: EnumItem<number, StudioStyleGuideColor, "OnboardingHighlight">,
		OnboardingShadow: EnumItem<number, StudioStyleGuideColor, "OnboardingShadow">,
		BreakpointMarker: EnumItem<number, StudioStyleGuideColor, "BreakpointMarker">,
		DiffLineNumHover: EnumItem<number, StudioStyleGuideColor, "DiffLineNumHover">,
		DiffLineNumSeparatorBackgroundHover: EnumItem<
			number,
			StudioStyleGuideColor,
			"DiffLineNumSeparatorBackgroundHover"
		>,
	},
	StudioStyleGuideColor
>
Enum.StudioStyleGuideColor = {
	MainBackground = 0;
	Titlebar = 1;
	Dropdown = 2;
	Tooltip = 3;
	Notification = 4;
	ScrollBar = 5;
	ScrollBarBackground = 6;
	TabBar = 7;
	Tab = 8;
	FilterButtonDefault = 9;
	FilterButtonHover = 10;
	FilterButtonChecked = 11;
	FilterButtonAccent = 12;
	FilterButtonBorder = 13;
	FilterButtonBorderAlt = 14;
	RibbonTab = 15;
	RibbonTabTopBar = 16;
	Button = 17;
	MainButton = 18;
	RibbonButton = 19;
	ViewPortBackground = 20;
	InputFieldBackground = 21;
	Item = 22;
	TableItem = 23;
	CategoryItem = 24;
	GameSettingsTableItem = 25;
	GameSettingsTooltip = 26;
	EmulatorBar = 27;
	EmulatorDropDown = 28;
	ColorPickerFrame = 29;
	CurrentMarker = 30;
	Border = 31;
	DropShadow = 32;
	Shadow = 33;
	Light = 34;
	Dark = 35;
	Mid = 36;
	MainText = 37;
	SubText = 38;
	TitlebarText = 39;
	BrightText = 40;
	DimmedText = 41;
	LinkText = 42;
	WarningText = 43;
	ErrorText = 44;
	InfoText = 45;
	SensitiveText = 46;
	ScriptSideWidget = 47;
	ScriptBackground = 48;
	ScriptText = 49;
	ScriptSelectionText = 50;
	ScriptSelectionBackground = 51;
	ScriptFindSelectionBackground = 52;
	ScriptMatchingWordSelectionBackground = 53;
	ScriptOperator = 54;
	ScriptNumber = 55;
	ScriptString = 56;
	ScriptComment = 57;
	ScriptKeyword = 58;
	ScriptBuiltInFunction = 59;
	ScriptWarning = 60;
	ScriptError = 61;
	ScriptInformation = 62;
	ScriptHint = 63;
	ScriptWhitespace = 64;
	ScriptRuler = 65;
	DocViewCodeBackground = 66;
	DebuggerCurrentLine = 67;
	DebuggerErrorLine = 68;
	DiffFilePathText = 69;
	DiffTextHunkInfo = 70;
	DiffTextNoChange = 71;
	DiffTextAddition = 72;
	DiffTextDeletion = 73;
	DiffTextSeparatorBackground = 74;
	DiffTextNoChangeBackground = 75;
	DiffTextAdditionBackground = 76;
	DiffTextDeletionBackground = 77;
	DiffLineNum = 78;
	DiffLineNumSeparatorBackground = 79;
	DiffLineNumNoChangeBackground = 80;
	DiffLineNumAdditionBackground = 81;
	DiffLineNumDeletionBackground = 82;
	DiffFilePathBackground = 83;
	DiffFilePathBorder = 84;
	ChatIncomingBgColor = 85;
	ChatIncomingTextColor = 86;
	ChatOutgoingBgColor = 87;
	ChatOutgoingTextColor = 88;
	ChatModeratedMessageColor = 89;
	Separator = 90;
	ButtonBorder = 91;
	ButtonText = 92;
	InputFieldBorder = 93;
	CheckedFieldBackground = 94;
	CheckedFieldBorder = 95;
	CheckedFieldIndicator = 96;
	HeaderSection = 97;
	Midlight = 98;
	StatusBar = 99;
	DialogButton = 100;
	DialogButtonText = 101;
	DialogButtonBorder = 102;
	DialogMainButton = 103;
	DialogMainButtonText = 104;
	InfoBarWarningBackground = 105;
	InfoBarWarningText = 106;
	ScriptEditorCurrentLine = 107;
	ScriptMethod = 108;
	ScriptProperty = 109;
	ScriptNil = 110;
	ScriptBool = 111;
	ScriptFunction = 112;
	ScriptLocal = 113;
	ScriptSelf = 114;
	ScriptLuauKeyword = 115;
	ScriptFunctionName = 116;
	ScriptTodo = 117;
	ScriptBracket = 118;
	AttributeCog = 119;
	AICOOverlayText = 128;
	AICOOverlayButtonBackground = 129;
	AICOOverlayButtonBackgroundHover = 130;
	AICOOverlayButtonBackgroundPressed = 131;
	OnboardingCover = 132;
	OnboardingHighlight = 133;
	OnboardingShadow = 134;
	BreakpointMarker = 136;
	DiffLineNumHover = 137;
	DiffLineNumSeparatorBackgroundHover = 138;
}

export type StudioStyleGuideModifier =
	| EnumItem<number, StudioStyleGuideModifier, "Default">
	| EnumItem<number, StudioStyleGuideModifier, "Selected">
	| EnumItem<number, StudioStyleGuideModifier, "Pressed">
	| EnumItem<number, StudioStyleGuideModifier, "Disabled">
	| EnumItem<number, StudioStyleGuideModifier, "Hover">
export type StudioStyleGuideModifierRoot = EnumObject<{
	Default: EnumItem<number, StudioStyleGuideModifier, "Default">,
	Selected: EnumItem<number, StudioStyleGuideModifier, "Selected">,
	Pressed: EnumItem<number, StudioStyleGuideModifier, "Pressed">,
	Disabled: EnumItem<number, StudioStyleGuideModifier, "Disabled">,
	Hover: EnumItem<number, StudioStyleGuideModifier, "Hover">,
}, StudioStyleGuideModifier>
Enum.StudioStyleGuideModifier = {"Default", "Selected", "Pressed", "Disabled", "Hover"}

export type Style =
	| EnumItem<number, Style, "AlternatingSupports">
	| EnumItem<number, Style, "BridgeStyleSupports">
	| EnumItem<number, Style, "NoSupports">
export type StyleRoot = EnumObject<{
	AlternatingSupports: EnumItem<number, Style, "AlternatingSupports">,
	BridgeStyleSupports: EnumItem<number, Style, "BridgeStyleSupports">,
	NoSupports: EnumItem<number, Style, "NoSupports">,
}, Style>
Enum.Style = {"AlternatingSupports", "BridgeStyleSupports", "NoSupports"}

export type SubscriptionExpirationReason =
	| EnumItem<number, SubscriptionExpirationReason, "ProductInactive">
	| EnumItem<number, SubscriptionExpirationReason, "ProductDeleted">
	| EnumItem<number, SubscriptionExpirationReason, "SubscriberCancelled">
	| EnumItem<number, SubscriptionExpirationReason, "SubscriberRefunded">
	| EnumItem<number, SubscriptionExpirationReason, "Lapsed">
export type SubscriptionExpirationReasonRoot = EnumObject<{
	ProductInactive: EnumItem<number, SubscriptionExpirationReason, "ProductInactive">,
	ProductDeleted: EnumItem<number, SubscriptionExpirationReason, "ProductDeleted">,
	SubscriberCancelled: EnumItem<number, SubscriptionExpirationReason, "SubscriberCancelled">,
	SubscriberRefunded: EnumItem<number, SubscriptionExpirationReason, "SubscriberRefunded">,
	Lapsed: EnumItem<number, SubscriptionExpirationReason, "Lapsed">,
}, SubscriptionExpirationReason>
Enum.SubscriptionExpirationReason =
	{"ProductInactive", "ProductDeleted", "SubscriberCancelled", "SubscriberRefunded", "Lapsed"}

export type SubscriptionPaymentStatus =
	| EnumItem<number, SubscriptionPaymentStatus, "Paid">
	| EnumItem<number, SubscriptionPaymentStatus, "Refunded">
export type SubscriptionPaymentStatusRoot = EnumObject<{
	Paid: EnumItem<number, SubscriptionPaymentStatus, "Paid">,
	Refunded: EnumItem<number, SubscriptionPaymentStatus, "Refunded">,
}, SubscriptionPaymentStatus>
Enum.SubscriptionPaymentStatus = {"Paid", "Refunded"}

export type SubscriptionPeriod = | EnumItem<number, SubscriptionPeriod, "Month">
export type SubscriptionPeriodRoot = EnumObject<{
	Month: EnumItem<number, SubscriptionPeriod, "Month">,
}, SubscriptionPeriod>
Enum.SubscriptionPeriod = {"Month"}

export type SubscriptionState =
	| EnumItem<number, SubscriptionState, "NeverSubscribed">
	| EnumItem<number, SubscriptionState, "SubscribedWillRenew">
	| EnumItem<number, SubscriptionState, "SubscribedWillNotRenew">
	| EnumItem<number, SubscriptionState, "SubscribedRenewalPaymentPending">
	| EnumItem<number, SubscriptionState, "Expired">
export type SubscriptionStateRoot = EnumObject<{
	NeverSubscribed: EnumItem<number, SubscriptionState, "NeverSubscribed">,
	SubscribedWillRenew: EnumItem<number, SubscriptionState, "SubscribedWillRenew">,
	SubscribedWillNotRenew: EnumItem<number, SubscriptionState, "SubscribedWillNotRenew">,
	SubscribedRenewalPaymentPending: EnumItem<number, SubscriptionState, "SubscribedRenewalPaymentPending">,
	Expired: EnumItem<number, SubscriptionState, "Expired">,
}, SubscriptionState>
Enum.SubscriptionState =
	{"NeverSubscribed", "SubscribedWillRenew", "SubscribedWillNotRenew", "SubscribedRenewalPaymentPending", "Expired"}

export type SurfaceConstraint =
	| EnumItem<number, SurfaceConstraint, "None">
	| EnumItem<number, SurfaceConstraint, "Hinge">
	| EnumItem<number, SurfaceConstraint, "SteppingMotor">
	| EnumItem<number, SurfaceConstraint, "Motor">
export type SurfaceConstraintRoot = EnumObject<{
	None: EnumItem<number, SurfaceConstraint, "None">,
	Hinge: EnumItem<number, SurfaceConstraint, "Hinge">,
	SteppingMotor: EnumItem<number, SurfaceConstraint, "SteppingMotor">,
	Motor: EnumItem<number, SurfaceConstraint, "Motor">,
}, SurfaceConstraint>
Enum.SurfaceConstraint = {"None", "Hinge", "SteppingMotor", "Motor"}

export type SurfaceGuiShape =
	| EnumItem<number, SurfaceGuiShape, "Flat">
	| EnumItem<number, SurfaceGuiShape, "CurvedHorizontally">
export type SurfaceGuiShapeRoot = EnumObject<{
	Flat: EnumItem<number, SurfaceGuiShape, "Flat">,
	CurvedHorizontally: EnumItem<number, SurfaceGuiShape, "CurvedHorizontally">,
}, SurfaceGuiShape>
Enum.SurfaceGuiShape = {"Flat", "CurvedHorizontally"}

export type SurfaceGuiSizingMode =
	| EnumItem<number, SurfaceGuiSizingMode, "FixedSize">
	| EnumItem<number, SurfaceGuiSizingMode, "PixelsPerStud">
export type SurfaceGuiSizingModeRoot = EnumObject<{
	FixedSize: EnumItem<number, SurfaceGuiSizingMode, "FixedSize">,
	PixelsPerStud: EnumItem<number, SurfaceGuiSizingMode, "PixelsPerStud">,
}, SurfaceGuiSizingMode>
Enum.SurfaceGuiSizingMode = {"FixedSize", "PixelsPerStud"}

export type SurfaceType =
	| EnumItem<number, SurfaceType, "Smooth">
	| EnumItem<number, SurfaceType, "Glue">
	| EnumItem<number, SurfaceType, "Weld">
	| EnumItem<number, SurfaceType, "Studs">
	| EnumItem<number, SurfaceType, "Inlet">
	| EnumItem<number, SurfaceType, "Universal">
	| EnumItem<number, SurfaceType, "Hinge">
	| EnumItem<number, SurfaceType, "Motor">
	| EnumItem<number, SurfaceType, "SteppingMotor">
	| EnumItem<number, SurfaceType, "SmoothNoOutlines">
export type SurfaceTypeRoot = EnumObject<{
	Smooth: EnumItem<number, SurfaceType, "Smooth">,
	Glue: EnumItem<number, SurfaceType, "Glue">,
	Weld: EnumItem<number, SurfaceType, "Weld">,
	Studs: EnumItem<number, SurfaceType, "Studs">,
	Inlet: EnumItem<number, SurfaceType, "Inlet">,
	Universal: EnumItem<number, SurfaceType, "Universal">,
	Hinge: EnumItem<number, SurfaceType, "Hinge">,
	Motor: EnumItem<number, SurfaceType, "Motor">,
	SteppingMotor: EnumItem<number, SurfaceType, "SteppingMotor">,
	SmoothNoOutlines: EnumItem<number, SurfaceType, "SmoothNoOutlines">,
}, SurfaceType>
Enum.SurfaceType = {
	Smooth = 0;
	Glue = 1;
	Weld = 2;
	Studs = 3;
	Inlet = 4;
	Universal = 5;
	Hinge = 6;
	Motor = 7;
	SteppingMotor = 8;
	SmoothNoOutlines = 10;
}

export type SwipeDirection =
	| EnumItem<number, SwipeDirection, "Right">
	| EnumItem<number, SwipeDirection, "Left">
	| EnumItem<number, SwipeDirection, "Up">
	| EnumItem<number, SwipeDirection, "Down">
	| EnumItem<number, SwipeDirection, "None">
export type SwipeDirectionRoot = EnumObject<{
	Right: EnumItem<number, SwipeDirection, "Right">,
	Left: EnumItem<number, SwipeDirection, "Left">,
	Up: EnumItem<number, SwipeDirection, "Up">,
	Down: EnumItem<number, SwipeDirection, "Down">,
	None: EnumItem<number, SwipeDirection, "None">,
}, SwipeDirection>
Enum.SwipeDirection = {"Right", "Left", "Up", "Down", "None"}

export type SystemThemeValue =
	| EnumItem<number, SystemThemeValue, "error">
	| EnumItem<number, SystemThemeValue, "light">
	| EnumItem<number, SystemThemeValue, "dark">
	| EnumItem<number, SystemThemeValue, "systemLight">
	| EnumItem<number, SystemThemeValue, "systemDark">
export type SystemThemeValueRoot = EnumObject<{
	error: EnumItem<number, SystemThemeValue, "error">,
	light: EnumItem<number, SystemThemeValue, "light">,
	dark: EnumItem<number, SystemThemeValue, "dark">,
	systemLight: EnumItem<number, SystemThemeValue, "systemLight">,
	systemDark: EnumItem<number, SystemThemeValue, "systemDark">,
}, SystemThemeValue>
Enum.SystemThemeValue = {"error", "light", "dark", "systemLight", "systemDark"}

export type TableMajorAxis =
	| EnumItem<number, TableMajorAxis, "RowMajor">
	| EnumItem<number, TableMajorAxis, "ColumnMajor">
export type TableMajorAxisRoot = EnumObject<{
	RowMajor: EnumItem<number, TableMajorAxis, "RowMajor">,
	ColumnMajor: EnumItem<number, TableMajorAxis, "ColumnMajor">,
}, TableMajorAxis>
Enum.TableMajorAxis = {"RowMajor", "ColumnMajor"}

export type TeamCreateErrorState =
	| EnumItem<number, TeamCreateErrorState, "PlaceSizeTooLarge">
	| EnumItem<number, TeamCreateErrorState, "PlaceSizeApproachingLimit">
	| EnumItem<number, TeamCreateErrorState, "NoError">
export type TeamCreateErrorStateRoot = EnumObject<{
	PlaceSizeTooLarge: EnumItem<number, TeamCreateErrorState, "PlaceSizeTooLarge">,
	PlaceSizeApproachingLimit: EnumItem<number, TeamCreateErrorState, "PlaceSizeApproachingLimit">,
	NoError: EnumItem<number, TeamCreateErrorState, "NoError">,
}, TeamCreateErrorState>
Enum.TeamCreateErrorState = {"PlaceSizeTooLarge", "PlaceSizeApproachingLimit", "NoError"}

export type Technology =
	| EnumItem<number, Technology, "Legacy">
	| EnumItem<number, Technology, "Voxel">
	| EnumItem<number, Technology, "Compatibility">
	| EnumItem<number, Technology, "ShadowMap">
	| EnumItem<number, Technology, "Future">
	| EnumItem<number, Technology, "Unified">
export type TechnologyRoot = EnumObject<{
	Legacy: EnumItem<number, Technology, "Legacy">,
	Voxel: EnumItem<number, Technology, "Voxel">,
	Compatibility: EnumItem<number, Technology, "Compatibility">,
	ShadowMap: EnumItem<number, Technology, "ShadowMap">,
	Future: EnumItem<number, Technology, "Future">,
	Unified: EnumItem<number, Technology, "Unified">,
}, Technology>
Enum.Technology = {"Legacy", "Voxel", "Compatibility", "ShadowMap", "Future", "Unified"}

export type TeleportMethod =
	| EnumItem<number, TeleportMethod, "TeleportToSpawnByName">
	| EnumItem<number, TeleportMethod, "TeleportToPlaceInstance">
	| EnumItem<number, TeleportMethod, "TeleportToPrivateServer">
	| EnumItem<number, TeleportMethod, "TeleportPartyAsync">
	| EnumItem<number, TeleportMethod, "TeleportToVIPServer">
	| EnumItem<number, TeleportMethod, "TeleportToInstanceBack">
	| EnumItem<number, TeleportMethod, "TeleportUnknown">
export type TeleportMethodRoot = EnumObject<{
	TeleportToSpawnByName: EnumItem<number, TeleportMethod, "TeleportToSpawnByName">,
	TeleportToPlaceInstance: EnumItem<number, TeleportMethod, "TeleportToPlaceInstance">,
	TeleportToPrivateServer: EnumItem<number, TeleportMethod, "TeleportToPrivateServer">,
	TeleportPartyAsync: EnumItem<number, TeleportMethod, "TeleportPartyAsync">,
	TeleportToVIPServer: EnumItem<number, TeleportMethod, "TeleportToVIPServer">,
	TeleportToInstanceBack: EnumItem<number, TeleportMethod, "TeleportToInstanceBack">,
	TeleportUnknown: EnumItem<number, TeleportMethod, "TeleportUnknown">,
}, TeleportMethod>
Enum.TeleportMethod = {
	"TeleportToSpawnByName";
	"TeleportToPlaceInstance";
	"TeleportToPrivateServer";
	"TeleportPartyAsync";
	"TeleportToVIPServer";
	"TeleportToInstanceBack";
	"TeleportUnknown";
}

export type TeleportResult =
	| EnumItem<number, TeleportResult, "Success">
	| EnumItem<number, TeleportResult, "Failure">
	| EnumItem<number, TeleportResult, "GameNotFound">
	| EnumItem<number, TeleportResult, "GameEnded">
	| EnumItem<number, TeleportResult, "GameFull">
	| EnumItem<number, TeleportResult, "Unauthorized">
	| EnumItem<number, TeleportResult, "Flooded">
	| EnumItem<number, TeleportResult, "IsTeleporting">
export type TeleportResultRoot = EnumObject<{
	Success: EnumItem<number, TeleportResult, "Success">,
	Failure: EnumItem<number, TeleportResult, "Failure">,
	GameNotFound: EnumItem<number, TeleportResult, "GameNotFound">,
	GameEnded: EnumItem<number, TeleportResult, "GameEnded">,
	GameFull: EnumItem<number, TeleportResult, "GameFull">,
	Unauthorized: EnumItem<number, TeleportResult, "Unauthorized">,
	Flooded: EnumItem<number, TeleportResult, "Flooded">,
	IsTeleporting: EnumItem<number, TeleportResult, "IsTeleporting">,
}, TeleportResult>
Enum.TeleportResult =
	{"Success", "Failure", "GameNotFound", "GameEnded", "GameFull", "Unauthorized", "Flooded", "IsTeleporting"}

export type TeleportState =
	| EnumItem<number, TeleportState, "RequestedFromServer">
	| EnumItem<number, TeleportState, "Started">
	| EnumItem<number, TeleportState, "WaitingForServer">
	| EnumItem<number, TeleportState, "Failed">
	| EnumItem<number, TeleportState, "InProgress">
export type TeleportStateRoot = EnumObject<{
	RequestedFromServer: EnumItem<number, TeleportState, "RequestedFromServer">,
	Started: EnumItem<number, TeleportState, "Started">,
	WaitingForServer: EnumItem<number, TeleportState, "WaitingForServer">,
	Failed: EnumItem<number, TeleportState, "Failed">,
	InProgress: EnumItem<number, TeleportState, "InProgress">,
}, TeleportState>
Enum.TeleportState = {"RequestedFromServer", "Started", "WaitingForServer", "Failed", "InProgress"}

export type TeleportType =
	| EnumItem<number, TeleportType, "ToPlace">
	| EnumItem<number, TeleportType, "ToInstance">
	| EnumItem<number, TeleportType, "ToReservedServer">
	| EnumItem<number, TeleportType, "ToVIPServer">
	| EnumItem<number, TeleportType, "ToInstanceBack">
export type TeleportTypeRoot = EnumObject<{
	ToPlace: EnumItem<number, TeleportType, "ToPlace">,
	ToInstance: EnumItem<number, TeleportType, "ToInstance">,
	ToReservedServer: EnumItem<number, TeleportType, "ToReservedServer">,
	ToVIPServer: EnumItem<number, TeleportType, "ToVIPServer">,
	ToInstanceBack: EnumItem<number, TeleportType, "ToInstanceBack">,
}, TeleportType>
Enum.TeleportType = {"ToPlace", "ToInstance", "ToReservedServer", "ToVIPServer", "ToInstanceBack"}

export type TerrainAcquisitionMethod =
	| EnumItem<number, TerrainAcquisitionMethod, "None">
	| EnumItem<number, TerrainAcquisitionMethod, "Legacy">
	| EnumItem<number, TerrainAcquisitionMethod, "Template">
	| EnumItem<number, TerrainAcquisitionMethod, "Generate">
	| EnumItem<number, TerrainAcquisitionMethod, "Import">
	| EnumItem<number, TerrainAcquisitionMethod, "Convert">
	| EnumItem<number, TerrainAcquisitionMethod, "EditAddTool">
	| EnumItem<number, TerrainAcquisitionMethod, "EditSeaLevelTool">
	| EnumItem<number, TerrainAcquisitionMethod, "EditReplaceTool">
	| EnumItem<number, TerrainAcquisitionMethod, "RegionFillTool">
	| EnumItem<number, TerrainAcquisitionMethod, "RegionPasteTool">
	| EnumItem<number, TerrainAcquisitionMethod, "Other">
export type TerrainAcquisitionMethodRoot = EnumObject<{
	None: EnumItem<number, TerrainAcquisitionMethod, "None">,
	Legacy: EnumItem<number, TerrainAcquisitionMethod, "Legacy">,
	Template: EnumItem<number, TerrainAcquisitionMethod, "Template">,
	Generate: EnumItem<number, TerrainAcquisitionMethod, "Generate">,
	Import: EnumItem<number, TerrainAcquisitionMethod, "Import">,
	Convert: EnumItem<number, TerrainAcquisitionMethod, "Convert">,
	EditAddTool: EnumItem<number, TerrainAcquisitionMethod, "EditAddTool">,
	EditSeaLevelTool: EnumItem<number, TerrainAcquisitionMethod, "EditSeaLevelTool">,
	EditReplaceTool: EnumItem<number, TerrainAcquisitionMethod, "EditReplaceTool">,
	RegionFillTool: EnumItem<number, TerrainAcquisitionMethod, "RegionFillTool">,
	RegionPasteTool: EnumItem<number, TerrainAcquisitionMethod, "RegionPasteTool">,
	Other: EnumItem<number, TerrainAcquisitionMethod, "Other">,
}, TerrainAcquisitionMethod>
Enum.TerrainAcquisitionMethod = {
	"None";
	"Legacy";
	"Template";
	"Generate";
	"Import";
	"Convert";
	"EditAddTool";
	"EditSeaLevelTool";
	"EditReplaceTool";
	"RegionFillTool";
	"RegionPasteTool";
	"Other";
}

export type TerrainFace =
	| EnumItem<number, TerrainFace, "Top">
	| EnumItem<number, TerrainFace, "Side">
	| EnumItem<number, TerrainFace, "Bottom">
export type TerrainFaceRoot = EnumObject<{
	Top: EnumItem<number, TerrainFace, "Top">,
	Side: EnumItem<number, TerrainFace, "Side">,
	Bottom: EnumItem<number, TerrainFace, "Bottom">,
}, TerrainFace>
Enum.TerrainFace = {"Top", "Side", "Bottom"}

export type TextChatMessageStatus =
	| EnumItem<number, TextChatMessageStatus, "Unknown">
	| EnumItem<number, TextChatMessageStatus, "Success">
	| EnumItem<number, TextChatMessageStatus, "Sending">
	| EnumItem<number, TextChatMessageStatus, "TextFilterFailed">
	| EnumItem<number, TextChatMessageStatus, "Floodchecked">
	| EnumItem<number, TextChatMessageStatus, "InvalidPrivacySettings">
	| EnumItem<number, TextChatMessageStatus, "InvalidTextChannelPermissions">
	| EnumItem<number, TextChatMessageStatus, "MessageTooLong">
	| EnumItem<number, TextChatMessageStatus, "ModerationTimeout">
export type TextChatMessageStatusRoot = EnumObject<{
	Unknown: EnumItem<number, TextChatMessageStatus, "Unknown">,
	Success: EnumItem<number, TextChatMessageStatus, "Success">,
	Sending: EnumItem<number, TextChatMessageStatus, "Sending">,
	TextFilterFailed: EnumItem<number, TextChatMessageStatus, "TextFilterFailed">,
	Floodchecked: EnumItem<number, TextChatMessageStatus, "Floodchecked">,
	InvalidPrivacySettings: EnumItem<number, TextChatMessageStatus, "InvalidPrivacySettings">,
	InvalidTextChannelPermissions: EnumItem<number, TextChatMessageStatus, "InvalidTextChannelPermissions">,
	MessageTooLong: EnumItem<number, TextChatMessageStatus, "MessageTooLong">,
	ModerationTimeout: EnumItem<number, TextChatMessageStatus, "ModerationTimeout">,
}, TextChatMessageStatus>
Enum.TextChatMessageStatus = {
	Unknown = 1;
	Success = 2;
	Sending = 3;
	TextFilterFailed = 4;
	Floodchecked = 5;
	InvalidPrivacySettings = 6;
	InvalidTextChannelPermissions = 7;
	MessageTooLong = 8;
	ModerationTimeout = 9;
}

export type TextDirection =
	| EnumItem<number, TextDirection, "Auto">
	| EnumItem<number, TextDirection, "LeftToRight">
	| EnumItem<number, TextDirection, "RightToLeft">
export type TextDirectionRoot = EnumObject<{
	Auto: EnumItem<number, TextDirection, "Auto">,
	LeftToRight: EnumItem<number, TextDirection, "LeftToRight">,
	RightToLeft: EnumItem<number, TextDirection, "RightToLeft">,
}, TextDirection>
Enum.TextDirection = {"Auto", "LeftToRight", "RightToLeft"}

export type TextFilterContext =
	| EnumItem<number, TextFilterContext, "PublicChat">
	| EnumItem<number, TextFilterContext, "PrivateChat">
export type TextFilterContextRoot = EnumObject<{
	PublicChat: EnumItem<number, TextFilterContext, "PublicChat">,
	PrivateChat: EnumItem<number, TextFilterContext, "PrivateChat">,
}, TextFilterContext>
Enum.TextFilterContext = {
	PublicChat = 1;
	PrivateChat = 2;
}

export type TextInputType =
	| EnumItem<number, TextInputType, "Default">
	| EnumItem<number, TextInputType, "NoSuggestions">
	| EnumItem<number, TextInputType, "Number">
	| EnumItem<number, TextInputType, "Email">
	| EnumItem<number, TextInputType, "Phone">
	| EnumItem<number, TextInputType, "Password">
	| EnumItem<number, TextInputType, "PasswordShown">
	| EnumItem<number, TextInputType, "Username">
	| EnumItem<number, TextInputType, "OneTimePassword">
export type TextInputTypeRoot = EnumObject<{
	Default: EnumItem<number, TextInputType, "Default">,
	NoSuggestions: EnumItem<number, TextInputType, "NoSuggestions">,
	Number: EnumItem<number, TextInputType, "Number">,
	Email: EnumItem<number, TextInputType, "Email">,
	Phone: EnumItem<number, TextInputType, "Phone">,
	Password: EnumItem<number, TextInputType, "Password">,
	PasswordShown: EnumItem<number, TextInputType, "PasswordShown">,
	Username: EnumItem<number, TextInputType, "Username">,
	OneTimePassword: EnumItem<number, TextInputType, "OneTimePassword">,
}, TextInputType>
Enum.TextInputType = {
	"Default";
	"NoSuggestions";
	"Number";
	"Email";
	"Phone";
	"Password";
	"PasswordShown";
	"Username";
	"OneTimePassword";
}

export type TextTruncate =
	| EnumItem<number, TextTruncate, "None">
	| EnumItem<number, TextTruncate, "AtEnd">
	| EnumItem<number, TextTruncate, "SplitWord">
export type TextTruncateRoot = EnumObject<{
	None: EnumItem<number, TextTruncate, "None">,
	AtEnd: EnumItem<number, TextTruncate, "AtEnd">,
	SplitWord: EnumItem<number, TextTruncate, "SplitWord">,
}, TextTruncate>
Enum.TextTruncate = {"None", "AtEnd", "SplitWord"}

export type TextXAlignment =
	| EnumItem<number, TextXAlignment, "Left">
	| EnumItem<number, TextXAlignment, "Right">
	| EnumItem<number, TextXAlignment, "Center">
export type TextXAlignmentRoot = EnumObject<{
	Left: EnumItem<number, TextXAlignment, "Left">,
	Right: EnumItem<number, TextXAlignment, "Right">,
	Center: EnumItem<number, TextXAlignment, "Center">,
}, TextXAlignment>
Enum.TextXAlignment = {"Left", "Right", "Center"}

export type TextYAlignment =
	| EnumItem<number, TextYAlignment, "Top">
	| EnumItem<number, TextYAlignment, "Center">
	| EnumItem<number, TextYAlignment, "Bottom">
export type TextYAlignmentRoot = EnumObject<{
	Top: EnumItem<number, TextYAlignment, "Top">,
	Center: EnumItem<number, TextYAlignment, "Center">,
	Bottom: EnumItem<number, TextYAlignment, "Bottom">,
}, TextYAlignment>
Enum.TextYAlignment = {"Top", "Center", "Bottom"}

export type TextureMode =
	| EnumItem<number, TextureMode, "Stretch">
	| EnumItem<number, TextureMode, "Wrap">
	| EnumItem<number, TextureMode, "Static">
export type TextureModeRoot = EnumObject<{
	Stretch: EnumItem<number, TextureMode, "Stretch">,
	Wrap: EnumItem<number, TextureMode, "Wrap">,
	Static: EnumItem<number, TextureMode, "Static">,
}, TextureMode>
Enum.TextureMode = {"Stretch", "Wrap", "Static"}

export type TextureQueryType =
	| EnumItem<number, TextureQueryType, "NonHumanoid">
	| EnumItem<number, TextureQueryType, "NonHumanoidOrphaned">
	| EnumItem<number, TextureQueryType, "Humanoid">
	| EnumItem<number, TextureQueryType, "HumanoidOrphaned">
export type TextureQueryTypeRoot = EnumObject<{
	NonHumanoid: EnumItem<number, TextureQueryType, "NonHumanoid">,
	NonHumanoidOrphaned: EnumItem<number, TextureQueryType, "NonHumanoidOrphaned">,
	Humanoid: EnumItem<number, TextureQueryType, "Humanoid">,
	HumanoidOrphaned: EnumItem<number, TextureQueryType, "HumanoidOrphaned">,
}, TextureQueryType>
Enum.TextureQueryType = {"NonHumanoid", "NonHumanoidOrphaned", "Humanoid", "HumanoidOrphaned"}

export type ThreadPoolConfig =
	| EnumItem<number, ThreadPoolConfig, "Auto">
	| EnumItem<number, ThreadPoolConfig, "Threads1">
	| EnumItem<number, ThreadPoolConfig, "Threads2">
	| EnumItem<number, ThreadPoolConfig, "Threads3">
	| EnumItem<number, ThreadPoolConfig, "Threads4">
	| EnumItem<number, ThreadPoolConfig, "Threads8">
	| EnumItem<number, ThreadPoolConfig, "Threads16">
	| EnumItem<number, ThreadPoolConfig, "PerCore1">
	| EnumItem<number, ThreadPoolConfig, "PerCore2">
	| EnumItem<number, ThreadPoolConfig, "PerCore3">
	| EnumItem<number, ThreadPoolConfig, "PerCore4">
export type ThreadPoolConfigRoot = EnumObject<{
	Auto: EnumItem<number, ThreadPoolConfig, "Auto">,
	Threads1: EnumItem<number, ThreadPoolConfig, "Threads1">,
	Threads2: EnumItem<number, ThreadPoolConfig, "Threads2">,
	Threads3: EnumItem<number, ThreadPoolConfig, "Threads3">,
	Threads4: EnumItem<number, ThreadPoolConfig, "Threads4">,
	Threads8: EnumItem<number, ThreadPoolConfig, "Threads8">,
	Threads16: EnumItem<number, ThreadPoolConfig, "Threads16">,
	PerCore1: EnumItem<number, ThreadPoolConfig, "PerCore1">,
	PerCore2: EnumItem<number, ThreadPoolConfig, "PerCore2">,
	PerCore3: EnumItem<number, ThreadPoolConfig, "PerCore3">,
	PerCore4: EnumItem<number, ThreadPoolConfig, "PerCore4">,
}, ThreadPoolConfig>
Enum.ThreadPoolConfig = {
	Auto = 0;
	Threads1 = 1;
	Threads2 = 2;
	Threads3 = 3;
	Threads4 = 4;
	Threads8 = 8;
	Threads16 = 16;
	PerCore1 = 101;
	PerCore2 = 102;
	PerCore3 = 103;
	PerCore4 = 104;
}

export type ThrottlingPriority =
	| EnumItem<number, ThrottlingPriority, "Default">
	| EnumItem<number, ThrottlingPriority, "ElevatedOnServer">
	| EnumItem<number, ThrottlingPriority, "Extreme">
export type ThrottlingPriorityRoot = EnumObject<{
	Default: EnumItem<number, ThrottlingPriority, "Default">,
	ElevatedOnServer: EnumItem<number, ThrottlingPriority, "ElevatedOnServer">,
	Extreme: EnumItem<number, ThrottlingPriority, "Extreme">,
}, ThrottlingPriority>
Enum.ThrottlingPriority = {"Default", "ElevatedOnServer", "Extreme"}

export type ThumbnailSize =
	| EnumItem<number, ThumbnailSize, "Size48x48">
	| EnumItem<number, ThumbnailSize, "Size180x180">
	| EnumItem<number, ThumbnailSize, "Size420x420">
	| EnumItem<number, ThumbnailSize, "Size60x60">
	| EnumItem<number, ThumbnailSize, "Size100x100">
	| EnumItem<number, ThumbnailSize, "Size150x150">
	| EnumItem<number, ThumbnailSize, "Size352x352">
export type ThumbnailSizeRoot = EnumObject<{
	Size48x48: EnumItem<number, ThumbnailSize, "Size48x48">,
	Size180x180: EnumItem<number, ThumbnailSize, "Size180x180">,
	Size420x420: EnumItem<number, ThumbnailSize, "Size420x420">,
	Size60x60: EnumItem<number, ThumbnailSize, "Size60x60">,
	Size100x100: EnumItem<number, ThumbnailSize, "Size100x100">,
	Size150x150: EnumItem<number, ThumbnailSize, "Size150x150">,
	Size352x352: EnumItem<number, ThumbnailSize, "Size352x352">,
}, ThumbnailSize>
Enum.ThumbnailSize =
	{"Size48x48", "Size180x180", "Size420x420", "Size60x60", "Size100x100", "Size150x150", "Size352x352"}

export type ThumbnailType =
	| EnumItem<number, ThumbnailType, "HeadShot">
	| EnumItem<number, ThumbnailType, "AvatarBust">
	| EnumItem<number, ThumbnailType, "AvatarThumbnail">
export type ThumbnailTypeRoot = EnumObject<{
	HeadShot: EnumItem<number, ThumbnailType, "HeadShot">,
	AvatarBust: EnumItem<number, ThumbnailType, "AvatarBust">,
	AvatarThumbnail: EnumItem<number, ThumbnailType, "AvatarThumbnail">,
}, ThumbnailType>
Enum.ThumbnailType = {"HeadShot", "AvatarBust", "AvatarThumbnail"}

export type TickCountSampleMethod =
	| EnumItem<number, TickCountSampleMethod, "Fast">
	| EnumItem<number, TickCountSampleMethod, "Benchmark">
	| EnumItem<number, TickCountSampleMethod, "Precise">
export type TickCountSampleMethodRoot = EnumObject<{
	Fast: EnumItem<number, TickCountSampleMethod, "Fast">,
	Benchmark: EnumItem<number, TickCountSampleMethod, "Benchmark">,
	Precise: EnumItem<number, TickCountSampleMethod, "Precise">,
}, TickCountSampleMethod>
Enum.TickCountSampleMethod = {"Fast", "Benchmark", "Precise"}

export type TonemapperPreset =
	| EnumItem<number, TonemapperPreset, "Default">
	| EnumItem<number, TonemapperPreset, "Retro">
export type TonemapperPresetRoot = EnumObject<{
	Default: EnumItem<number, TonemapperPreset, "Default">,
	Retro: EnumItem<number, TonemapperPreset, "Retro">,
}, TonemapperPreset>
Enum.TonemapperPreset = {"Default", "Retro"}

export type TopBottom =
	| EnumItem<number, TopBottom, "Top">
	| EnumItem<number, TopBottom, "Center">
	| EnumItem<number, TopBottom, "Bottom">
export type TopBottomRoot = EnumObject<{
	Top: EnumItem<number, TopBottom, "Top">,
	Center: EnumItem<number, TopBottom, "Center">,
	Bottom: EnumItem<number, TopBottom, "Bottom">,
}, TopBottom>
Enum.TopBottom = {"Top", "Center", "Bottom"}

export type TouchCameraMovementMode =
	| EnumItem<number, TouchCameraMovementMode, "Default">
	| EnumItem<number, TouchCameraMovementMode, "Classic">
	| EnumItem<number, TouchCameraMovementMode, "Follow">
	| EnumItem<number, TouchCameraMovementMode, "Orbital">
export type TouchCameraMovementModeRoot = EnumObject<{
	Default: EnumItem<number, TouchCameraMovementMode, "Default">,
	Classic: EnumItem<number, TouchCameraMovementMode, "Classic">,
	Follow: EnumItem<number, TouchCameraMovementMode, "Follow">,
	Orbital: EnumItem<number, TouchCameraMovementMode, "Orbital">,
}, TouchCameraMovementMode>
Enum.TouchCameraMovementMode = {"Default", "Classic", "Follow", "Orbital"}

export type TouchMovementMode =
	| EnumItem<number, TouchMovementMode, "Default">
	| EnumItem<number, TouchMovementMode, "Thumbstick">
	| EnumItem<number, TouchMovementMode, "DPad">
	| EnumItem<number, TouchMovementMode, "Thumbpad">
	| EnumItem<number, TouchMovementMode, "ClickToMove">
	| EnumItem<number, TouchMovementMode, "DynamicThumbstick">
export type TouchMovementModeRoot = EnumObject<{
	Default: EnumItem<number, TouchMovementMode, "Default">,
	Thumbstick: EnumItem<number, TouchMovementMode, "Thumbstick">,
	DPad: EnumItem<number, TouchMovementMode, "DPad">,
	Thumbpad: EnumItem<number, TouchMovementMode, "Thumbpad">,
	ClickToMove: EnumItem<number, TouchMovementMode, "ClickToMove">,
	DynamicThumbstick: EnumItem<number, TouchMovementMode, "DynamicThumbstick">,
}, TouchMovementMode>
Enum.TouchMovementMode = {"Default", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "DynamicThumbstick"}

export type TrackerError =
	| EnumItem<number, TrackerError, "Ok">
	| EnumItem<number, TrackerError, "NoService">
	| EnumItem<number, TrackerError, "InitFailed">
	| EnumItem<number, TrackerError, "NoVideo">
	| EnumItem<number, TrackerError, "VideoError">
	| EnumItem<number, TrackerError, "VideoNoPermission">
	| EnumItem<number, TrackerError, "VideoUnsupported">
	| EnumItem<number, TrackerError, "NoAudio">
	| EnumItem<number, TrackerError, "AudioError">
	| EnumItem<number, TrackerError, "AudioNoPermission">
	| EnumItem<number, TrackerError, "UnsupportedDevice">
export type TrackerErrorRoot = EnumObject<{
	Ok: EnumItem<number, TrackerError, "Ok">,
	NoService: EnumItem<number, TrackerError, "NoService">,
	InitFailed: EnumItem<number, TrackerError, "InitFailed">,
	NoVideo: EnumItem<number, TrackerError, "NoVideo">,
	VideoError: EnumItem<number, TrackerError, "VideoError">,
	VideoNoPermission: EnumItem<number, TrackerError, "VideoNoPermission">,
	VideoUnsupported: EnumItem<number, TrackerError, "VideoUnsupported">,
	NoAudio: EnumItem<number, TrackerError, "NoAudio">,
	AudioError: EnumItem<number, TrackerError, "AudioError">,
	AudioNoPermission: EnumItem<number, TrackerError, "AudioNoPermission">,
	UnsupportedDevice: EnumItem<number, TrackerError, "UnsupportedDevice">,
}, TrackerError>
Enum.TrackerError = {
	"Ok";
	"NoService";
	"InitFailed";
	"NoVideo";
	"VideoError";
	"VideoNoPermission";
	"VideoUnsupported";
	"NoAudio";
	"AudioError";
	"AudioNoPermission";
	"UnsupportedDevice";
}

export type TrackerExtrapolationFlagMode =
	| EnumItem<number, TrackerExtrapolationFlagMode, "ForceDisabled">
	| EnumItem<number, TrackerExtrapolationFlagMode, "ExtrapolateFacsAndPose">
	| EnumItem<number, TrackerExtrapolationFlagMode, "ExtrapolateFacsOnly">
	| EnumItem<number, TrackerExtrapolationFlagMode, "Auto">
export type TrackerExtrapolationFlagModeRoot = EnumObject<{
	ForceDisabled: EnumItem<number, TrackerExtrapolationFlagMode, "ForceDisabled">,
	ExtrapolateFacsAndPose: EnumItem<number, TrackerExtrapolationFlagMode, "ExtrapolateFacsAndPose">,
	ExtrapolateFacsOnly: EnumItem<number, TrackerExtrapolationFlagMode, "ExtrapolateFacsOnly">,
	Auto: EnumItem<number, TrackerExtrapolationFlagMode, "Auto">,
}, TrackerExtrapolationFlagMode>
Enum.TrackerExtrapolationFlagMode = {"ForceDisabled", "ExtrapolateFacsAndPose", "ExtrapolateFacsOnly", "Auto"}

export type TrackerFaceTrackingStatus =
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingSuccess">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingNoFaceFound">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingUnknown">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingLost">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingHasTrackingError">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingIsOccluded">
	| EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingUninitialized">
export type TrackerFaceTrackingStatusRoot = EnumObject<{
	FaceTrackingSuccess: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingSuccess">,
	FaceTrackingNoFaceFound: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingNoFaceFound">,
	FaceTrackingUnknown: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingUnknown">,
	FaceTrackingLost: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingLost">,
	FaceTrackingHasTrackingError: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingHasTrackingError">,
	FaceTrackingIsOccluded: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingIsOccluded">,
	FaceTrackingUninitialized: EnumItem<number, TrackerFaceTrackingStatus, "FaceTrackingUninitialized">,
}, TrackerFaceTrackingStatus>
Enum.TrackerFaceTrackingStatus = {
	"FaceTrackingSuccess";
	"FaceTrackingNoFaceFound";
	"FaceTrackingUnknown";
	"FaceTrackingLost";
	"FaceTrackingHasTrackingError";
	"FaceTrackingIsOccluded";
	"FaceTrackingUninitialized";
}

export type TrackerLodFlagMode =
	| EnumItem<number, TrackerLodFlagMode, "ForceFalse">
	| EnumItem<number, TrackerLodFlagMode, "ForceTrue">
	| EnumItem<number, TrackerLodFlagMode, "Auto">
export type TrackerLodFlagModeRoot = EnumObject<{
	ForceFalse: EnumItem<number, TrackerLodFlagMode, "ForceFalse">,
	ForceTrue: EnumItem<number, TrackerLodFlagMode, "ForceTrue">,
	Auto: EnumItem<number, TrackerLodFlagMode, "Auto">,
}, TrackerLodFlagMode>
Enum.TrackerLodFlagMode = {"ForceFalse", "ForceTrue", "Auto"}

export type TrackerLodValueMode =
	| EnumItem<number, TrackerLodValueMode, "Force0">
	| EnumItem<number, TrackerLodValueMode, "Force1">
	| EnumItem<number, TrackerLodValueMode, "Auto">
export type TrackerLodValueModeRoot = EnumObject<{
	Force0: EnumItem<number, TrackerLodValueMode, "Force0">,
	Force1: EnumItem<number, TrackerLodValueMode, "Force1">,
	Auto: EnumItem<number, TrackerLodValueMode, "Auto">,
}, TrackerLodValueMode>
Enum.TrackerLodValueMode = {"Force0", "Force1", "Auto"}

export type TrackerMode =
	| EnumItem<number, TrackerMode, "None">
	| EnumItem<number, TrackerMode, "Audio">
	| EnumItem<number, TrackerMode, "Video">
	| EnumItem<number, TrackerMode, "AudioVideo">
export type TrackerModeRoot = EnumObject<{
	None: EnumItem<number, TrackerMode, "None">,
	Audio: EnumItem<number, TrackerMode, "Audio">,
	Video: EnumItem<number, TrackerMode, "Video">,
	AudioVideo: EnumItem<number, TrackerMode, "AudioVideo">,
}, TrackerMode>
Enum.TrackerMode = {"None", "Audio", "Video", "AudioVideo"}

export type TrackerPromptEvent = | EnumItem<number, TrackerPromptEvent, "LODCameraRecommendDisable">
export type TrackerPromptEventRoot = EnumObject<{
	LODCameraRecommendDisable: EnumItem<number, TrackerPromptEvent, "LODCameraRecommendDisable">,
}, TrackerPromptEvent>
Enum.TrackerPromptEvent = {"LODCameraRecommendDisable"}

export type TrackerType =
	| EnumItem<number, TrackerType, "None">
	| EnumItem<number, TrackerType, "Face">
	| EnumItem<number, TrackerType, "UpperBody">
export type TrackerTypeRoot = EnumObject<{
	None: EnumItem<number, TrackerType, "None">,
	Face: EnumItem<number, TrackerType, "Face">,
	UpperBody: EnumItem<number, TrackerType, "UpperBody">,
}, TrackerType>
Enum.TrackerType = {"None", "Face", "UpperBody"}

export type TriStateBoolean =
	| EnumItem<number, TriStateBoolean, "Unknown">
	| EnumItem<number, TriStateBoolean, "True">
	| EnumItem<number, TriStateBoolean, "False">
export type TriStateBooleanRoot = EnumObject<{
	Unknown: EnumItem<number, TriStateBoolean, "Unknown">,
	True: EnumItem<number, TriStateBoolean, "True">,
	False: EnumItem<number, TriStateBoolean, "False">,
}, TriStateBoolean>
Enum.TriStateBoolean = {"Unknown", "True", "False"}

export type TweenStatus = | EnumItem<number, TweenStatus, "Canceled"> | EnumItem<number, TweenStatus, "Completed">
export type TweenStatusRoot = EnumObject<{
	Canceled: EnumItem<number, TweenStatus, "Canceled">,
	Completed: EnumItem<number, TweenStatus, "Completed">,
}, TweenStatus>
Enum.TweenStatus = {"Canceled", "Completed"}

export type UICaptureMode = | EnumItem<number, UICaptureMode, "All"> | EnumItem<number, UICaptureMode, "None">
export type UICaptureModeRoot = EnumObject<{
	All: EnumItem<number, UICaptureMode, "All">,
	None: EnumItem<number, UICaptureMode, "None">,
}, UICaptureMode>
Enum.UICaptureMode = {"All", "None"}

export type UIDragDetectorBoundingBehavior =
	| EnumItem<number, UIDragDetectorBoundingBehavior, "Automatic">
	| EnumItem<number, UIDragDetectorBoundingBehavior, "EntireObject">
	| EnumItem<number, UIDragDetectorBoundingBehavior, "HitPoint">
export type UIDragDetectorBoundingBehaviorRoot = EnumObject<{
	Automatic: EnumItem<number, UIDragDetectorBoundingBehavior, "Automatic">,
	EntireObject: EnumItem<number, UIDragDetectorBoundingBehavior, "EntireObject">,
	HitPoint: EnumItem<number, UIDragDetectorBoundingBehavior, "HitPoint">,
}, UIDragDetectorBoundingBehavior>
Enum.UIDragDetectorBoundingBehavior = {"Automatic", "EntireObject", "HitPoint"}

export type UIDragDetectorDragRelativity =
	| EnumItem<number, UIDragDetectorDragRelativity, "Absolute">
	| EnumItem<number, UIDragDetectorDragRelativity, "Relative">
export type UIDragDetectorDragRelativityRoot = EnumObject<{
	Absolute: EnumItem<number, UIDragDetectorDragRelativity, "Absolute">,
	Relative: EnumItem<number, UIDragDetectorDragRelativity, "Relative">,
}, UIDragDetectorDragRelativity>
Enum.UIDragDetectorDragRelativity = {"Absolute", "Relative"}

export type UIDragDetectorDragSpace =
	| EnumItem<number, UIDragDetectorDragSpace, "Parent">
	| EnumItem<number, UIDragDetectorDragSpace, "LayerCollector">
	| EnumItem<number, UIDragDetectorDragSpace, "Reference">
export type UIDragDetectorDragSpaceRoot = EnumObject<{
	Parent: EnumItem<number, UIDragDetectorDragSpace, "Parent">,
	LayerCollector: EnumItem<number, UIDragDetectorDragSpace, "LayerCollector">,
	Reference: EnumItem<number, UIDragDetectorDragSpace, "Reference">,
}, UIDragDetectorDragSpace>
Enum.UIDragDetectorDragSpace = {"Parent", "LayerCollector", "Reference"}

export type UIDragDetectorDragStyle =
	| EnumItem<number, UIDragDetectorDragStyle, "TranslatePlane">
	| EnumItem<number, UIDragDetectorDragStyle, "TranslateLine">
	| EnumItem<number, UIDragDetectorDragStyle, "Rotate">
	| EnumItem<number, UIDragDetectorDragStyle, "Scriptable">
export type UIDragDetectorDragStyleRoot = EnumObject<{
	TranslatePlane: EnumItem<number, UIDragDetectorDragStyle, "TranslatePlane">,
	TranslateLine: EnumItem<number, UIDragDetectorDragStyle, "TranslateLine">,
	Rotate: EnumItem<number, UIDragDetectorDragStyle, "Rotate">,
	Scriptable: EnumItem<number, UIDragDetectorDragStyle, "Scriptable">,
}, UIDragDetectorDragStyle>
Enum.UIDragDetectorDragStyle = {"TranslatePlane", "TranslateLine", "Rotate", "Scriptable"}

export type UIDragDetectorResponseStyle =
	| EnumItem<number, UIDragDetectorResponseStyle, "Offset">
	| EnumItem<number, UIDragDetectorResponseStyle, "Scale">
	| EnumItem<number, UIDragDetectorResponseStyle, "CustomOffset">
	| EnumItem<number, UIDragDetectorResponseStyle, "CustomScale">
export type UIDragDetectorResponseStyleRoot = EnumObject<{
	Offset: EnumItem<number, UIDragDetectorResponseStyle, "Offset">,
	Scale: EnumItem<number, UIDragDetectorResponseStyle, "Scale">,
	CustomOffset: EnumItem<number, UIDragDetectorResponseStyle, "CustomOffset">,
	CustomScale: EnumItem<number, UIDragDetectorResponseStyle, "CustomScale">,
}, UIDragDetectorResponseStyle>
Enum.UIDragDetectorResponseStyle = {"Offset", "Scale", "CustomOffset", "CustomScale"}

export type UIDragSpeedAxisMapping =
	| EnumItem<number, UIDragSpeedAxisMapping, "XY">
	| EnumItem<number, UIDragSpeedAxisMapping, "XX">
	| EnumItem<number, UIDragSpeedAxisMapping, "YY">
export type UIDragSpeedAxisMappingRoot = EnumObject<{
	XY: EnumItem<number, UIDragSpeedAxisMapping, "XY">,
	XX: EnumItem<number, UIDragSpeedAxisMapping, "XX">,
	YY: EnumItem<number, UIDragSpeedAxisMapping, "YY">,
}, UIDragSpeedAxisMapping>
Enum.UIDragSpeedAxisMapping = {"XY", "XX", "YY"}

export type UIFlexAlignment =
	| EnumItem<number, UIFlexAlignment, "None">
	| EnumItem<number, UIFlexAlignment, "Fill">
	| EnumItem<number, UIFlexAlignment, "SpaceAround">
	| EnumItem<number, UIFlexAlignment, "SpaceBetween">
	| EnumItem<number, UIFlexAlignment, "SpaceEvenly">
export type UIFlexAlignmentRoot = EnumObject<{
	None: EnumItem<number, UIFlexAlignment, "None">,
	Fill: EnumItem<number, UIFlexAlignment, "Fill">,
	SpaceAround: EnumItem<number, UIFlexAlignment, "SpaceAround">,
	SpaceBetween: EnumItem<number, UIFlexAlignment, "SpaceBetween">,
	SpaceEvenly: EnumItem<number, UIFlexAlignment, "SpaceEvenly">,
}, UIFlexAlignment>
Enum.UIFlexAlignment = {"None", "Fill", "SpaceAround", "SpaceBetween", "SpaceEvenly"}

export type UIFlexMode =
	| EnumItem<number, UIFlexMode, "None">
	| EnumItem<number, UIFlexMode, "Grow">
	| EnumItem<number, UIFlexMode, "Shrink">
	| EnumItem<number, UIFlexMode, "Fill">
	| EnumItem<number, UIFlexMode, "Custom">
export type UIFlexModeRoot = EnumObject<{
	None: EnumItem<number, UIFlexMode, "None">,
	Grow: EnumItem<number, UIFlexMode, "Grow">,
	Shrink: EnumItem<number, UIFlexMode, "Shrink">,
	Fill: EnumItem<number, UIFlexMode, "Fill">,
	Custom: EnumItem<number, UIFlexMode, "Custom">,
}, UIFlexMode>
Enum.UIFlexMode = {"None", "Grow", "Shrink", "Fill", "Custom"}

export type UITheme = | EnumItem<number, UITheme, "Light"> | EnumItem<number, UITheme, "Dark">
export type UIThemeRoot = EnumObject<{
	Light: EnumItem<number, UITheme, "Light">,
	Dark: EnumItem<number, UITheme, "Dark">,
}, UITheme>
Enum.UITheme = {"Light", "Dark"}

export type UiMessageType =
	| EnumItem<number, UiMessageType, "UiMessageError">
	| EnumItem<number, UiMessageType, "UiMessageInfo">
export type UiMessageTypeRoot = EnumObject<{
	UiMessageError: EnumItem<number, UiMessageType, "UiMessageError">,
	UiMessageInfo: EnumItem<number, UiMessageType, "UiMessageInfo">,
}, UiMessageType>
Enum.UiMessageType = {"UiMessageError", "UiMessageInfo"}

export type UsageContext = | EnumItem<number, UsageContext, "Default"> | EnumItem<number, UsageContext, "Preview">
export type UsageContextRoot = EnumObject<{
	Default: EnumItem<number, UsageContext, "Default">,
	Preview: EnumItem<number, UsageContext, "Preview">,
}, UsageContext>
Enum.UsageContext = {"Default", "Preview"}

export type UserCFrame =
	| EnumItem<number, UserCFrame, "Head">
	| EnumItem<number, UserCFrame, "LeftHand">
	| EnumItem<number, UserCFrame, "RightHand">
	| EnumItem<number, UserCFrame, "Floor">
export type UserCFrameRoot = EnumObject<{
	Head: EnumItem<number, UserCFrame, "Head">,
	LeftHand: EnumItem<number, UserCFrame, "LeftHand">,
	RightHand: EnumItem<number, UserCFrame, "RightHand">,
	Floor: EnumItem<number, UserCFrame, "Floor">,
}, UserCFrame>
Enum.UserCFrame = {"Head", "LeftHand", "RightHand", "Floor"}

export type UserInputState =
	| EnumItem<number, UserInputState, "Begin">
	| EnumItem<number, UserInputState, "Change">
	| EnumItem<number, UserInputState, "End">
	| EnumItem<number, UserInputState, "Cancel">
	| EnumItem<number, UserInputState, "None">
export type UserInputStateRoot = EnumObject<{
	Begin: EnumItem<number, UserInputState, "Begin">,
	Change: EnumItem<number, UserInputState, "Change">,
	End: EnumItem<number, UserInputState, "End">,
	Cancel: EnumItem<number, UserInputState, "Cancel">,
	None: EnumItem<number, UserInputState, "None">,
}, UserInputState>
Enum.UserInputState = {"Begin", "Change", "End", "Cancel", "None"}

export type UserInputType =
	| EnumItem<number, UserInputType, "MouseButton1">
	| EnumItem<number, UserInputType, "MouseButton2">
	| EnumItem<number, UserInputType, "MouseButton3">
	| EnumItem<number, UserInputType, "MouseWheel">
	| EnumItem<number, UserInputType, "MouseMovement">
	| EnumItem<number, UserInputType, "Touch">
	| EnumItem<number, UserInputType, "Keyboard">
	| EnumItem<number, UserInputType, "Focus">
	| EnumItem<number, UserInputType, "Accelerometer">
	| EnumItem<number, UserInputType, "Gyro">
	| EnumItem<number, UserInputType, "Gamepad1">
	| EnumItem<number, UserInputType, "Gamepad2">
	| EnumItem<number, UserInputType, "Gamepad3">
	| EnumItem<number, UserInputType, "Gamepad4">
	| EnumItem<number, UserInputType, "Gamepad5">
	| EnumItem<number, UserInputType, "Gamepad6">
	| EnumItem<number, UserInputType, "Gamepad7">
	| EnumItem<number, UserInputType, "Gamepad8">
	| EnumItem<number, UserInputType, "TextInput">
	| EnumItem<number, UserInputType, "InputMethod">
	| EnumItem<number, UserInputType, "None">
export type UserInputTypeRoot = EnumObject<{
	MouseButton1: EnumItem<number, UserInputType, "MouseButton1">,
	MouseButton2: EnumItem<number, UserInputType, "MouseButton2">,
	MouseButton3: EnumItem<number, UserInputType, "MouseButton3">,
	MouseWheel: EnumItem<number, UserInputType, "MouseWheel">,
	MouseMovement: EnumItem<number, UserInputType, "MouseMovement">,
	Touch: EnumItem<number, UserInputType, "Touch">,
	Keyboard: EnumItem<number, UserInputType, "Keyboard">,
	Focus: EnumItem<number, UserInputType, "Focus">,
	Accelerometer: EnumItem<number, UserInputType, "Accelerometer">,
	Gyro: EnumItem<number, UserInputType, "Gyro">,
	Gamepad1: EnumItem<number, UserInputType, "Gamepad1">,
	Gamepad2: EnumItem<number, UserInputType, "Gamepad2">,
	Gamepad3: EnumItem<number, UserInputType, "Gamepad3">,
	Gamepad4: EnumItem<number, UserInputType, "Gamepad4">,
	Gamepad5: EnumItem<number, UserInputType, "Gamepad5">,
	Gamepad6: EnumItem<number, UserInputType, "Gamepad6">,
	Gamepad7: EnumItem<number, UserInputType, "Gamepad7">,
	Gamepad8: EnumItem<number, UserInputType, "Gamepad8">,
	TextInput: EnumItem<number, UserInputType, "TextInput">,
	InputMethod: EnumItem<number, UserInputType, "InputMethod">,
	None: EnumItem<number, UserInputType, "None">,
}, UserInputType>
Enum.UserInputType = {
	MouseButton1 = 0;
	MouseButton2 = 1;
	MouseButton3 = 2;
	MouseWheel = 3;
	MouseMovement = 4;
	Touch = 7;
	Keyboard = 8;
	Focus = 9;
	Accelerometer = 10;
	Gyro = 11;
	Gamepad1 = 12;
	Gamepad2 = 13;
	Gamepad3 = 14;
	Gamepad4 = 15;
	Gamepad5 = 16;
	Gamepad6 = 17;
	Gamepad7 = 18;
	Gamepad8 = 19;
	TextInput = 20;
	InputMethod = 21;
	None = 22;
}

export type VRComfortSetting =
	| EnumItem<number, VRComfortSetting, "Comfort">
	| EnumItem<number, VRComfortSetting, "Normal">
	| EnumItem<number, VRComfortSetting, "Expert">
	| EnumItem<number, VRComfortSetting, "Custom">
export type VRComfortSettingRoot = EnumObject<{
	Comfort: EnumItem<number, VRComfortSetting, "Comfort">,
	Normal: EnumItem<number, VRComfortSetting, "Normal">,
	Expert: EnumItem<number, VRComfortSetting, "Expert">,
	Custom: EnumItem<number, VRComfortSetting, "Custom">,
}, VRComfortSetting>
Enum.VRComfortSetting = {"Comfort", "Normal", "Expert", "Custom"}

export type VRControllerModelMode =
	| EnumItem<number, VRControllerModelMode, "Disabled">
	| EnumItem<number, VRControllerModelMode, "Transparent">
export type VRControllerModelModeRoot = EnumObject<{
	Disabled: EnumItem<number, VRControllerModelMode, "Disabled">,
	Transparent: EnumItem<number, VRControllerModelMode, "Transparent">,
}, VRControllerModelMode>
Enum.VRControllerModelMode = {"Disabled", "Transparent"}

export type VRDeviceType =
	| EnumItem<number, VRDeviceType, "Unknown">
	| EnumItem<number, VRDeviceType, "OculusRift">
	| EnumItem<number, VRDeviceType, "HTCVive">
	| EnumItem<number, VRDeviceType, "ValveIndex">
	| EnumItem<number, VRDeviceType, "OculusQuest">
export type VRDeviceTypeRoot = EnumObject<{
	Unknown: EnumItem<number, VRDeviceType, "Unknown">,
	OculusRift: EnumItem<number, VRDeviceType, "OculusRift">,
	HTCVive: EnumItem<number, VRDeviceType, "HTCVive">,
	ValveIndex: EnumItem<number, VRDeviceType, "ValveIndex">,
	OculusQuest: EnumItem<number, VRDeviceType, "OculusQuest">,
}, VRDeviceType>
Enum.VRDeviceType = {"Unknown", "OculusRift", "HTCVive", "ValveIndex", "OculusQuest"}

export type VRLaserPointerMode =
	| EnumItem<number, VRLaserPointerMode, "Disabled">
	| EnumItem<number, VRLaserPointerMode, "Pointer">
	| EnumItem<number, VRLaserPointerMode, "DualPointer">
export type VRLaserPointerModeRoot = EnumObject<{
	Disabled: EnumItem<number, VRLaserPointerMode, "Disabled">,
	Pointer: EnumItem<number, VRLaserPointerMode, "Pointer">,
	DualPointer: EnumItem<number, VRLaserPointerMode, "DualPointer">,
}, VRLaserPointerMode>
Enum.VRLaserPointerMode = {"Disabled", "Pointer", "DualPointer"}

export type VRSafetyBubbleMode =
	| EnumItem<number, VRSafetyBubbleMode, "NoOne">
	| EnumItem<number, VRSafetyBubbleMode, "OnlyFriends">
	| EnumItem<number, VRSafetyBubbleMode, "Anyone">
export type VRSafetyBubbleModeRoot = EnumObject<{
	NoOne: EnumItem<number, VRSafetyBubbleMode, "NoOne">,
	OnlyFriends: EnumItem<number, VRSafetyBubbleMode, "OnlyFriends">,
	Anyone: EnumItem<number, VRSafetyBubbleMode, "Anyone">,
}, VRSafetyBubbleMode>
Enum.VRSafetyBubbleMode = {"NoOne", "OnlyFriends", "Anyone"}

export type VRScaling = | EnumItem<number, VRScaling, "World"> | EnumItem<number, VRScaling, "Off">
export type VRScalingRoot = EnumObject<{
	World: EnumItem<number, VRScaling, "World">,
	Off: EnumItem<number, VRScaling, "Off">,
}, VRScaling>
Enum.VRScaling = {"World", "Off"}

export type VRSessionState =
	| EnumItem<number, VRSessionState, "Undefined">
	| EnumItem<number, VRSessionState, "Idle">
	| EnumItem<number, VRSessionState, "Visible">
	| EnumItem<number, VRSessionState, "Focused">
	| EnumItem<number, VRSessionState, "Stopping">
export type VRSessionStateRoot = EnumObject<{
	Undefined: EnumItem<number, VRSessionState, "Undefined">,
	Idle: EnumItem<number, VRSessionState, "Idle">,
	Visible: EnumItem<number, VRSessionState, "Visible">,
	Focused: EnumItem<number, VRSessionState, "Focused">,
	Stopping: EnumItem<number, VRSessionState, "Stopping">,
}, VRSessionState>
Enum.VRSessionState = {"Undefined", "Idle", "Visible", "Focused", "Stopping"}

export type VRTouchpad = | EnumItem<number, VRTouchpad, "Left"> | EnumItem<number, VRTouchpad, "Right">
export type VRTouchpadRoot = EnumObject<{
	Left: EnumItem<number, VRTouchpad, "Left">,
	Right: EnumItem<number, VRTouchpad, "Right">,
}, VRTouchpad>
Enum.VRTouchpad = {"Left", "Right"}

export type VRTouchpadMode =
	| EnumItem<number, VRTouchpadMode, "Touch">
	| EnumItem<number, VRTouchpadMode, "VirtualThumbstick">
	| EnumItem<number, VRTouchpadMode, "ABXY">
export type VRTouchpadModeRoot = EnumObject<{
	Touch: EnumItem<number, VRTouchpadMode, "Touch">,
	VirtualThumbstick: EnumItem<number, VRTouchpadMode, "VirtualThumbstick">,
	ABXY: EnumItem<number, VRTouchpadMode, "ABXY">,
}, VRTouchpadMode>
Enum.VRTouchpadMode = {"Touch", "VirtualThumbstick", "ABXY"}

export type VelocityConstraintMode =
	| EnumItem<number, VelocityConstraintMode, "Line">
	| EnumItem<number, VelocityConstraintMode, "Plane">
	| EnumItem<number, VelocityConstraintMode, "Vector">
export type VelocityConstraintModeRoot = EnumObject<{
	Line: EnumItem<number, VelocityConstraintMode, "Line">,
	Plane: EnumItem<number, VelocityConstraintMode, "Plane">,
	Vector: EnumItem<number, VelocityConstraintMode, "Vector">,
}, VelocityConstraintMode>
Enum.VelocityConstraintMode = {"Line", "Plane", "Vector"}

export type VerticalAlignment =
	| EnumItem<number, VerticalAlignment, "Center">
	| EnumItem<number, VerticalAlignment, "Top">
	| EnumItem<number, VerticalAlignment, "Bottom">
export type VerticalAlignmentRoot = EnumObject<{
	Center: EnumItem<number, VerticalAlignment, "Center">,
	Top: EnumItem<number, VerticalAlignment, "Top">,
	Bottom: EnumItem<number, VerticalAlignment, "Bottom">,
}, VerticalAlignment>
Enum.VerticalAlignment = {"Center", "Top", "Bottom"}

export type VerticalScrollBarPosition =
	| EnumItem<number, VerticalScrollBarPosition, "Right">
	| EnumItem<number, VerticalScrollBarPosition, "Left">
export type VerticalScrollBarPositionRoot = EnumObject<{
	Right: EnumItem<number, VerticalScrollBarPosition, "Right">,
	Left: EnumItem<number, VerticalScrollBarPosition, "Left">,
}, VerticalScrollBarPosition>
Enum.VerticalScrollBarPosition = {"Right", "Left"}

export type VibrationMotor =
	| EnumItem<number, VibrationMotor, "Large">
	| EnumItem<number, VibrationMotor, "Small">
	| EnumItem<number, VibrationMotor, "LeftTrigger">
	| EnumItem<number, VibrationMotor, "RightTrigger">
	| EnumItem<number, VibrationMotor, "LeftHand">
	| EnumItem<number, VibrationMotor, "RightHand">
export type VibrationMotorRoot = EnumObject<{
	Large: EnumItem<number, VibrationMotor, "Large">,
	Small: EnumItem<number, VibrationMotor, "Small">,
	LeftTrigger: EnumItem<number, VibrationMotor, "LeftTrigger">,
	RightTrigger: EnumItem<number, VibrationMotor, "RightTrigger">,
	LeftHand: EnumItem<number, VibrationMotor, "LeftHand">,
	RightHand: EnumItem<number, VibrationMotor, "RightHand">,
}, VibrationMotor>
Enum.VibrationMotor = {"Large", "Small", "LeftTrigger", "RightTrigger", "LeftHand", "RightHand"}

export type VideoCaptureResult =
	| EnumItem<number, VideoCaptureResult, "Success">
	| EnumItem<number, VideoCaptureResult, "OtherError">
	| EnumItem<number, VideoCaptureResult, "CapturingAlready">
	| EnumItem<number, VideoCaptureResult, "NoDeviceSupport">
	| EnumItem<number, VideoCaptureResult, "NoSpaceOnDevice">
export type VideoCaptureResultRoot = EnumObject<{
	Success: EnumItem<number, VideoCaptureResult, "Success">,
	OtherError: EnumItem<number, VideoCaptureResult, "OtherError">,
	CapturingAlready: EnumItem<number, VideoCaptureResult, "CapturingAlready">,
	NoDeviceSupport: EnumItem<number, VideoCaptureResult, "NoDeviceSupport">,
	NoSpaceOnDevice: EnumItem<number, VideoCaptureResult, "NoSpaceOnDevice">,
}, VideoCaptureResult>
Enum.VideoCaptureResult = {"Success", "OtherError", "CapturingAlready", "NoDeviceSupport", "NoSpaceOnDevice"}

export type VideoDeviceCaptureQuality =
	| EnumItem<number, VideoDeviceCaptureQuality, "Default">
	| EnumItem<number, VideoDeviceCaptureQuality, "Low">
	| EnumItem<number, VideoDeviceCaptureQuality, "Medium">
	| EnumItem<number, VideoDeviceCaptureQuality, "High">
export type VideoDeviceCaptureQualityRoot = EnumObject<{
	Default: EnumItem<number, VideoDeviceCaptureQuality, "Default">,
	Low: EnumItem<number, VideoDeviceCaptureQuality, "Low">,
	Medium: EnumItem<number, VideoDeviceCaptureQuality, "Medium">,
	High: EnumItem<number, VideoDeviceCaptureQuality, "High">,
}, VideoDeviceCaptureQuality>
Enum.VideoDeviceCaptureQuality = {"Default", "Low", "Medium", "High"}

export type VideoError =
	| EnumItem<number, VideoError, "Ok">
	| EnumItem<number, VideoError, "Eof">
	| EnumItem<number, VideoError, "EAgain">
	| EnumItem<number, VideoError, "BadParameter">
	| EnumItem<number, VideoError, "AllocFailed">
	| EnumItem<number, VideoError, "CodecInitFailed">
	| EnumItem<number, VideoError, "CodecCloseFailed">
	| EnumItem<number, VideoError, "DecodeFailed">
	| EnumItem<number, VideoError, "ParsingFailed">
	| EnumItem<number, VideoError, "Unsupported">
	| EnumItem<number, VideoError, "Generic">
	| EnumItem<number, VideoError, "DownloadFailed">
	| EnumItem<number, VideoError, "StreamNotFound">
	| EnumItem<number, VideoError, "EncodeFailed">
	| EnumItem<number, VideoError, "CreateFailed">
	| EnumItem<number, VideoError, "NoPermission">
	| EnumItem<number, VideoError, "NoService">
	| EnumItem<number, VideoError, "ReleaseFailed">
	| EnumItem<number, VideoError, "Unknown">
export type VideoErrorRoot = EnumObject<{
	Ok: EnumItem<number, VideoError, "Ok">,
	Eof: EnumItem<number, VideoError, "Eof">,
	EAgain: EnumItem<number, VideoError, "EAgain">,
	BadParameter: EnumItem<number, VideoError, "BadParameter">,
	AllocFailed: EnumItem<number, VideoError, "AllocFailed">,
	CodecInitFailed: EnumItem<number, VideoError, "CodecInitFailed">,
	CodecCloseFailed: EnumItem<number, VideoError, "CodecCloseFailed">,
	DecodeFailed: EnumItem<number, VideoError, "DecodeFailed">,
	ParsingFailed: EnumItem<number, VideoError, "ParsingFailed">,
	Unsupported: EnumItem<number, VideoError, "Unsupported">,
	Generic: EnumItem<number, VideoError, "Generic">,
	DownloadFailed: EnumItem<number, VideoError, "DownloadFailed">,
	StreamNotFound: EnumItem<number, VideoError, "StreamNotFound">,
	EncodeFailed: EnumItem<number, VideoError, "EncodeFailed">,
	CreateFailed: EnumItem<number, VideoError, "CreateFailed">,
	NoPermission: EnumItem<number, VideoError, "NoPermission">,
	NoService: EnumItem<number, VideoError, "NoService">,
	ReleaseFailed: EnumItem<number, VideoError, "ReleaseFailed">,
	Unknown: EnumItem<number, VideoError, "Unknown">,
}, VideoError>
Enum.VideoError = {
	"Ok";
	"Eof";
	"EAgain";
	"BadParameter";
	"AllocFailed";
	"CodecInitFailed";
	"CodecCloseFailed";
	"DecodeFailed";
	"ParsingFailed";
	"Unsupported";
	"Generic";
	"DownloadFailed";
	"StreamNotFound";
	"EncodeFailed";
	"CreateFailed";
	"NoPermission";
	"NoService";
	"ReleaseFailed";
	"Unknown";
}

export type ViewMode =
	| EnumItem<number, ViewMode, "None">
	| EnumItem<number, ViewMode, "GeometryComplexity">
	| EnumItem<number, ViewMode, "Transparent">
	| EnumItem<number, ViewMode, "Decal">
export type ViewModeRoot = EnumObject<{
	None: EnumItem<number, ViewMode, "None">,
	GeometryComplexity: EnumItem<number, ViewMode, "GeometryComplexity">,
	Transparent: EnumItem<number, ViewMode, "Transparent">,
	Decal: EnumItem<number, ViewMode, "Decal">,
}, ViewMode>
Enum.ViewMode = {"None", "GeometryComplexity", "Transparent", "Decal"}

export type VirtualCursorMode =
	| EnumItem<number, VirtualCursorMode, "Default">
	| EnumItem<number, VirtualCursorMode, "Disabled">
	| EnumItem<number, VirtualCursorMode, "Enabled">
export type VirtualCursorModeRoot = EnumObject<{
	Default: EnumItem<number, VirtualCursorMode, "Default">,
	Disabled: EnumItem<number, VirtualCursorMode, "Disabled">,
	Enabled: EnumItem<number, VirtualCursorMode, "Enabled">,
}, VirtualCursorMode>
Enum.VirtualCursorMode = {"Default", "Disabled", "Enabled"}

export type VirtualInputMode =
	| EnumItem<number, VirtualInputMode, "None">
	| EnumItem<number, VirtualInputMode, "Recording">
	| EnumItem<number, VirtualInputMode, "Playing">
export type VirtualInputModeRoot = EnumObject<{
	None: EnumItem<number, VirtualInputMode, "None">,
	Recording: EnumItem<number, VirtualInputMode, "Recording">,
	Playing: EnumItem<number, VirtualInputMode, "Playing">,
}, VirtualInputMode>
Enum.VirtualInputMode = {"None", "Recording", "Playing"}

export type VoiceChatDistanceAttenuationType =
	| EnumItem<number, VoiceChatDistanceAttenuationType, "Inverse">
	| EnumItem<number, VoiceChatDistanceAttenuationType, "Legacy">
export type VoiceChatDistanceAttenuationTypeRoot = EnumObject<{
	Inverse: EnumItem<number, VoiceChatDistanceAttenuationType, "Inverse">,
	Legacy: EnumItem<number, VoiceChatDistanceAttenuationType, "Legacy">,
}, VoiceChatDistanceAttenuationType>
Enum.VoiceChatDistanceAttenuationType = {"Inverse", "Legacy"}

export type VoiceChatState =
	| EnumItem<number, VoiceChatState, "Idle">
	| EnumItem<number, VoiceChatState, "Joining">
	| EnumItem<number, VoiceChatState, "JoiningRetry">
	| EnumItem<number, VoiceChatState, "Joined">
	| EnumItem<number, VoiceChatState, "Leaving">
	| EnumItem<number, VoiceChatState, "Ended">
	| EnumItem<number, VoiceChatState, "Failed">
export type VoiceChatStateRoot = EnumObject<{
	Idle: EnumItem<number, VoiceChatState, "Idle">,
	Joining: EnumItem<number, VoiceChatState, "Joining">,
	JoiningRetry: EnumItem<number, VoiceChatState, "JoiningRetry">,
	Joined: EnumItem<number, VoiceChatState, "Joined">,
	Leaving: EnumItem<number, VoiceChatState, "Leaving">,
	Ended: EnumItem<number, VoiceChatState, "Ended">,
	Failed: EnumItem<number, VoiceChatState, "Failed">,
}, VoiceChatState>
Enum.VoiceChatState = {"Idle", "Joining", "JoiningRetry", "Joined", "Leaving", "Ended", "Failed"}

export type VoiceControlPath =
	| EnumItem<number, VoiceControlPath, "Publish">
	| EnumItem<number, VoiceControlPath, "Subscribe">
	| EnumItem<number, VoiceControlPath, "Join">
export type VoiceControlPathRoot = EnumObject<{
	Publish: EnumItem<number, VoiceControlPath, "Publish">,
	Subscribe: EnumItem<number, VoiceControlPath, "Subscribe">,
	Join: EnumItem<number, VoiceControlPath, "Join">,
}, VoiceControlPath>
Enum.VoiceControlPath = {"Publish", "Subscribe", "Join"}

export type VolumetricAudio =
	| EnumItem<number, VolumetricAudio, "Disabled">
	| EnumItem<number, VolumetricAudio, "Automatic">
	| EnumItem<number, VolumetricAudio, "Enabled">
export type VolumetricAudioRoot = EnumObject<{
	Disabled: EnumItem<number, VolumetricAudio, "Disabled">,
	Automatic: EnumItem<number, VolumetricAudio, "Automatic">,
	Enabled: EnumItem<number, VolumetricAudio, "Enabled">,
}, VolumetricAudio>
Enum.VolumetricAudio = {"Disabled", "Automatic", "Enabled"}

export type WaterDirection =
	| EnumItem<number, WaterDirection, "NegX">
	| EnumItem<number, WaterDirection, "X">
	| EnumItem<number, WaterDirection, "NegY">
	| EnumItem<number, WaterDirection, "Y">
	| EnumItem<number, WaterDirection, "NegZ">
	| EnumItem<number, WaterDirection, "Z">
export type WaterDirectionRoot = EnumObject<{
	NegX: EnumItem<number, WaterDirection, "NegX">,
	X: EnumItem<number, WaterDirection, "X">,
	NegY: EnumItem<number, WaterDirection, "NegY">,
	Y: EnumItem<number, WaterDirection, "Y">,
	NegZ: EnumItem<number, WaterDirection, "NegZ">,
	Z: EnumItem<number, WaterDirection, "Z">,
}, WaterDirection>
Enum.WaterDirection = {"NegX", "X", "NegY", "Y", "NegZ", "Z"}

export type WaterForce =
	| EnumItem<number, WaterForce, "None">
	| EnumItem<number, WaterForce, "Small">
	| EnumItem<number, WaterForce, "Medium">
	| EnumItem<number, WaterForce, "Strong">
	| EnumItem<number, WaterForce, "Max">
export type WaterForceRoot = EnumObject<{
	None: EnumItem<number, WaterForce, "None">,
	Small: EnumItem<number, WaterForce, "Small">,
	Medium: EnumItem<number, WaterForce, "Medium">,
	Strong: EnumItem<number, WaterForce, "Strong">,
	Max: EnumItem<number, WaterForce, "Max">,
}, WaterForce>
Enum.WaterForce = {"None", "Small", "Medium", "Strong", "Max"}

export type WebSocketState =
	| EnumItem<number, WebSocketState, "Connecting">
	| EnumItem<number, WebSocketState, "Open">
	| EnumItem<number, WebSocketState, "Closing">
	| EnumItem<number, WebSocketState, "Closed">
export type WebSocketStateRoot = EnumObject<{
	Connecting: EnumItem<number, WebSocketState, "Connecting">,
	Open: EnumItem<number, WebSocketState, "Open">,
	Closing: EnumItem<number, WebSocketState, "Closing">,
	Closed: EnumItem<number, WebSocketState, "Closed">,
}, WebSocketState>
Enum.WebSocketState = {"Connecting", "Open", "Closing", "Closed"}

export type WeldConstraintPreserve =
	| EnumItem<number, WeldConstraintPreserve, "All">
	| EnumItem<number, WeldConstraintPreserve, "None">
	| EnumItem<number, WeldConstraintPreserve, "Touching">
export type WeldConstraintPreserveRoot = EnumObject<{
	All: EnumItem<number, WeldConstraintPreserve, "All">,
	None: EnumItem<number, WeldConstraintPreserve, "None">,
	Touching: EnumItem<number, WeldConstraintPreserve, "Touching">,
}, WeldConstraintPreserve>
Enum.WeldConstraintPreserve = {"All", "None", "Touching"}

export type WhisperChatPrivacyMode =
	| EnumItem<number, WhisperChatPrivacyMode, "AllUsers">
	| EnumItem<number, WhisperChatPrivacyMode, "NoOne">
export type WhisperChatPrivacyModeRoot = EnumObject<{
	AllUsers: EnumItem<number, WhisperChatPrivacyMode, "AllUsers">,
	NoOne: EnumItem<number, WhisperChatPrivacyMode, "NoOne">,
}, WhisperChatPrivacyMode>
Enum.WhisperChatPrivacyMode = {"AllUsers", "NoOne"}

export type WrapLayerAutoSkin =
	| EnumItem<number, WrapLayerAutoSkin, "Disabled">
	| EnumItem<number, WrapLayerAutoSkin, "EnabledPreserve">
	| EnumItem<number, WrapLayerAutoSkin, "EnabledOverride">
export type WrapLayerAutoSkinRoot = EnumObject<{
	Disabled: EnumItem<number, WrapLayerAutoSkin, "Disabled">,
	EnabledPreserve: EnumItem<number, WrapLayerAutoSkin, "EnabledPreserve">,
	EnabledOverride: EnumItem<number, WrapLayerAutoSkin, "EnabledOverride">,
}, WrapLayerAutoSkin>
Enum.WrapLayerAutoSkin = {"Disabled", "EnabledPreserve", "EnabledOverride"}

export type WrapLayerDebugMode =
	| EnumItem<number, WrapLayerDebugMode, "None">
	| EnumItem<number, WrapLayerDebugMode, "BoundCage">
	| EnumItem<number, WrapLayerDebugMode, "LayerCage">
	| EnumItem<number, WrapLayerDebugMode, "BoundCageAndLinks">
	| EnumItem<number, WrapLayerDebugMode, "Reference">
	| EnumItem<number, WrapLayerDebugMode, "Rbf">
	| EnumItem<number, WrapLayerDebugMode, "OuterCage">
	| EnumItem<number, WrapLayerDebugMode, "ReferenceMeshAfterMorph">
	| EnumItem<number, WrapLayerDebugMode, "HSROuterDetail">
	| EnumItem<number, WrapLayerDebugMode, "HSROuter">
	| EnumItem<number, WrapLayerDebugMode, "HSRInner">
	| EnumItem<number, WrapLayerDebugMode, "HSRInnerReverse">
	| EnumItem<number, WrapLayerDebugMode, "LayerCageFittedToBase">
	| EnumItem<number, WrapLayerDebugMode, "LayerCageFittedToPrev">
export type WrapLayerDebugModeRoot = EnumObject<{
	None: EnumItem<number, WrapLayerDebugMode, "None">,
	BoundCage: EnumItem<number, WrapLayerDebugMode, "BoundCage">,
	LayerCage: EnumItem<number, WrapLayerDebugMode, "LayerCage">,
	BoundCageAndLinks: EnumItem<number, WrapLayerDebugMode, "BoundCageAndLinks">,
	Reference: EnumItem<number, WrapLayerDebugMode, "Reference">,
	Rbf: EnumItem<number, WrapLayerDebugMode, "Rbf">,
	OuterCage: EnumItem<number, WrapLayerDebugMode, "OuterCage">,
	ReferenceMeshAfterMorph: EnumItem<number, WrapLayerDebugMode, "ReferenceMeshAfterMorph">,
	HSROuterDetail: EnumItem<number, WrapLayerDebugMode, "HSROuterDetail">,
	HSROuter: EnumItem<number, WrapLayerDebugMode, "HSROuter">,
	HSRInner: EnumItem<number, WrapLayerDebugMode, "HSRInner">,
	HSRInnerReverse: EnumItem<number, WrapLayerDebugMode, "HSRInnerReverse">,
	LayerCageFittedToBase: EnumItem<number, WrapLayerDebugMode, "LayerCageFittedToBase">,
	LayerCageFittedToPrev: EnumItem<number, WrapLayerDebugMode, "LayerCageFittedToPrev">,
}, WrapLayerDebugMode>
Enum.WrapLayerDebugMode = {
	"None";
	"BoundCage";
	"LayerCage";
	"BoundCageAndLinks";
	"Reference";
	"Rbf";
	"OuterCage";
	"ReferenceMeshAfterMorph";
	"HSROuterDetail";
	"HSROuter";
	"HSRInner";
	"HSRInnerReverse";
	"LayerCageFittedToBase";
	"LayerCageFittedToPrev";
}

export type WrapTargetDebugMode =
	| EnumItem<number, WrapTargetDebugMode, "None">
	| EnumItem<number, WrapTargetDebugMode, "TargetCageOriginal">
	| EnumItem<number, WrapTargetDebugMode, "TargetCageCompressed">
	| EnumItem<number, WrapTargetDebugMode, "TargetCageInterface">
	| EnumItem<number, WrapTargetDebugMode, "TargetLayerCageOriginal">
	| EnumItem<number, WrapTargetDebugMode, "TargetLayerCageCompressed">
	| EnumItem<number, WrapTargetDebugMode, "TargetLayerInterface">
	| EnumItem<number, WrapTargetDebugMode, "Rbf">
	| EnumItem<number, WrapTargetDebugMode, "OuterCageDetail">
export type WrapTargetDebugModeRoot = EnumObject<{
	None: EnumItem<number, WrapTargetDebugMode, "None">,
	TargetCageOriginal: EnumItem<number, WrapTargetDebugMode, "TargetCageOriginal">,
	TargetCageCompressed: EnumItem<number, WrapTargetDebugMode, "TargetCageCompressed">,
	TargetCageInterface: EnumItem<number, WrapTargetDebugMode, "TargetCageInterface">,
	TargetLayerCageOriginal: EnumItem<number, WrapTargetDebugMode, "TargetLayerCageOriginal">,
	TargetLayerCageCompressed: EnumItem<number, WrapTargetDebugMode, "TargetLayerCageCompressed">,
	TargetLayerInterface: EnumItem<number, WrapTargetDebugMode, "TargetLayerInterface">,
	Rbf: EnumItem<number, WrapTargetDebugMode, "Rbf">,
	OuterCageDetail: EnumItem<number, WrapTargetDebugMode, "OuterCageDetail">,
}, WrapTargetDebugMode>
Enum.WrapTargetDebugMode = {
	"None";
	"TargetCageOriginal";
	"TargetCageCompressed";
	"TargetCageInterface";
	"TargetLayerCageOriginal";
	"TargetLayerCageCompressed";
	"TargetLayerInterface";
	"Rbf";
	"OuterCageDetail";
}

export type ZIndexBehavior = | EnumItem<number, ZIndexBehavior, "Global"> | EnumItem<number, ZIndexBehavior, "Sibling">
export type ZIndexBehaviorRoot = EnumObject<{
	Global: EnumItem<number, ZIndexBehavior, "Global">,
	Sibling: EnumItem<number, ZIndexBehavior, "Sibling">,
}, ZIndexBehavior>
Enum.ZIndexBehavior = {"Global", "Sibling"}

return Enum :: Enums<
	{
		AccessModifierType: AccessModifierTypeRoot,
		AccessoryType: AccessoryTypeRoot,
		ActionOnAutoResumeSync: ActionOnAutoResumeSyncRoot,
		ActionOnStopSync: ActionOnStopSyncRoot,
		ActionType: ActionTypeRoot,
		ActuatorRelativeTo: ActuatorRelativeToRoot,
		ActuatorType: ActuatorTypeRoot,
		AdAvailabilityResult: AdAvailabilityResultRoot,
		AdEventType: AdEventTypeRoot,
		AdFormat: AdFormatRoot,
		AdShape: AdShapeRoot,
		AdTeleportMethod: AdTeleportMethodRoot,
		AdUIEventType: AdUIEventTypeRoot,
		AdUIType: AdUITypeRoot,
		AdUnitStatus: AdUnitStatusRoot,
		AdornCullingMode: AdornCullingModeRoot,
		AlignType: AlignTypeRoot,
		AlphaMode: AlphaModeRoot,
		AnalyticsCustomFieldKeys: AnalyticsCustomFieldKeysRoot,
		AnalyticsEconomyAction: AnalyticsEconomyActionRoot,
		AnalyticsEconomyFlowType: AnalyticsEconomyFlowTypeRoot,
		AnalyticsEconomyTransactionType: AnalyticsEconomyTransactionTypeRoot,
		AnalyticsLogLevel: AnalyticsLogLevelRoot,
		AnalyticsProgressionStatus: AnalyticsProgressionStatusRoot,
		AnalyticsProgressionType: AnalyticsProgressionTypeRoot,
		AnimationClipFromVideoStatus: AnimationClipFromVideoStatusRoot,
		AnimationPriority: AnimationPriorityRoot,
		AnimatorRetargetingMode: AnimatorRetargetingModeRoot,
		AnnotationEditingMode: AnnotationEditingModeRoot,
		AnnotationRequestStatus: AnnotationRequestStatusRoot,
		AnnotationRequestType: AnnotationRequestTypeRoot,
		AppLifecycleManagerState: AppLifecycleManagerStateRoot,
		AppShellActionType: AppShellActionTypeRoot,
		AppShellFeature: AppShellFeatureRoot,
		AppUpdateStatus: AppUpdateStatusRoot,
		ApplyStrokeMode: ApplyStrokeModeRoot,
		AspectType: AspectTypeRoot,
		AssetCreatorType: AssetCreatorTypeRoot,
		AssetFetchStatus: AssetFetchStatusRoot,
		AssetType: AssetTypeRoot,
		AssetTypeVerification: AssetTypeVerificationRoot,
		AudioApiRollout: AudioApiRolloutRoot,
		AudioCaptureMode: AudioCaptureModeRoot,
		AudioChannelLayout: AudioChannelLayoutRoot,
		AudioFilterType: AudioFilterTypeRoot,
		AudioSimulationFidelity: AudioSimulationFidelityRoot,
		AudioSubType: AudioSubTypeRoot,
		AudioWindowSize: AudioWindowSizeRoot,
		AutoIndentRule: AutoIndentRuleRoot,
		AutomaticSize: AutomaticSizeRoot,
		AvatarAssetType: AvatarAssetTypeRoot,
		AvatarChatServiceFeature: AvatarChatServiceFeatureRoot,
		AvatarContextMenuOption: AvatarContextMenuOptionRoot,
		AvatarGenerationError: AvatarGenerationErrorRoot,
		AvatarItemType: AvatarItemTypeRoot,
		AvatarPromptResult: AvatarPromptResultRoot,
		AvatarSettingsAccessoryLimitMethod: AvatarSettingsAccessoryLimitMethodRoot,
		AvatarSettingsAccessoryMode: AvatarSettingsAccessoryModeRoot,
		AvatarSettingsAnimationClipsMode: AvatarSettingsAnimationClipsModeRoot,
		AvatarSettingsAnimationPacksMode: AvatarSettingsAnimationPacksModeRoot,
		AvatarSettingsAppearanceMode: AvatarSettingsAppearanceModeRoot,
		AvatarSettingsBuildMode: AvatarSettingsBuildModeRoot,
		AvatarSettingsClothingMode: AvatarSettingsClothingModeRoot,
		AvatarSettingsCollisionMode: AvatarSettingsCollisionModeRoot,
		AvatarSettingsCustomAccessoryMode: AvatarSettingsCustomAccessoryModeRoot,
		AvatarSettingsCustomBodyType: AvatarSettingsCustomBodyTypeRoot,
		AvatarSettingsCustomClothingMode: AvatarSettingsCustomClothingModeRoot,
		AvatarSettingsHitAndTouchDetectionMode: AvatarSettingsHitAndTouchDetectionModeRoot,
		AvatarSettingsJumpMode: AvatarSettingsJumpModeRoot,
		AvatarSettingsLegacyCollisionMode: AvatarSettingsLegacyCollisionModeRoot,
		AvatarSettingsScaleMode: AvatarSettingsScaleModeRoot,
		AvatarThumbnailCustomizationType: AvatarThumbnailCustomizationTypeRoot,
		AvatarUnificationMode: AvatarUnificationModeRoot,
		Axis: AxisRoot,
		BenefitType: BenefitTypeRoot,
		BinType: BinTypeRoot,
		BodyPart: BodyPartRoot,
		BodyPartR15: BodyPartR15Root,
		BorderMode: BorderModeRoot,
		BreakReason: BreakReasonRoot,
		BreakpointRemoveReason: BreakpointRemoveReasonRoot,
		BulkMoveMode: BulkMoveModeRoot,
		BundleType: BundleTypeRoot,
		Button: ButtonRoot,
		ButtonStyle: ButtonStyleRoot,
		CageType: CageTypeRoot,
		CameraMode: CameraModeRoot,
		CameraPanMode: CameraPanModeRoot,
		CameraSpeedAdjustBinding: CameraSpeedAdjustBindingRoot,
		CameraType: CameraTypeRoot,
		CatalogCategoryFilter: CatalogCategoryFilterRoot,
		CatalogSortAggregation: CatalogSortAggregationRoot,
		CatalogSortType: CatalogSortTypeRoot,
		CellBlock: CellBlockRoot,
		CellMaterial: CellMaterialRoot,
		CellOrientation: CellOrientationRoot,
		CenterDialogType: CenterDialogTypeRoot,
		CharacterControlMode: CharacterControlModeRoot,
		ChatCallbackType: ChatCallbackTypeRoot,
		ChatColor: ChatColorRoot,
		ChatMode: ChatModeRoot,
		ChatPrivacyMode: ChatPrivacyModeRoot,
		ChatRestrictionStatus: ChatRestrictionStatusRoot,
		ChatStyle: ChatStyleRoot,
		ChatVersion: ChatVersionRoot,
		ClientAnimatorThrottlingMode: ClientAnimatorThrottlingModeRoot,
		CloseReason: CloseReasonRoot,
		CollaboratorStatus: CollaboratorStatusRoot,
		CollisionFidelity: CollisionFidelityRoot,
		CommandPermission: CommandPermissionRoot,
		CompileTarget: CompileTargetRoot,
		CompletionAcceptanceBehavior: CompletionAcceptanceBehaviorRoot,
		CompletionItemKind: CompletionItemKindRoot,
		CompletionItemTag: CompletionItemTagRoot,
		CompletionTriggerKind: CompletionTriggerKindRoot,
		ComputerCameraMovementMode: ComputerCameraMovementModeRoot,
		ComputerMovementMode: ComputerMovementModeRoot,
		ConfigSnapshotErrorState: ConfigSnapshotErrorStateRoot,
		ConnectionError: ConnectionErrorRoot,
		ConnectionState: ConnectionStateRoot,
		ContentSourceType: ContentSourceTypeRoot,
		ContextActionPriority: ContextActionPriorityRoot,
		ContextActionResult: ContextActionResultRoot,
		ControlMode: ControlModeRoot,
		CoreGuiType: CoreGuiTypeRoot,
		CreateAssetResult: CreateAssetResultRoot,
		CreateOutfitFailure: CreateOutfitFailureRoot,
		CreatorType: CreatorTypeRoot,
		CreatorTypeFilter: CreatorTypeFilterRoot,
		CurrencyType: CurrencyTypeRoot,
		CustomCameraMode: CustomCameraModeRoot,
		DataStoreRequestType: DataStoreRequestTypeRoot,
		DebuggerEndReason: DebuggerEndReasonRoot,
		DebuggerExceptionBreakMode: DebuggerExceptionBreakModeRoot,
		DebuggerFrameType: DebuggerFrameTypeRoot,
		DebuggerPauseReason: DebuggerPauseReasonRoot,
		DebuggerStatus: DebuggerStatusRoot,
		DevCameraOcclusionMode: DevCameraOcclusionModeRoot,
		DevComputerCameraMovementMode: DevComputerCameraMovementModeRoot,
		DevComputerMovementMode: DevComputerMovementModeRoot,
		DevTouchCameraMovementMode: DevTouchCameraMovementModeRoot,
		DevTouchMovementMode: DevTouchMovementModeRoot,
		DeveloperMemoryTag: DeveloperMemoryTagRoot,
		DeviceFeatureType: DeviceFeatureTypeRoot,
		DeviceForm: DeviceFormRoot,
		DeviceLevel: DeviceLevelRoot,
		DeviceType: DeviceTypeRoot,
		DialogBehaviorType: DialogBehaviorTypeRoot,
		DialogPurpose: DialogPurposeRoot,
		DialogTone: DialogToneRoot,
		DominantAxis: DominantAxisRoot,
		DraftStatusCode: DraftStatusCodeRoot,
		DragDetectorDragStyle: DragDetectorDragStyleRoot,
		DragDetectorPermissionPolicy: DragDetectorPermissionPolicyRoot,
		DragDetectorResponseStyle: DragDetectorResponseStyleRoot,
		DraggerCoordinateSpace: DraggerCoordinateSpaceRoot,
		DraggerMovementMode: DraggerMovementModeRoot,
		DraggingScrollBar: DraggingScrollBarRoot,
		EasingDirection: EasingDirectionRoot,
		EasingStyle: EasingStyleRoot,
		EditableStatus: EditableStatusRoot,
		ElasticBehavior: ElasticBehaviorRoot,
		EnviromentalPhysicsThrottle: EnviromentalPhysicsThrottleRoot,
		ExperienceAuthScope: ExperienceAuthScopeRoot,
		ExplosionType: ExplosionTypeRoot,
		FACSDataLod: FACSDataLodRoot,
		FacialAgeEstimationResultType: FacialAgeEstimationResultTypeRoot,
		FacialAnimationStreamingState: FacialAnimationStreamingStateRoot,
		FacsActionUnit: FacsActionUnitRoot,
		FeedRankingScoreType: FeedRankingScoreTypeRoot,
		FieldOfViewMode: FieldOfViewModeRoot,
		FillDirection: FillDirectionRoot,
		FilterErrorType: FilterErrorTypeRoot,
		FilterResult: FilterResultRoot,
		FinishRecordingOperation: FinishRecordingOperationRoot,
		FluidFidelity: FluidFidelityRoot,
		FluidForces: FluidForcesRoot,
		Font: FontRoot,
		FontSize: FontSizeRoot,
		FontStyle: FontStyleRoot,
		FontWeight: FontWeightRoot,
		ForceLimitMode: ForceLimitModeRoot,
		FormFactor: FormFactorRoot,
		FrameStyle: FrameStyleRoot,
		FramerateManagerMode: FramerateManagerModeRoot,
		FriendRequestEvent: FriendRequestEventRoot,
		FriendStatus: FriendStatusRoot,
		FunctionalTestResult: FunctionalTestResultRoot,
		GameAvatarType: GameAvatarTypeRoot,
		GamepadType: GamepadTypeRoot,
		GearGenreSetting: GearGenreSettingRoot,
		GearType: GearTypeRoot,
		Genre: GenreRoot,
		GraphicsMode: GraphicsModeRoot,
		GraphicsOptimizationMode: GraphicsOptimizationModeRoot,
		GuiState: GuiStateRoot,
		GuiType: GuiTypeRoot,
		HandlesStyle: HandlesStyleRoot,
		HapticEffectType: HapticEffectTypeRoot,
		HighlightDepthMode: HighlightDepthModeRoot,
		HorizontalAlignment: HorizontalAlignmentRoot,
		HoverAnimateSpeed: HoverAnimateSpeedRoot,
		HttpCachePolicy: HttpCachePolicyRoot,
		HttpCompression: HttpCompressionRoot,
		HttpContentType: HttpContentTypeRoot,
		HttpError: HttpErrorRoot,
		HttpRequestType: HttpRequestTypeRoot,
		HumanoidCollisionType: HumanoidCollisionTypeRoot,
		HumanoidDisplayDistanceType: HumanoidDisplayDistanceTypeRoot,
		HumanoidHealthDisplayType: HumanoidHealthDisplayTypeRoot,
		HumanoidRigType: HumanoidRigTypeRoot,
		HumanoidStateType: HumanoidStateTypeRoot,
		IKCollisionsMode: IKCollisionsModeRoot,
		IKControlConstraintSupport: IKControlConstraintSupportRoot,
		IKControlType: IKControlTypeRoot,
		IXPLoadingStatus: IXPLoadingStatusRoot,
		ImageAlphaType: ImageAlphaTypeRoot,
		ImageCombineType: ImageCombineTypeRoot,
		InOut: InOutRoot,
		InfoType: InfoTypeRoot,
		InitialDockState: InitialDockStateRoot,
		InputActionType: InputActionTypeRoot,
		InputType: InputTypeRoot,
		IntermediateMeshGenerationResult: IntermediateMeshGenerationResultRoot,
		InterpolationThrottlingMode: InterpolationThrottlingModeRoot,
		InviteState: InviteStateRoot,
		ItemLineAlignment: ItemLineAlignmentRoot,
		JoinSource: JoinSourceRoot,
		JointCreationMode: JointCreationModeRoot,
		KeyCode: KeyCodeRoot,
		KeyInterpolationMode: KeyInterpolationModeRoot,
		KeywordFilterType: KeywordFilterTypeRoot,
		Language: LanguageRoot,
		LeftRight: LeftRightRoot,
		LexemeType: LexemeTypeRoot,
		LightingStyle: LightingStyleRoot,
		Limb: LimbRoot,
		LineJoinMode: LineJoinModeRoot,
		ListDisplayMode: ListDisplayModeRoot,
		ListenerLocation: ListenerLocationRoot,
		ListenerType: ListenerTypeRoot,
		LiveEditingAtomicUpdateResponse: LiveEditingAtomicUpdateResponseRoot,
		LiveEditingBroadcastMessageType: LiveEditingBroadcastMessageTypeRoot,
		LoadCharacterLayeredClothing: LoadCharacterLayeredClothingRoot,
		LoadDynamicHeads: LoadDynamicHeadsRoot,
		LocationType: LocationTypeRoot,
		MarketplaceBulkPurchasePromptStatus: MarketplaceBulkPurchasePromptStatusRoot,
		MarketplaceItemPurchaseStatus: MarketplaceItemPurchaseStatusRoot,
		MarketplaceProductType: MarketplaceProductTypeRoot,
		MarkupKind: MarkupKindRoot,
		MatchmakingType: MatchmakingTypeRoot,
		Material: MaterialRoot,
		MaterialPattern: MaterialPatternRoot,
		MembershipType: MembershipTypeRoot,
		MeshPartDetailLevel: MeshPartDetailLevelRoot,
		MeshPartHeadsAndAccessories: MeshPartHeadsAndAccessoriesRoot,
		MeshScaleUnit: MeshScaleUnitRoot,
		MeshType: MeshTypeRoot,
		MessageType: MessageTypeRoot,
		ModelLevelOfDetail: ModelLevelOfDetailRoot,
		ModelStreamingBehavior: ModelStreamingBehaviorRoot,
		ModelStreamingMode: ModelStreamingModeRoot,
		ModerationStatus: ModerationStatusRoot,
		ModifierKey: ModifierKeyRoot,
		MouseBehavior: MouseBehaviorRoot,
		MoveState: MoveStateRoot,
		MoverConstraintRootBehaviorMode: MoverConstraintRootBehaviorModeRoot,
		MuteState: MuteStateRoot,
		NameOcclusion: NameOcclusionRoot,
		NetworkOwnership: NetworkOwnershipRoot,
		NetworkStatus: NetworkStatusRoot,
		NoiseType: NoiseTypeRoot,
		NormalId: NormalIdRoot,
		NotificationButtonType: NotificationButtonTypeRoot,
		OperationType: OperationTypeRoot,
		OrientationAlignmentMode: OrientationAlignmentModeRoot,
		OutfitSource: OutfitSourceRoot,
		OutfitType: OutfitTypeRoot,
		OutputLayoutMode: OutputLayoutModeRoot,
		OverrideMouseIconBehavior: OverrideMouseIconBehaviorRoot,
		PackagePermission: PackagePermissionRoot,
		PartType: PartTypeRoot,
		ParticleEmitterShape: ParticleEmitterShapeRoot,
		ParticleEmitterShapeInOut: ParticleEmitterShapeInOutRoot,
		ParticleEmitterShapeStyle: ParticleEmitterShapeStyleRoot,
		ParticleFlipbookLayout: ParticleFlipbookLayoutRoot,
		ParticleFlipbookMode: ParticleFlipbookModeRoot,
		ParticleFlipbookTextureCompatible: ParticleFlipbookTextureCompatibleRoot,
		ParticleOrientation: ParticleOrientationRoot,
		PathStatus: PathStatusRoot,
		PathWaypointAction: PathWaypointActionRoot,
		PathfindingUseImprovedSearch: PathfindingUseImprovedSearchRoot,
		PermissionLevelShown: PermissionLevelShownRoot,
		PhysicsSimulationRate: PhysicsSimulationRateRoot,
		PhysicsSteppingMethod: PhysicsSteppingMethodRoot,
		Platform: PlatformRoot,
		PlaybackState: PlaybackStateRoot,
		PlayerActions: PlayerActionsRoot,
		PlayerCharacterDestroyBehavior: PlayerCharacterDestroyBehaviorRoot,
		PlayerChatType: PlayerChatTypeRoot,
		PlayerDataErrorState: PlayerDataErrorStateRoot,
		PlayerDataLoadFailureBehavior: PlayerDataLoadFailureBehaviorRoot,
		PoseEasingDirection: PoseEasingDirectionRoot,
		PoseEasingStyle: PoseEasingStyleRoot,
		PositionAlignmentMode: PositionAlignmentModeRoot,
		PreferredTextSize: PreferredTextSizeRoot,
		PrimalPhysicsSolver: PrimalPhysicsSolverRoot,
		PrimitiveType: PrimitiveTypeRoot,
		PrivilegeType: PrivilegeTypeRoot,
		ProductLocationRestriction: ProductLocationRestrictionRoot,
		ProductPurchaseChannel: ProductPurchaseChannelRoot,
		ProductPurchaseDecision: ProductPurchaseDecisionRoot,
		PromptCreateAssetResult: PromptCreateAssetResultRoot,
		PromptCreateAvatarResult: PromptCreateAvatarResultRoot,
		PromptPublishAssetResult: PromptPublishAssetResultRoot,
		PropertyStatus: PropertyStatusRoot,
		ProximityPromptExclusivity: ProximityPromptExclusivityRoot,
		ProximityPromptInputType: ProximityPromptInputTypeRoot,
		ProximityPromptStyle: ProximityPromptStyleRoot,
		QualityLevel: QualityLevelRoot,
		R15CollisionType: R15CollisionTypeRoot,
		RaycastFilterType: RaycastFilterTypeRoot,
		RejectCharacterDeletions: RejectCharacterDeletionsRoot,
		RenderFidelity: RenderFidelityRoot,
		RenderPriority: RenderPriorityRoot,
		RenderingCacheOptimizationMode: RenderingCacheOptimizationModeRoot,
		RenderingTestComparisonMethod: RenderingTestComparisonMethodRoot,
		ReplicateInstanceDestroySetting: ReplicateInstanceDestroySettingRoot,
		ResamplerMode: ResamplerModeRoot,
		ReservedHighlightId: ReservedHighlightIdRoot,
		RestPose: RestPoseRoot,
		ReturnKeyType: ReturnKeyTypeRoot,
		ReverbType: ReverbTypeRoot,
		RibbonTool: RibbonToolRoot,
		RigScale: RigScaleRoot,
		RigType: RigTypeRoot,
		RollOffMode: RollOffModeRoot,
		RolloutState: RolloutStateRoot,
		RotationOrder: RotationOrderRoot,
		RotationType: RotationTypeRoot,
		RtlTextSupport: RtlTextSupportRoot,
		RunContext: RunContextRoot,
		RunState: RunStateRoot,
		RuntimeUndoBehavior: RuntimeUndoBehaviorRoot,
		SafeAreaCompatibility: SafeAreaCompatibilityRoot,
		SalesTypeFilter: SalesTypeFilterRoot,
		SandboxedInstanceMode: SandboxedInstanceModeRoot,
		SaveAvatarThumbnailCustomizationFailure: SaveAvatarThumbnailCustomizationFailureRoot,
		SaveFilter: SaveFilterRoot,
		SavedQualitySetting: SavedQualitySettingRoot,
		ScaleType: ScaleTypeRoot,
		ScopeCheckResult: ScopeCheckResultRoot,
		ScreenInsets: ScreenInsetsRoot,
		ScreenOrientation: ScreenOrientationRoot,
		ScrollBarInset: ScrollBarInsetRoot,
		ScrollingDirection: ScrollingDirectionRoot,
		SecurityCapability: SecurityCapabilityRoot,
		SelectionBehavior: SelectionBehaviorRoot,
		SelectionRenderMode: SelectionRenderModeRoot,
		SelfViewPosition: SelfViewPositionRoot,
		SensorMode: SensorModeRoot,
		SensorUpdateType: SensorUpdateTypeRoot,
		ServerLiveEditingMode: ServerLiveEditingModeRoot,
		ServiceVisibility: ServiceVisibilityRoot,
		Severity: SeverityRoot,
		ShowAdResult: ShowAdResultRoot,
		SignalBehavior: SignalBehaviorRoot,
		SizeConstraint: SizeConstraintRoot,
		SolverConvergenceMetricType: SolverConvergenceMetricTypeRoot,
		SolverConvergenceVisualizationMode: SolverConvergenceVisualizationModeRoot,
		SortDirection: SortDirectionRoot,
		SortOrder: SortOrderRoot,
		SpecialKey: SpecialKeyRoot,
		StartCorner: StartCornerRoot,
		StateObjectFieldType: StateObjectFieldTypeRoot,
		Status: StatusRoot,
		StreamOutBehavior: StreamOutBehaviorRoot,
		StreamingIntegrityMode: StreamingIntegrityModeRoot,
		StreamingPauseMode: StreamingPauseModeRoot,
		StudioCloseMode: StudioCloseModeRoot,
		StudioDataModelType: StudioDataModelTypeRoot,
		StudioPlaceUpdateFailureReason: StudioPlaceUpdateFailureReasonRoot,
		StudioScriptEditorColorCategories: StudioScriptEditorColorCategoriesRoot,
		StudioScriptEditorColorPresets: StudioScriptEditorColorPresetsRoot,
		StudioStyleGuideColor: StudioStyleGuideColorRoot,
		StudioStyleGuideModifier: StudioStyleGuideModifierRoot,
		Style: StyleRoot,
		SubscriptionExpirationReason: SubscriptionExpirationReasonRoot,
		SubscriptionPaymentStatus: SubscriptionPaymentStatusRoot,
		SubscriptionPeriod: SubscriptionPeriodRoot,
		SubscriptionState: SubscriptionStateRoot,
		SurfaceConstraint: SurfaceConstraintRoot,
		SurfaceGuiShape: SurfaceGuiShapeRoot,
		SurfaceGuiSizingMode: SurfaceGuiSizingModeRoot,
		SurfaceType: SurfaceTypeRoot,
		SwipeDirection: SwipeDirectionRoot,
		SystemThemeValue: SystemThemeValueRoot,
		TableMajorAxis: TableMajorAxisRoot,
		TeamCreateErrorState: TeamCreateErrorStateRoot,
		Technology: TechnologyRoot,
		TeleportMethod: TeleportMethodRoot,
		TeleportResult: TeleportResultRoot,
		TeleportState: TeleportStateRoot,
		TeleportType: TeleportTypeRoot,
		TerrainAcquisitionMethod: TerrainAcquisitionMethodRoot,
		TerrainFace: TerrainFaceRoot,
		TextChatMessageStatus: TextChatMessageStatusRoot,
		TextDirection: TextDirectionRoot,
		TextFilterContext: TextFilterContextRoot,
		TextInputType: TextInputTypeRoot,
		TextTruncate: TextTruncateRoot,
		TextXAlignment: TextXAlignmentRoot,
		TextYAlignment: TextYAlignmentRoot,
		TextureMode: TextureModeRoot,
		TextureQueryType: TextureQueryTypeRoot,
		ThreadPoolConfig: ThreadPoolConfigRoot,
		ThrottlingPriority: ThrottlingPriorityRoot,
		ThumbnailSize: ThumbnailSizeRoot,
		ThumbnailType: ThumbnailTypeRoot,
		TickCountSampleMethod: TickCountSampleMethodRoot,
		TonemapperPreset: TonemapperPresetRoot,
		TopBottom: TopBottomRoot,
		TouchCameraMovementMode: TouchCameraMovementModeRoot,
		TouchMovementMode: TouchMovementModeRoot,
		TrackerError: TrackerErrorRoot,
		TrackerExtrapolationFlagMode: TrackerExtrapolationFlagModeRoot,
		TrackerFaceTrackingStatus: TrackerFaceTrackingStatusRoot,
		TrackerLodFlagMode: TrackerLodFlagModeRoot,
		TrackerLodValueMode: TrackerLodValueModeRoot,
		TrackerMode: TrackerModeRoot,
		TrackerPromptEvent: TrackerPromptEventRoot,
		TrackerType: TrackerTypeRoot,
		TriStateBoolean: TriStateBooleanRoot,
		TweenStatus: TweenStatusRoot,
		UICaptureMode: UICaptureModeRoot,
		UIDragDetectorBoundingBehavior: UIDragDetectorBoundingBehaviorRoot,
		UIDragDetectorDragRelativity: UIDragDetectorDragRelativityRoot,
		UIDragDetectorDragSpace: UIDragDetectorDragSpaceRoot,
		UIDragDetectorDragStyle: UIDragDetectorDragStyleRoot,
		UIDragDetectorResponseStyle: UIDragDetectorResponseStyleRoot,
		UIDragSpeedAxisMapping: UIDragSpeedAxisMappingRoot,
		UIFlexAlignment: UIFlexAlignmentRoot,
		UIFlexMode: UIFlexModeRoot,
		UITheme: UIThemeRoot,
		UiMessageType: UiMessageTypeRoot,
		UsageContext: UsageContextRoot,
		UserCFrame: UserCFrameRoot,
		UserInputState: UserInputStateRoot,
		UserInputType: UserInputTypeRoot,
		VRComfortSetting: VRComfortSettingRoot,
		VRControllerModelMode: VRControllerModelModeRoot,
		VRDeviceType: VRDeviceTypeRoot,
		VRLaserPointerMode: VRLaserPointerModeRoot,
		VRSafetyBubbleMode: VRSafetyBubbleModeRoot,
		VRScaling: VRScalingRoot,
		VRSessionState: VRSessionStateRoot,
		VRTouchpad: VRTouchpadRoot,
		VRTouchpadMode: VRTouchpadModeRoot,
		VelocityConstraintMode: VelocityConstraintModeRoot,
		VerticalAlignment: VerticalAlignmentRoot,
		VerticalScrollBarPosition: VerticalScrollBarPositionRoot,
		VibrationMotor: VibrationMotorRoot,
		VideoCaptureResult: VideoCaptureResultRoot,
		VideoDeviceCaptureQuality: VideoDeviceCaptureQualityRoot,
		VideoError: VideoErrorRoot,
		ViewMode: ViewModeRoot,
		VirtualCursorMode: VirtualCursorModeRoot,
		VirtualInputMode: VirtualInputModeRoot,
		VoiceChatDistanceAttenuationType: VoiceChatDistanceAttenuationTypeRoot,
		VoiceChatState: VoiceChatStateRoot,
		VoiceControlPath: VoiceControlPathRoot,
		VolumetricAudio: VolumetricAudioRoot,
		WaterDirection: WaterDirectionRoot,
		WaterForce: WaterForceRoot,
		WebSocketState: WebSocketStateRoot,
		WeldConstraintPreserve: WeldConstraintPreserveRoot,
		WhisperChatPrivacyMode: WhisperChatPrivacyModeRoot,
		WrapLayerAutoSkin: WrapLayerAutoSkinRoot,
		WrapLayerDebugMode: WrapLayerDebugModeRoot,
		WrapTargetDebugMode: WrapTargetDebugModeRoot,
	},
	AccessModifierTypeRoot
	| AccessoryTypeRoot
	| ActionOnAutoResumeSyncRoot
	| ActionOnStopSyncRoot
	| ActionTypeRoot
	| ActuatorRelativeToRoot
	| ActuatorTypeRoot
	| AdAvailabilityResultRoot
	| AdEventTypeRoot
	| AdFormatRoot
	| AdShapeRoot
	| AdTeleportMethodRoot
	| AdUIEventTypeRoot
	| AdUITypeRoot
	| AdUnitStatusRoot
	| AdornCullingModeRoot
	| AlignTypeRoot
	| AlphaModeRoot
	| AnalyticsCustomFieldKeysRoot
	| AnalyticsEconomyActionRoot
	| AnalyticsEconomyFlowTypeRoot
	| AnalyticsEconomyTransactionTypeRoot
	| AnalyticsLogLevelRoot
	| AnalyticsProgressionStatusRoot
	| AnalyticsProgressionTypeRoot
	| AnimationClipFromVideoStatusRoot
	| AnimationPriorityRoot
	| AnimatorRetargetingModeRoot
	| AnnotationEditingModeRoot
	| AnnotationRequestStatusRoot
	| AnnotationRequestTypeRoot
	| AppLifecycleManagerStateRoot
	| AppShellActionTypeRoot
	| AppShellFeatureRoot
	| AppUpdateStatusRoot
	| ApplyStrokeModeRoot
	| AspectTypeRoot
	| AssetCreatorTypeRoot
	| AssetFetchStatusRoot
	| AssetTypeRoot
	| AssetTypeVerificationRoot
	| AudioApiRolloutRoot
	| AudioCaptureModeRoot
	| AudioChannelLayoutRoot
	| AudioFilterTypeRoot
	| AudioSimulationFidelityRoot
	| AudioSubTypeRoot
	| AudioWindowSizeRoot
	| AutoIndentRuleRoot
	| AutomaticSizeRoot
	| AvatarAssetTypeRoot
	| AvatarChatServiceFeatureRoot
	| AvatarContextMenuOptionRoot
	| AvatarGenerationErrorRoot
	| AvatarItemTypeRoot
	| AvatarPromptResultRoot
	| AvatarSettingsAccessoryLimitMethodRoot
	| AvatarSettingsAccessoryModeRoot
	| AvatarSettingsAnimationClipsModeRoot
	| AvatarSettingsAnimationPacksModeRoot
	| AvatarSettingsAppearanceModeRoot
	| AvatarSettingsBuildModeRoot
	| AvatarSettingsClothingModeRoot
	| AvatarSettingsCollisionModeRoot
	| AvatarSettingsCustomAccessoryModeRoot
	| AvatarSettingsCustomBodyTypeRoot
	| AvatarSettingsCustomClothingModeRoot
	| AvatarSettingsHitAndTouchDetectionModeRoot
	| AvatarSettingsJumpModeRoot
	| AvatarSettingsLegacyCollisionModeRoot
	| AvatarSettingsScaleModeRoot
	| AvatarThumbnailCustomizationTypeRoot
	| AvatarUnificationModeRoot
	| AxisRoot
	| BenefitTypeRoot
	| BinTypeRoot
	| BodyPartRoot
	| BodyPartR15Root
	| BorderModeRoot
	| BreakReasonRoot
	| BreakpointRemoveReasonRoot
	| BulkMoveModeRoot
	| BundleTypeRoot
	| ButtonRoot
	| ButtonStyleRoot
	| CageTypeRoot
	| CameraModeRoot
	| CameraPanModeRoot
	| CameraSpeedAdjustBindingRoot
	| CameraTypeRoot
	| CatalogCategoryFilterRoot
	| CatalogSortAggregationRoot
	| CatalogSortTypeRoot
	| CellBlockRoot
	| CellMaterialRoot
	| CellOrientationRoot
	| CenterDialogTypeRoot
	| CharacterControlModeRoot
	| ChatCallbackTypeRoot
	| ChatColorRoot
	| ChatModeRoot
	| ChatPrivacyModeRoot
	| ChatRestrictionStatusRoot
	| ChatStyleRoot
	| ChatVersionRoot
	| ClientAnimatorThrottlingModeRoot
	| CloseReasonRoot
	| CollaboratorStatusRoot
	| CollisionFidelityRoot
	| CommandPermissionRoot
	| CompileTargetRoot
	| CompletionAcceptanceBehaviorRoot
	| CompletionItemKindRoot
	| CompletionItemTagRoot
	| CompletionTriggerKindRoot
	| ComputerCameraMovementModeRoot
	| ComputerMovementModeRoot
	| ConfigSnapshotErrorStateRoot
	| ConnectionErrorRoot
	| ConnectionStateRoot
	| ContentSourceTypeRoot
	| ContextActionPriorityRoot
	| ContextActionResultRoot
	| ControlModeRoot
	| CoreGuiTypeRoot
	| CreateAssetResultRoot
	| CreateOutfitFailureRoot
	| CreatorTypeRoot
	| CreatorTypeFilterRoot
	| CurrencyTypeRoot
	| CustomCameraModeRoot
	| DataStoreRequestTypeRoot
	| DebuggerEndReasonRoot
	| DebuggerExceptionBreakModeRoot
	| DebuggerFrameTypeRoot
	| DebuggerPauseReasonRoot
	| DebuggerStatusRoot
	| DevCameraOcclusionModeRoot
	| DevComputerCameraMovementModeRoot
	| DevComputerMovementModeRoot
	| DevTouchCameraMovementModeRoot
	| DevTouchMovementModeRoot
	| DeveloperMemoryTagRoot
	| DeviceFeatureTypeRoot
	| DeviceFormRoot
	| DeviceLevelRoot
	| DeviceTypeRoot
	| DialogBehaviorTypeRoot
	| DialogPurposeRoot
	| DialogToneRoot
	| DominantAxisRoot
	| DraftStatusCodeRoot
	| DragDetectorDragStyleRoot
	| DragDetectorPermissionPolicyRoot
	| DragDetectorResponseStyleRoot
	| DraggerCoordinateSpaceRoot
	| DraggerMovementModeRoot
	| DraggingScrollBarRoot
	| EasingDirectionRoot
	| EasingStyleRoot
	| EditableStatusRoot
	| ElasticBehaviorRoot
	| EnviromentalPhysicsThrottleRoot
	| ExperienceAuthScopeRoot
	| ExplosionTypeRoot
	| FACSDataLodRoot
	| FacialAgeEstimationResultTypeRoot
	| FacialAnimationStreamingStateRoot
	| FacsActionUnitRoot
	| FeedRankingScoreTypeRoot
	| FieldOfViewModeRoot
	| FillDirectionRoot
	| FilterErrorTypeRoot
	| FilterResultRoot
	| FinishRecordingOperationRoot
	| FluidFidelityRoot
	| FluidForcesRoot
	| FontRoot
	| FontSizeRoot
	| FontStyleRoot
	| FontWeightRoot
	| ForceLimitModeRoot
	| FormFactorRoot
	| FrameStyleRoot
	| FramerateManagerModeRoot
	| FriendRequestEventRoot
	| FriendStatusRoot
	| FunctionalTestResultRoot
	| GameAvatarTypeRoot
	| GamepadTypeRoot
	| GearGenreSettingRoot
	| GearTypeRoot
	| GenreRoot
	| GraphicsModeRoot
	| GraphicsOptimizationModeRoot
	| GuiStateRoot
	| GuiTypeRoot
	| HandlesStyleRoot
	| HapticEffectTypeRoot
	| HighlightDepthModeRoot
	| HorizontalAlignmentRoot
	| HoverAnimateSpeedRoot
	| HttpCachePolicyRoot
	| HttpCompressionRoot
	| HttpContentTypeRoot
	| HttpErrorRoot
	| HttpRequestTypeRoot
	| HumanoidCollisionTypeRoot
	| HumanoidDisplayDistanceTypeRoot
	| HumanoidHealthDisplayTypeRoot
	| HumanoidRigTypeRoot
	| HumanoidStateTypeRoot
	| IKCollisionsModeRoot
	| IKControlConstraintSupportRoot
	| IKControlTypeRoot
	| IXPLoadingStatusRoot
	| ImageAlphaTypeRoot
	| ImageCombineTypeRoot
	| InOutRoot
	| InfoTypeRoot
	| InitialDockStateRoot
	| InputActionTypeRoot
	| InputTypeRoot
	| IntermediateMeshGenerationResultRoot
	| InterpolationThrottlingModeRoot
	| InviteStateRoot
	| ItemLineAlignmentRoot
	| JoinSourceRoot
	| JointCreationModeRoot
	| KeyCodeRoot
	| KeyInterpolationModeRoot
	| KeywordFilterTypeRoot
	| LanguageRoot
	| LeftRightRoot
	| LexemeTypeRoot
	| LightingStyleRoot
	| LimbRoot
	| LineJoinModeRoot
	| ListDisplayModeRoot
	| ListenerLocationRoot
	| ListenerTypeRoot
	| LiveEditingAtomicUpdateResponseRoot
	| LiveEditingBroadcastMessageTypeRoot
	| LoadCharacterLayeredClothingRoot
	| LoadDynamicHeadsRoot
	| LocationTypeRoot
	| MarketplaceBulkPurchasePromptStatusRoot
	| MarketplaceItemPurchaseStatusRoot
	| MarketplaceProductTypeRoot
	| MarkupKindRoot
	| MatchmakingTypeRoot
	| MaterialRoot
	| MaterialPatternRoot
	| MembershipTypeRoot
	| MeshPartDetailLevelRoot
	| MeshPartHeadsAndAccessoriesRoot
	| MeshScaleUnitRoot
	| MeshTypeRoot
	| MessageTypeRoot
	| ModelLevelOfDetailRoot
	| ModelStreamingBehaviorRoot
	| ModelStreamingModeRoot
	| ModerationStatusRoot
	| ModifierKeyRoot
	| MouseBehaviorRoot
	| MoveStateRoot
	| MoverConstraintRootBehaviorModeRoot
	| MuteStateRoot
	| NameOcclusionRoot
	| NetworkOwnershipRoot
	| NetworkStatusRoot
	| NoiseTypeRoot
	| NormalIdRoot
	| NotificationButtonTypeRoot
	| OperationTypeRoot
	| OrientationAlignmentModeRoot
	| OutfitSourceRoot
	| OutfitTypeRoot
	| OutputLayoutModeRoot
	| OverrideMouseIconBehaviorRoot
	| PackagePermissionRoot
	| PartTypeRoot
	| ParticleEmitterShapeRoot
	| ParticleEmitterShapeInOutRoot
	| ParticleEmitterShapeStyleRoot
	| ParticleFlipbookLayoutRoot
	| ParticleFlipbookModeRoot
	| ParticleFlipbookTextureCompatibleRoot
	| ParticleOrientationRoot
	| PathStatusRoot
	| PathWaypointActionRoot
	| PathfindingUseImprovedSearchRoot
	| PermissionLevelShownRoot
	| PhysicsSimulationRateRoot
	| PhysicsSteppingMethodRoot
	| PlatformRoot
	| PlaybackStateRoot
	| PlayerActionsRoot
	| PlayerCharacterDestroyBehaviorRoot
	| PlayerChatTypeRoot
	| PlayerDataErrorStateRoot
	| PlayerDataLoadFailureBehaviorRoot
	| PoseEasingDirectionRoot
	| PoseEasingStyleRoot
	| PositionAlignmentModeRoot
	| PreferredTextSizeRoot
	| PrimalPhysicsSolverRoot
	| PrimitiveTypeRoot
	| PrivilegeTypeRoot
	| ProductLocationRestrictionRoot
	| ProductPurchaseChannelRoot
	| ProductPurchaseDecisionRoot
	| PromptCreateAssetResultRoot
	| PromptCreateAvatarResultRoot
	| PromptPublishAssetResultRoot
	| PropertyStatusRoot
	| ProximityPromptExclusivityRoot
	| ProximityPromptInputTypeRoot
	| ProximityPromptStyleRoot
	| QualityLevelRoot
	| R15CollisionTypeRoot
	| RaycastFilterTypeRoot
	| RejectCharacterDeletionsRoot
	| RenderFidelityRoot
	| RenderPriorityRoot
	| RenderingCacheOptimizationModeRoot
	| RenderingTestComparisonMethodRoot
	| ReplicateInstanceDestroySettingRoot
	| ResamplerModeRoot
	| ReservedHighlightIdRoot
	| RestPoseRoot
	| ReturnKeyTypeRoot
	| ReverbTypeRoot
	| RibbonToolRoot
	| RigScaleRoot
	| RigTypeRoot
	| RollOffModeRoot
	| RolloutStateRoot
	| RotationOrderRoot
	| RotationTypeRoot
	| RtlTextSupportRoot
	| RunContextRoot
	| RunStateRoot
	| RuntimeUndoBehaviorRoot
	| SafeAreaCompatibilityRoot
	| SalesTypeFilterRoot
	| SandboxedInstanceModeRoot
	| SaveAvatarThumbnailCustomizationFailureRoot
	| SaveFilterRoot
	| SavedQualitySettingRoot
	| ScaleTypeRoot
	| ScopeCheckResultRoot
	| ScreenInsetsRoot
	| ScreenOrientationRoot
	| ScrollBarInsetRoot
	| ScrollingDirectionRoot
	| SecurityCapabilityRoot
	| SelectionBehaviorRoot
	| SelectionRenderModeRoot
	| SelfViewPositionRoot
	| SensorModeRoot
	| SensorUpdateTypeRoot
	| ServerLiveEditingModeRoot
	| ServiceVisibilityRoot
	| SeverityRoot
	| ShowAdResultRoot
	| SignalBehaviorRoot
	| SizeConstraintRoot
	| SolverConvergenceMetricTypeRoot
	| SolverConvergenceVisualizationModeRoot
	| SortDirectionRoot
	| SortOrderRoot
	| SpecialKeyRoot
	| StartCornerRoot
	| StateObjectFieldTypeRoot
	| StatusRoot
	| StreamOutBehaviorRoot
	| StreamingIntegrityModeRoot
	| StreamingPauseModeRoot
	| StudioCloseModeRoot
	| StudioDataModelTypeRoot
	| StudioPlaceUpdateFailureReasonRoot
	| StudioScriptEditorColorCategoriesRoot
	| StudioScriptEditorColorPresetsRoot
	| StudioStyleGuideColorRoot
	| StudioStyleGuideModifierRoot
	| StyleRoot
	| SubscriptionExpirationReasonRoot
	| SubscriptionPaymentStatusRoot
	| SubscriptionPeriodRoot
	| SubscriptionStateRoot
	| SurfaceConstraintRoot
	| SurfaceGuiShapeRoot
	| SurfaceGuiSizingModeRoot
	| SurfaceTypeRoot
	| SwipeDirectionRoot
	| SystemThemeValueRoot
	| TableMajorAxisRoot
	| TeamCreateErrorStateRoot
	| TechnologyRoot
	| TeleportMethodRoot
	| TeleportResultRoot
	| TeleportStateRoot
	| TeleportTypeRoot
	| TerrainAcquisitionMethodRoot
	| TerrainFaceRoot
	| TextChatMessageStatusRoot
	| TextDirectionRoot
	| TextFilterContextRoot
	| TextInputTypeRoot
	| TextTruncateRoot
	| TextXAlignmentRoot
	| TextYAlignmentRoot
	| TextureModeRoot
	| TextureQueryTypeRoot
	| ThreadPoolConfigRoot
	| ThrottlingPriorityRoot
	| ThumbnailSizeRoot
	| ThumbnailTypeRoot
	| TickCountSampleMethodRoot
	| TonemapperPresetRoot
	| TopBottomRoot
	| TouchCameraMovementModeRoot
	| TouchMovementModeRoot
	| TrackerErrorRoot
	| TrackerExtrapolationFlagModeRoot
	| TrackerFaceTrackingStatusRoot
	| TrackerLodFlagModeRoot
	| TrackerLodValueModeRoot
	| TrackerModeRoot
	| TrackerPromptEventRoot
	| TrackerTypeRoot
	| TriStateBooleanRoot
	| TweenStatusRoot
	| UICaptureModeRoot
	| UIDragDetectorBoundingBehaviorRoot
	| UIDragDetectorDragRelativityRoot
	| UIDragDetectorDragSpaceRoot
	| UIDragDetectorDragStyleRoot
	| UIDragDetectorResponseStyleRoot
	| UIDragSpeedAxisMappingRoot
	| UIFlexAlignmentRoot
	| UIFlexModeRoot
	| UIThemeRoot
	| UiMessageTypeRoot
	| UsageContextRoot
	| UserCFrameRoot
	| UserInputStateRoot
	| UserInputTypeRoot
	| VRComfortSettingRoot
	| VRControllerModelModeRoot
	| VRDeviceTypeRoot
	| VRLaserPointerModeRoot
	| VRSafetyBubbleModeRoot
	| VRScalingRoot
	| VRSessionStateRoot
	| VRTouchpadRoot
	| VRTouchpadModeRoot
	| VelocityConstraintModeRoot
	| VerticalAlignmentRoot
	| VerticalScrollBarPositionRoot
	| VibrationMotorRoot
	| VideoCaptureResultRoot
	| VideoDeviceCaptureQualityRoot
	| VideoErrorRoot
	| ViewModeRoot
	| VirtualCursorModeRoot
	| VirtualInputModeRoot
	| VoiceChatDistanceAttenuationTypeRoot
	| VoiceChatStateRoot
	| VoiceControlPathRoot
	| VolumetricAudioRoot
	| WaterDirectionRoot
	| WaterForceRoot
	| WebSocketStateRoot
	| WeldConstraintPreserveRoot
	| WhisperChatPrivacyModeRoot
	| WrapLayerAutoSkinRoot
	| WrapLayerDebugModeRoot
	| WrapTargetDebugModeRoot
	| ZIndexBehaviorRoot
>
