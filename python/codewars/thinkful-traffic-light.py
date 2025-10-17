
# You're writing code to control your town's traffic lights.
# You need a function to handle each change from green, to yellow, to red, and then to green again.

# Complete the function that takes a string as an argument representing the current state of the light
# and returns a string representing the state the light should change to.

# For example, when the input is green, output should be yellow.

# I need if else statements
# I need a list of the colours
# Function needs to check string, then look for that exact string (colour name) in my list, and return the very
# next value in my list.

def update_light(current):
    traffic_colours = ["green", "yellow", "red", "green"]
    if current == "green":
        return traffic_colours[1]
    elif current == "yellow":
        return traffic_colours[2]
    else:
        return traffic_colours[3]

print(update_light("green"))