# Uplifting

Uplifting is an elevator simulator.

You can write your own script to control the elevators and move all the dudes to their floor as quick as possible.

## Installation

Install the required dependencies with

```sh
$ bundle install
```

## Usage

```sh
$ ./master.rb sample_elevator.rb
```

This command will run a very simple script against a sample elevator. You can pass in a different file to run the script against your own elevator.

## Playing

Write your own `Elevator` subclass in Ruby, along the lines of the code in `sample_elevator.rb`.

Run your elevator code against the script and see how good your score is.

## Concept

Uplifting is based on 3 components:

 * The **script** determines events, such as spawning a new person waiting for an elevator
 * The **elevator** responds to events (such as pressing the button for a floor) and moves the elevator
 * The **engine** runs the script against the elevator and computes the score at the end

A way of thinking about is is *script vs. elevator*: you can write a script to make life harder for the elevator, or you can write an elevator code to better adapt to a script.

## Disclaimer

The code is still in the first phase of development, so everything (including the API) is subject to change without warning ;)
