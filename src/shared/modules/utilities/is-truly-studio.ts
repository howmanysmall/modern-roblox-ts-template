/// <reference types="@rbxts/types/plugin" />
//!optimize 2

import { RunService } from "@rbxts/services";

function getNetworkClient(): NetworkClient | undefined {
	return game.FindService("NetworkClient") as NetworkClient | undefined;
}
function getClientReplicator(networkClient: NetworkClient): ClientReplicator | undefined {
	return networkClient.FindFirstChildOfClass("ClientReplicator");
}
function hasClientReplicator(): boolean {
	const [serviceSuccess, networkClient] = pcall(getNetworkClient);
	if (!serviceSuccess || !networkClient) return false;

	const [findSuccess, clientReplicator] = pcall(getClientReplicator, networkClient);
	return findSuccess && clientReplicator !== undefined;
}

export default function isTrulyStudio(): boolean {
	if (!RunService.IsStudio()) return false;
	if (!RunService.IsRunning() && hasClientReplicator()) return true;
	return !RunService.IsRunning() && RunService.IsClient() && RunService.IsServer();
}
