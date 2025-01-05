//!optimize 2

import useDevicePlatform from "./use-device-platform";
import { type Binding, joinBindings } from "@rbxts/react";
import { useViewportSize } from "@rbxts/react-hooks";
import { GuiService } from "@rbxts/services";
import DevicePlatform from "shared/modules/meta/device-platform";

const [TOP_LEFT, BOTTOM_RIGHT] = GuiService.GetGuiInset();

type Platforms = { readonly [devicePlatform in DevicePlatform]?: number };
export interface ScaleParameters extends Platforms {
	readonly baseScale: number;
}

export default function useScalePlatform(
	scaleParameters: ScaleParameters,
	goalSize: Vector2 | Vector3,
	forcedDevicePlatform?: DevicePlatform,
): Binding<number> {
	return joinBindings({
		devicePlatform: useDevicePlatform(forcedDevicePlatform),
		viewportSize: useViewportSize(),
	}).map(({ devicePlatform, viewportSize }) => {
		const size = viewportSize.sub(TOP_LEFT).add(BOTTOM_RIGHT);
		const scale = scaleParameters[devicePlatform] ?? scaleParameters.baseScale;
		return (1 / math.max(goalSize.X / size.X, goalSize.Y / size.Y)) * scale;
	});
}
