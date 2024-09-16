import { GlobalEvents, GlobalFunctions } from "shared/network";

export const Events = GlobalEvents.createServer({
	disableIncomingGuards: false,
});
export const Functions = GlobalFunctions.createServer({
	disableIncomingGuards: false,
});
