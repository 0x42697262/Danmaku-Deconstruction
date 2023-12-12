# Danmaku-Deconstruction

A streamlined LAN-based multiplayer bullet hell game up to 8 players.

# Contributing

To contribute, fork the repository and clone it to your local machine. After making your changes, submit a [Pull Request](https://github.com/0x42697262/Danmaku-Deconstruction/pulls) to propose the integration of your updates. Thank you for contributing!

# Documentation

Any changes made to the game project settings and game mechanics should be documented in the `docs` directory.

You can start documenting your scripts with [GDScript documentation comments](https://docs.godotengine.org/en/4.0/tutorials/scripting/gdscript/gdscript_documentation_comments.html).

`docs` directory is generated using [gdscripts-docs-maker](https://github.com/GDQuest/gdscript-docs-maker#writing-your-code-reference).


# Game Description

Danmaku Deconstruction is a skill-based free-for-all multiplayer 2D bullet hell that challenges payers 

to dodge complex patterns of spawned bullets based on a beatmap similar to OSU. This game is designed for

local area network (LAN) play, accomodating up to 8 players simultaneously. Players can move using their mouse. 

They can collect stars to increase their HP. Stars not collected will explode into a group of bullets.

At the beginning of the game, players will have an initial hp of 30. Every collision with

bullet will deduct 10 hp. The last player to survive wins the game.
