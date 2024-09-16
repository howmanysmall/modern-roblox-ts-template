import { GlobalEvents, GlobalFunctions } from "shared/network";

export const Events = GlobalEvents.createClient({
	disableIncomingGuards: true,
});
export const Functions = GlobalFunctions.createClient({
	disableIncomingGuards: true,
});
