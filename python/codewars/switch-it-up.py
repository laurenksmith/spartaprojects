# When provided with a number between 0-9, return it in words. Note that the input is guaranteed to be within the range of 0-9.
#
# Input: 1
#
# Output: "One".
#
# If your language supports it, try using a switch statement.

def switch_it_up(number):
    if number == 0:
        return "Zero"
    elif number == 1:
        return "One"
    elif number == 2:
        return "Two"
    elif number == 3:
        return "Three"
    elif number == 4:
        return "Four"
    elif number == 5:
        return "Five"
    elif number == 6:
        return "Six"
    elif number == 7:
        return "Seven"
    elif number == 8:
        return "Eight"
    else:
        return "Nine"

# Top Solution on Code Wars (much simpler!!):
# def switch_it_up(n):
    return ['Zero','One','Two','Three','Four','Five','Six','Seven','Eight','Nine'][n]