# Untitled Tactical Shooter

This untitled top-down tactical shooter is a joint effort between a friend and myself. It is written in the python-like GDScript language for the C++-based Godot engine. The code posted here will mostly be my own work, but may include work from my friend as well. Please note that as this is sample code for a work-in-progress, **the code is neither the most recent nor does it work in isolation.** You can see the code in action as it continues to be iterated upon [here on YouTube](https://www.youtube.com/playlist?list=PLVcPx-feacJ0T9ml_0mHmYE72W1p6i3ax).

### Brief GDScript Summary
[GDScript reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

- Is a very python-like OOP language: tab-based indentation, duck typing, etc
- Is parsed and compiled as C++ at runtime
- A game is made up of a [scene tree](https://docs.godotengine.org/fi/stable/_images/key_concepts_scene_tree.png)
	- A scene (.tscn; media icon) is itself a tree of more scenes/nodes 
	- A node can itself be another scene or a simple object like a UI element
	- A script (.gd; scroll icon) can be attached to nodes to give them logic
- Within a script (.gd):
	- _ready() and @ready are used for node initialization prior to the game loop
	- _process(delta) runs every frame
	- _physics_process(delta) runs every physics frame (60Hz)
