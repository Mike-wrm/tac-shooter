# AI

This folder contains the most interesting bits of AI code I have written.

## Behavioural Control

Presently, a FSM (finite state machine) is used to determine what actions an NPC should take and communicates with the appropriate nodes (PathfdingMaster, MovementMaster, etc.) to carry out those actions. A FSM with a flat hierarchy is fairly limiting, so I am currently working on overhauling it into a HFSM (hierarchal FSM).

### FSM Classes

- Behaviour - the FSM itself. Contains states connected by any number of links to form a directional graph
- State - a state of being where actions are executed on state entry, exit, and while it is active
- Action - a collection of subroutines for doing the "dirty work": moving, attacking, animation, etc.
- Link - helps the FSM transition to the next state once "triggered": its conditional test is met

## Locomotion

Navigation polygons are added to individual tiles on the tilemap. The engine then automatically bakes a navmesh (navigation mesh) from these polygons at runtime. The ubiquitous A* pathfinding algorithm uses the navmesh as the basis to create a path for characters to follow.

To reduce coupling and increase project modularity, all "nitty-gritty" details pertaining to pathfinding are contained within the PathfindingMaster scene; details pertaining to movement are contained in the MovementMaster scene; and so on.