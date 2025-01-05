//!optimize 2

import useScalePlatform from "./use-scale-platform";
import type { Binding } from "@rbxts/react";
import DevicePlatform from "shared/modules/meta/device-platform";

export type ModifyWith = { readonly [devicePlatform in DevicePlatform]?: number };

export default function useStandardScale(modifyWith?: ModifyWith): Binding<number> {
	return useScalePlatform(
		{
			[DevicePlatform.Desktop]: 1,
			[DevicePlatform.Mobile]: 2,
			[DevicePlatform.Tablet]: 1.85,
			baseScale: 1,
			...modifyWith,
		},
		new Vector3(1920, 1080),
	);
}
