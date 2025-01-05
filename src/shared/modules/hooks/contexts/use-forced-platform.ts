//!optimize 2

import { useContext } from "@rbxts/react";
import ForcedPlatformContext from "shared/modules/contexts/forced-platform-context";
import type DevicePlatform from "shared/modules/meta/device-platform";

export default function useForcedPlatform(): DevicePlatform | undefined {
	return useContext(ForcedPlatformContext);
}
