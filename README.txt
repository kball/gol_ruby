Problem:

Implement Conway's Game of Life in arbitrary integer-space.

Imagine a 2D grid - each cell (coordinate) can be either "alive" or "dead".  Every generation of the simulation, the system ticks forward.  Each cell's value changes according to the following:

If an "alive" cell had less than 2 or more than 3 alive neighbors (in any of the 8 surrounding cells), it becomes dead.
If a "dead" cell had *exactly* 3 alive neighbors, it becomes alive.

Your input is a list of alive (x, y) integer coordinates.  They could be anywhere in the signed 64-bit range. This means the board could be very large!

Sample input:
(0, 1)
(1, 2)
(2, 0)
(2, 1)
(2, 2)
(-2000000000000, -2000000000000)
(-2000000000001, -2000000000001)


To run:

bundle install
bundle exec ruby server.rb

Then load 'localhost:4567' in a web browser

Input files expected to be text files with one tuple per line.  Default load uses the sample input.
