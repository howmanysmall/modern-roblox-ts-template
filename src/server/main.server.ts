//!optimize 2

import { Flamework } from "@flamework/core";
import sharedStartup from "shared/modules/shared-startup";

sharedStartup();

Flamework.addPaths("src/server/components");
Flamework.addPaths("src/server/services");
Flamework.addPaths("src/shared/components");

Flamework.ignite();
