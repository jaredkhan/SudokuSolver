# SudokuLib + sudoku

A Swift sudoku solver.
 
Solves puzzles by searching for 'singles', 'doubles', 'triples', etc. 
That is, it looks for groups of n cells in the same box, row, or column, where those cells can only contain n possible digits between them. 
Any cell not in that group but visible to all n cells in the group now cannot contain any of those digits.

For example: if a group of three cells in a box can only contain the digits \[1, 2, and 3\], 
then those digits cannot appear elsewhere in the box, else there would not be enough possible values to fill the original three cells.  

Inspired by Soroush Khanlou's talk: [Solving Sudoku in Swift](https://www.youtube.com/watch?v=7EaEkakTVZk). 

Example usage:
```
$ swift run sudoku --verbose --grid 34...7.26.2...48.1..12.5...25.6.....68.9..34..1.4.2..816..89.3.4.................
┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓
┃ 3 │ 4 │   ┃   │   │ 7 ┃   │ 2 │ 6 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃   │ 2 │   ┃   │   │ 4 ┃ 8 │   │ 1 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃   │   │ 1 ┃ 2 │   │ 5 ┃   │   │   ┃
┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
┃ 2 │ 5 │   ┃ 6 │   │   ┃   │   │   ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 6 │ 8 │   ┃ 9 │   │   ┃ 3 │ 4 │   ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃   │ 1 │   ┃ 4 │   │ 2 ┃   │   │ 8 ┃
┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
┃ 1 │ 6 │   ┃   │ 8 │ 9 ┃   │ 3 │   ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 4 │   │   ┃   │   │   ┃   │   │   ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃   │   │   ┃   │   │   ┃   │   │   ┃
┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛
Deduced that cells [55] must contain digits [6]
Deduced that cells [27] must contain digits [2]
Deduced that cells [36] must contain digits [6]
Deduced that cells [61] must contain digits [3]
Deduced that cells [17] must contain digits [1]
Deduced that cells [59] must contain digits [9]
Deduced that cells [53] must contain digits [8]
Deduced that cells [21] must contain digits [2]
Deduced that cells [23] must contain digits [5]
Deduced that cells [48] must contain digits [4]
Deduced that cells [15] must contain digits [8]
Deduced that cells [43] must contain digits [4]
Deduced that cells [10] must contain digits [2]
Deduced that cells [7] must contain digits [2]
Deduced that cells [30] must contain digits [6]
Deduced that cells [0] must contain digits [3]
Deduced that cells [1] must contain digits [4]
Deduced that cells [42] must contain digits [3]
Deduced that cells [20] must contain digits [1]
Deduced that cells [63] must contain digits [4]
Deduced that cells [2, 38, 11, 65, 56, 74, 47] must contain digits [8, 9, 6, 3, 2, 7, 5]
Deduced that cells [5] must contain digits [7]
Deduced that cells [37] must contain digits [8]
Deduced that cells [46] must contain digits [1]
Deduced that cells [28] must contain digits [5]
Deduced that cells [34, 33, 35] must contain digits [7, 1, 9]
Deduced that cells [51, 52, 44] must contain digits [2, 5, 6]
Deduced that cells [33, 35, 34] must contain digits [1, 9, 7]
Deduced that cells [52, 44, 51] must contain digits [6, 5, 2]
Deduced that cells [31, 32] must contain digits [8, 3]
Deduced that cells [52, 44, 51] must contain digits [6, 5, 2]
Deduced that cells [38, 45] must contain digits [9, 7]
Deduced that cells [32, 31] must contain digits [8, 3]
Deduced that cells [47] must contain digits [3]
Deduced that cells [58] must contain digits [8]
Deduced that cells [31] must contain digits [3]
Deduced that cells [19, 24, 22, 25] must contain digits [6, 4, 7, 9]
Deduced that cells [18] must contain digits [8]
Deduced that cells [26] must contain digits [3]
Deduced that cells [32] must contain digits [8]
Deduced that cells [8] must contain digits [6]
Deduced that cells [6, 16, 25] must contain digits [5, 7, 9]
Deduced that cells [6, 2] must contain digits [5, 9]
Deduced that cells [2, 6] must contain digits [5, 9]
Deduced that cells [25, 19] must contain digits [9, 7]
Deduced that cells [24] must contain digits [4]
Deduced that cells [22] must contain digits [6]
Deduced that cells [54] must contain digits [1]
Deduced that cells [60, 57, 56] must contain digits [2, 5, 7]
Deduced that cells [62] must contain digits [4]
Deduced that cells [4] must contain digits [1]
Deduced that cells [3] must contain digits [8]
Deduced that cells [50] must contain digits [2]
Deduced that cells [51, 52] must contain digits [6, 5]
Deduced that cells [44] must contain digits [2]
Deduced that cells [45, 49] must contain digits [9, 7]
Deduced that cells [41] must contain digits [1]
Deduced that cells [29] must contain digits [4]
Deduced that cells [39] must contain digits [9]
Deduced that cells [49] must contain digits [7]
Deduced that cells [40] must contain digits [5]
Deduced that cells [12] must contain digits [3]
Deduced that cells [75, 66, 57] must contain digits [7, 5, 1]
Deduced that cells [57, 66, 75] must contain digits [1, 7, 5]
Deduced that cells [38] must contain digits [7]
Deduced that cells [65, 56, 2, 74] must contain digits [8, 2, 9, 5]
Deduced that cells [11] must contain digits [6]
Deduced that cells [45] must contain digits [9]
Deduced that cells [67] must contain digits [2]
Deduced that cells [33, 35, 34] must contain digits [7, 1, 9]
Deduced that cells [14] must contain digits [4]
Deduced that cells [13] must contain digits [9]
Deduced that cells [68, 77] must contain digits [6, 3]
Deduced that cells [76] must contain digits [4]
Guessing that cell 2 is nine
  Deduced that cells [2] must contain digits [9]
  Deduced that cells [56, 74, 65] must contain digits [2, 5, 8]
  Deduced that cells [56, 65, 74] must contain digits [8, 2, 5]
  Deduced that cells [6] must contain digits [5]
  Deduced that cells [16] must contain digits [7]
  Deduced that cells [35, 34, 33] must contain digits [1, 7, 9]
  Deduced that cells [51] must contain digits [6]
  Deduced that cells [52] must contain digits [5]
  Deduced that cells [80, 71, 69, 78, 60] must contain digits [5, 1, 9, 7, 2]
  Deduced that cells [69, 71, 60, 78, 80] must contain digits [2, 5, 7, 9, 1]
  Deduced that cells [71, 60, 80, 69, 78] must contain digits [9, 2, 5, 1, 7]
  Deduced that cells [19] must contain digits [7]
  Deduced that cells [73, 64] must contain digits [3, 9]
  Deduced that cells [64, 73] must contain digits [9, 3]
  Deduced that cells [25] must contain digits [9]
  Deduced that cells [34] must contain digits [1]
  Deduced that cells [79, 70] must contain digits [6, 8]
  Deduced that cells [72] must contain digits [7]
  Deduced that cells [60, 71, 69, 78, 80] must contain digits [2, 9, 5, 1, 7]
  Deduced that cells [66, 57, 75] must contain digits [5, 7, 1]
  Deduced that cells [60, 78, 71, 80, 69] must contain digits [5, 2, 1, 7, 9]
  Deduced that cells [79, 70] must contain digits [6, 8]
  Guessing that cell 33 is nine
    Deduced that cells [33] must contain digits [9]
    Deduced that cells [35] must contain digits [7]
    Deduced that cells [69, 60, 78] must contain digits [7, 1, 2]
    Deduced that cells [78, 60, 69] must contain digits [2, 7, 1]
    Deduced that cells [68, 64, 70, 65, 71] must contain digits [9, 5, 8, 3, 6]
    Deduced that cells [66, 69] must contain digits [1, 7]
    Guessing that cell 56 is two
      Deduced that cells [56] must contain digits [2]
      Deduced that cells [74, 80, 77, 73, 79] must contain digits [5, 9, 6, 8, 3]
      Deduced that cells [60] must contain digits [7]
      Deduced that cells [69] must contain digits [1]
      Deduced that cells [66] must contain digits [7]
      Deduced that cells [75] must contain digits [1]
      Deduced that cells [78] must contain digits [2]
      Deduced that cells [57] must contain digits [5]
      Guessing that cell 64 is nine
        Deduced that cells [64] must contain digits [9]
        Deduced that cells [73] must contain digits [3]
        Deduced that cells [77] must contain digits [6]
        Deduced that cells [68] must contain digits [3]
        Deduced that cells [71] must contain digits [5]
        Deduced that cells [80] must contain digits [9]
        Deduced that cells [65] must contain digits [8]
┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓
┃ 3 │ 4 │ 9 ┃ 8 │ 1 │ 7 ┃ 5 │ 2 │ 6 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 5 │ 2 │ 6 ┃ 3 │ 9 │ 4 ┃ 8 │ 7 │ 1 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 8 │ 7 │ 1 ┃ 2 │ 6 │ 5 ┃ 4 │ 9 │ 3 ┃
┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
┃ 2 │ 5 │ 4 ┃ 6 │ 3 │ 8 ┃ 9 │ 1 │ 7 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 6 │ 8 │ 7 ┃ 9 │ 5 │ 1 ┃ 3 │ 4 │ 2 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 9 │ 1 │ 3 ┃ 4 │ 7 │ 2 ┃ 6 │ 5 │ 8 ┃
┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
┃ 1 │ 6 │ 2 ┃ 5 │ 8 │ 9 ┃ 7 │ 3 │ 4 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 4 │ 9 │ 8 ┃ 7 │ 2 │ 3 ┃ 1 │ 6 │ 5 ┃
┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
┃ 7 │ 3 │ 5 ┃ 1 │ 4 │ 6 ┃ 2 │ 8 │ 9 ┃
┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛
Finished in 0.334818878 seconds
```
