---
sidebar_position: 2
---

# File Locations

Upon requiring the ArcaneumEngine module on the server, it will set up the locations for each sub-module, splitting such that the "Global" module is placed into ReplicatedStorage and renamed to "Arcaneum." This allows other scripts to access the globals at any given time via ```ReplicatedStorage.Arcaneum```.

When a player joins the server, the [PlayerManager] will copy the ArcaneumEngine module 