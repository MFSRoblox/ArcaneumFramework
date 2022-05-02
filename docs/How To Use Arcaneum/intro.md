---
sidebar_position: 2
---

## Why was Arcaneum made?
Arcaneum was made as a response to working in projects that quickly turned into [Big Balls of Mud.](https://thedomaindrivendesign.io/big-ball-of-mud/).

The following factors caused this to happen:

- Monolith scripts acting as a universal service composed of multiple systems within itself
- Convoluted system interactions such that changing one system is likely to break or neglect multiple other systems
- Repeated code and systems in multiple scripts make maintaining and updating those codes a hastle
- Lack of unit testing in the code.

## Why should you use Arcaneum?
Arcaneum is a framework that provides modules that allow for Object Oriented Programming style code to be made. Alongside that, minor utilities are included to help manage the many services and instances that ROBLOX provides in its environment.

## Basics of making a new custom class
### What is a class?
A class is a template that defines what something is and how it functions. It is commonly used to create "Objects," which is the  

### What is it in Arcaneum?
A class in an Arcaneum sense is a table that will be used as a foundation by other modules.

#### Usage of Arcaneum's fundamental classes
Arcaneum comes with five fundamental classes:
- [BaseClass]
    - [DataType]
    - [Class]
        - [InternalClass]
        - [ExternalClass]

Each of these classes serve unique purposes to help manage varying functionality and memory usage.

The [BaseClass] is the foundation of every class in the framework. Classes derived from this are expected to NOT interact with any ROBLOX services. It is expected for a ClassName, Version, and CoreModule to be present, and offers the functionality for Extending, Version Verification, and Destroying (garbage control). Examples of systems made from this would be utility and singleton classes.

[Class] is a class that is derived from [BaseClass], and was created for systems that would need to manage [RBXScriptConnections]. Anything extended from this will be provided with the [AddConnection] and [RemoveConnection] methods, which will allow you to manage your RBXScriptConnections within your class without worrying about the logistics to disconnect them. All connections in a Class object will be disconnected if said object were to be destroyed. 

## How is inheritance done in Arcaneum?
Inheritance is done by "extending" from the base class using the "Extend" method. 

##

## Basics of making a new DataType
### What is a DataType
A low level object used to represent information that can be compared to other things of the same datatype.
A class that is meant to be compared to other objects of the same class.

### Examples of a custom DataType


## Basics of creating services from classes
### What is a service?

## Testing Your Code
Arkaneum comes with a Test module that allows you to test code with ease. When 