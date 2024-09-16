//!optimize 2

import useEventConnection from "./use-event-connection";
import { useState } from "@rbxts/react";
import { Workspace } from "@rbxts/services";

export default function useCurrentCamera() {
	const [currentCamera, setCurrentCamera] = useState(Workspace.CurrentCamera!);

	useEventConnection(
		Workspace.GetPropertyChangedSignal("CurrentCamera"),
		() => {
			const replacement = Workspace.CurrentCamera;
			if (replacement) setCurrentCamera(replacement);
		},
		[],
	);

	return currentCamera;
}
