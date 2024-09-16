//!optimize 2

import type { Storybook } from "@rbxts/ui-labs";

const ServerStorybook: Storybook = {
	groupRoots: true,
	name: "Server",
	storyRoots: [script.Parent!.FindFirstChild("__stories__")!],
};

export = ServerStorybook;
