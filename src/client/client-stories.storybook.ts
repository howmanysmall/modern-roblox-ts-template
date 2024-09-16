//!optimize 2

import type { Storybook } from "@rbxts/ui-labs";

const ClientStorybook: Storybook = {
	groupRoots: true,
	name: "Client",
	storyRoots: [script.Parent!.FindFirstChild("__stories__")!],
};

export = ClientStorybook;
