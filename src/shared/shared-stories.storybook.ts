//!optimize 2

import type { Storybook } from "@rbxts/ui-labs";

const SharedStorybook: Storybook = {
	groupRoots: true,
	name: "Shared",
	storyRoots: [script.Parent!.FindFirstChild("__stories__")!],
};

export = SharedStorybook;
