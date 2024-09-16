//!optimize 2

import { Flamework } from "@flamework/core";
import sharedStartup from "shared/modules/shared-startup";

sharedStartup();

Flamework.addPaths("src/client/components");
Flamework.addPaths("src/client/controllers");
Flamework.addPaths("src/shared/components");

Flamework.ignite();
