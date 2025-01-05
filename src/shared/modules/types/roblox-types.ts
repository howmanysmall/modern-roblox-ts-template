//!optimize 2

import { Flamework } from "@flamework/core";

export interface FriendData {
	readonly DisplayName: string;
	readonly Id: number;
	readonly IsOnline: boolean;
	readonly Username: string;
}
export const isFriendData = Flamework.createGuard<FriendData>();
