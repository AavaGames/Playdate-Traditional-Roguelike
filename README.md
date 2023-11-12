# Tyalband, Oronmaril

The INACTIVE repo for Tyalband, a traditional roguelike for the Playdate console. Download the demo here (https://aavagames.itch.io/tyalband)

Feel free to use any of my code. You can send me questions on [mastodon](https://peoplemaking.games/@aava) or [twitter](https://twitter.com/AavaGames).

#

Within the mountain of glass named Oronmaril lies an ancient artifact. The Chosen Lord will reward anyone with great riches who returns their sacred artifact.

Delve into the depths of the mountain of clear crystal. Darkness and death await you. In a place where the monsters see you first how do you navigate safely?

## Code of Interest
Some neat things that might inspire or be useful in your projects.

- Dijkstra  / Distance Maps in C (/src/DistanceMap & CollisionMask)
  - Pathfinding basically through floodmaps, read more about their myriad uses [here!](https://www.roguebasin.com/index.php?title=The_Incredible_Power_of_Dijkstra_Maps)
- PD Keyboard based Menu (/Source/scripts/ui/*)
  - A menu that uses the PD keyboard for selection and navigation, automatically creates additional pages once options overflow
  - Setup in a similar syntax style to playdate's system menu (function execution, toggle bool, cycle list)
- Terminal-like Grid Graphics (/Source/Screenmanager, Level:draw)
  - Glyph based world drawing akin to traditional terminal roguelikes
  - Required extensive loop optimizations for satisfactory performance on the limited hardware
- Actor + Component System

#

This project uses C and Lua. C is primarily used for expensive calculations (pathfinding via Dijkstra maps), while the game's loop is in Lua.
Uses the [Whitebrim Playdate Project](https://github.com/Whitebrim/VSCode-PlaydateTemplate) template to compile and simulate for Lua and a custom CMake pipeline for C.
