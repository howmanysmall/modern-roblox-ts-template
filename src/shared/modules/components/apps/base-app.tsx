//!optimize 2

import ForcedPlatformProvider from "../providers/forced-platform-provider";
import ContextStack from "@rbxts/context-stack";
import React, { StrictMode, useMemo } from "@rbxts/react";
import { RunService } from "@rbxts/services";
import type DevicePlatform from "shared/modules/meta/device-platform";
import type { AnyArray } from "shared/modules/types/utility-types";

const IS_STUDIO = RunService.IsStudio();

export interface BaseAppProperties extends React.PropsWithChildren {
	readonly forcedPlatform?: DevicePlatform;
	readonly providers?: AnyArray<React.ReactElement>;
	readonly usingStrictMode?: boolean;
}

export function BaseAppNoMemo({
	children,
	forcedPlatform,
	providers,
	usingStrictMode = IS_STUDIO,
}: BaseAppProperties): React.Element {
	const newProviders = useMemo((): Array<React.Element> => {
		const newProviders: Array<React.Element> = [];
		let length = newProviders.size();

		if (forcedPlatform !== undefined)
			newProviders[length++] = (
				<ForcedPlatformProvider forcedPlatform={forcedPlatform} key="ForcedPlatformProvider" />
			);

		if (providers) {
			const providersLength = providers.size();
			providers.move(0, providersLength - 1, length, newProviders);
			length += providersLength;
		}

		return newProviders;
	}, [forcedPlatform, providers]);

	const stackElement = (
		<ContextStack key="ContextStack" providers={newProviders}>
			{children}
		</ContextStack>
	);

	return usingStrictMode ? <StrictMode>{stackElement}</StrictMode> : stackElement;
}

export const BaseApp = React.memo(BaseAppNoMemo);
BaseApp.displayName = "BaseApp";
export default BaseApp;
