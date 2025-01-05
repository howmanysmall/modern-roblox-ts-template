//!optimize 2

import DevicePlatform from "../meta/device-platform";
import { GuiService, UserInputService, Workspace } from "@rbxts/services";

const [TOP_LEFT, BOTTOM_RIGHT] = GuiService.GetGuiInset();

export function getViewportSize(): Vector2 {
	const currentCamera = Workspace.CurrentCamera;
	return currentCamera?.ViewportSize ?? Vector2.zero;
}

export function getViewportSizeWithInset(): Vector2 {
	const currentCamera = Workspace.CurrentCamera;
	return (currentCamera?.ViewportSize ?? new Vector2(1280, 720)).sub(TOP_LEFT).sub(BOTTOM_RIGHT);
}

export function getDevicePlatform(): DevicePlatform {
	if (UserInputService.GamepadEnabled && GuiService.IsTenFootInterface()) return DevicePlatform.Console;

	if (UserInputService.TouchEnabled) {
		const currentCamera = Workspace.CurrentCamera;
		const viewportSize = currentCamera?.ViewportSize ?? Vector2.zero;
		return viewportSize.X >= 1023 && viewportSize.Y >= 767 ? DevicePlatform.Tablet : DevicePlatform.Mobile;
	}

	return UserInputService.KeyboardEnabled ? DevicePlatform.Desktop : DevicePlatform.Unknown;
}
