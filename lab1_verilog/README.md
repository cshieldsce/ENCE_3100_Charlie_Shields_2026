# Lab 1 - Switches, Lights, and Multiplexers

DE10-Lite (MAX 10). All parts are in `main.v`, uncomment the one to build.

<img src="IMG_1169.jpeg" width="600">

## Parts

- **Part I** - SW to LEDR
- **Part II** - 8-bit 2-to-1 mux (`mux_2_1_8b.v`). s = SW[0], X = SW[7:0], Y = 170, M on LEDR[7:0]
- **Part III** - 3-bit 5-to-1 mux (`mux_3bit_5to1.v`, `mux_5_1.v`). S = SW[9:7], U = SW[2:0], V = SW[5:3], M on LEDR[2:0]
- **Part IV** - 7-segment decoder (`char_7seg.v`). SW[2:0] shows H, E, L, O, or blank on HEX0
- **Part V** - HELLO on HEX4-HEX0, SW[9:7] rotates
- **Part VI** - HELLO on all 6 displays, SW[9:7] rotates

## Notes

The lab is written for the DE2 (18 switches, 8 displays). The DE10-Lite only has 10 switches and 6 displays, so the HELLO character codes are hardcoded and Part VI uses 6 displays.
