//!optimize 2

import React from "@rbxts/react";
import ForcedPlatformContext from "shared/modules/contexts/forced-platform-context";
import type DevicePlatform from "shared/modules/meta/device-platform";

export interface ForcedPlatformProviderProperties extends React.PropsWithChildren {
	readonly forcedPlatform?: DevicePlatform;
}

export function ForcedPlatformProviderNoMemo({
	children,
	forcedPlatform,
}: ForcedPlatformProviderProperties): React.Element {
	return forcedPlatform === undefined ? (
		<>{children}</>
	) : (
		<ForcedPlatformContext.Provider value={forcedPlatform}>{children}</ForcedPlatformContext.Provider>
	);
}

export const ForcedPlatformProvider = React.memo(ForcedPlatformProviderNoMemo);
ForcedPlatformProvider.displayName = "ForcedPlatformProvider";
export default ForcedPlatformProvider;
