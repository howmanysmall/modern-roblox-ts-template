import type { Binding } from "@rbxts/react";

export type BindingOrValue<T> = Binding<T> | T;

export type OnActivated<T extends GuiButton = GuiButton> = (rbx: T, inputObject: InputObject, count: number) => void;
export type OnInput<T extends GuiObject = GuiObject> = (rbx: T, inputObject: InputObject) => void;

export interface ReactReferenceObject<T> {
	current?: T;
}
export type ReactReferenceCallback<T> = (instance?: T) => void;
export type ReactReference<T> = ReactReferenceCallback<T> | ReactReferenceObject<T> | undefined;
