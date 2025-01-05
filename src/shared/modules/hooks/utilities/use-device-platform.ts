//!optimize 2

import useForcedPlatform from "../contexts/use-forced-platform";
import { type Binding, useBinding } from "@rbxts/react";
import { useEventConnection } from "@rbxts/react-hooks";
import { UserInputService } from "@rbxts/services";
import type DevicePlatform from "shared/modules/meta/device-platform";
import { getDevicePlatform } from "shared/modules/utilities/device-utilities";
import isTrulyStudio from "shared/modules/utilities/is-truly-studio";

const IS_STUDIO = isTrulyStudio();

export default function useDevicePlatform(forcedDevicePlatform?: DevicePlatform): Binding<DevicePlatform> {
	const forcedPlatform = useForcedPlatform();
	const [platform, setPlatform] = useBinding(
		IS_STUDIO ? (forcedPlatform ?? forcedDevicePlatform ?? getDevicePlatform()) : getDevicePlatform(),
	);

	useEventConnection(
		UserInputService.LastInputTypeChanged,
		() => {
			const newPlatform = IS_STUDIO
				? (forcedPlatform ?? forcedDevicePlatform ?? getDevicePlatform())
				: getDevicePlatform();
			if (newPlatform !== platform.getValue()) setPlatform(newPlatform);
		},
		[forcedDevicePlatform, forcedPlatform],
	);

	return platform;
}
