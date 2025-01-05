//!optimize 2

import type DevicePlatform from "../meta/device-platform";
import { createContext } from "@rbxts/react";

export const ForcedPlatformContext = createContext<DevicePlatform | undefined>(undefined);
ForcedPlatformContext.displayName = "ForcedPlatformContext";
export default ForcedPlatformContext;
