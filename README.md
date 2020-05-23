# twin-tower-hanoi-game-in-asm

This repo contains an assembly code solution for solving the Tower of Hanoi puzzle

### What's the twin-tower-hanoi game?

The Tower of Hanoi is a mathematical game for moving a set of N disks stacked in the order of decreasing size from one pile to another (using a spare pile) one disk at a time without ever placing a larger disk on top of a smaller disk. The Twin Tower of Hanoi (or Bicolor Tower of Hanoi) is derived from the Tower of Hanoi with the following modifications:
 
 1. Initially, there are 2 piles of dishes, each pile with different colors but with the same number of disks of matching sizes.
 2. The goal of the game is to swap the dishes in one stack with the dishes in the other stack as shown below

![img](https://github.com/CoorFun/twin-tower-hanoi-game-in-asm/edit/master/img.png)

# Report of my solution

### Introduction

The main propose of this project is to achieve a set of assembly instructions which can solve the twin-tower-hanoi game. This report mainly talk about how I step by step finished the code and the main issues I found during the project running. Finally I will propose my conclusion and feelings about this project.

### Way to Learn

The first step I took is to understand the question ‘How does the iteration algorithm work?’. The best way to figure out this theory is to realise an algorithm to solve the Single Tower Hanoi Game.
After amount of time of thinking, it occurs to me that there are mainly 3 steps to finish a single hanoi puzzle: Move N-1 dishes to temporary pile, move the lowest one to destination, move the N-1 dishes from temporary to destination. As long as the lowest dish had been moved, the question becomes exactly alike the original one. The only difference between is N becomes N-1. So, that’s why only one function needed to solve the single tower game.
In a similar way, all the functions provided to solve twin tower game follow the same principle. When we completely understand the scenario provided for twin tower game, it also becomes easier to translate it into assembly code.

### Difficulities & Solutions

During the translation, I mainly met three problems which can be concluded as following.

#### I. Map A, B and C with 0, 1 and 2

In the C language, we can easily use characters to represent different piles. But for assembly language, only numbers can be accepted. So I made a dual-step checking to decide which move should be executed.

#### II. Parameter mix up when iterate

In assembly language, each parameter is passed via register when a procedure call has been made. So to keep the parameter in the original order when a in-function call complete, it’s necessary to push the previous parameters into stack and pop out when sub procedure finish.

#### III. Difficult to debug

Since the code has amount of iterations and stack operations, it becomes difficult to set breakout points. So I used Xcode to list out all the iterations so that I can know the value of N and the order of parameters(Pile). With these clear information, I finally executed the code successfully.

### Conclusion

The significant challenge of this project is to clearly understand the iteration and work it out in assembly language. After completed this project, I realised that assembly code is not that difficult to understand but it’s actually difficult to code, because of its heavy work for a simple task. But another thing I want to point out is, although the assembly language is not easy to program, but it can definitely make a specific task as optimised as possible and compactly hardware associated.

## Directory Details

- C_Code   [Twin-Tower-Hanoi Game algorithm]
- Tools    [Tools used to debug]
 -- NIOS   [Sumulator based on Windows]]
 -- JNISS  [Simulator based on Java]
Code.s     [ASM Code]
