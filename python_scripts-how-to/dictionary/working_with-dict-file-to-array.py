#!/usr/bin/env python3
"""
Write and test a function that takes a collection of strings and returns the
length of the longest string in the collection.
The application should loop through the collection of strings and rely on the
value returned by the function to format all of the strings to the output such
that they are all right justified to the width of the longest string.
"""


import random


def main():
    """
    Function loops through wordarray a total of 10 times
    Each time through the loop, tests len(str) only printing the string and len
    of the longest found word
    """
    x = get_total()
    count = 1
    wordarray = build_array()
    longeststr = 0
    while count <= 5:
        wordnum = random.randint(1, x)
        getword = wordarray[wordnum]
        print(f"{count}: {wordnum} - {getword}")
        if len(getword) > longeststr:
            longeststr = int(len(getword))
            longestword = str(getword)
        count += 1

    print(f"\nLongest String: {longeststr}\t"
          f"Longest Word: {longestword}\n")


def build_array():
    # Read /usr/share/dict/words to an array
    with open('/usr/share/dict/words', 'r') as words:
        lines = words.readlines()
        wordarray = [line.strip() for line in lines]

        # Return the list of words
    return wordarray


def get_total():
    with open(r"/usr/share/dict/words", 'r') as words:
        x = len(words.readlines())
        return x


if __name__ == "__main__":
    main()
