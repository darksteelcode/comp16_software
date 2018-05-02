/* stdio.asm - Comp16 Standard Input / Output Assembly File
 * Edward Wawrzynek
 * Used prefixes - GFX_, KEY_, SERIAL_, PRGM_ROM_
 * --------
 * This file defines io ports and some key codes
 * TODO: Get a better way to get key codes for released keys - (macro to add release code?)
 */

#include std.asm\

//Define IO Ports

//Graphics Memory Ports
#define GFX_TXT_ADDR 5\
#define GFX_TXT_DATA 6\

//PS2 Keyboard Ports
#define KEY_DATA 7\
#define KEY_NEXT 7\
#define KEY_IN_WAITING 8\

//Serial Ports
//Port that contains recived data
#define SERIAL_DATA_IN 1\
//A write to this port jumps to the next character in the fifo
#define SERIAL_NEXT 1\
//Port contains the number of bytes waiting to be read in the fifo
#define SERIAL_IN_WAITING 2\
//When written to, this port sends the low-byte of the data in it
#define SERIAL_DATA_OUT 3\
//This port contains a bit, that when high, indicates that the uart is still sending data. If low, the uart is not busy, and data can be sent
#define SERIAL_TX_BUSY 4\

//PRGM_ROM ports
#define PRGM_ROM_ADDRS 14\
#define PRGM_ROM_VAL 15\

//Timer ports
#define TIMEIO_MS 9\
#define TIMEIO_S 10\

//Key code definitions - ascii unless specified below
#define KEY_F1 11\
#define KEY_F2 12\
#define KEY_F3 13\
#define KEY_F4 14\
#define KEY_F5 15\
#define KEY_F6 19\
#define KEY_F7 20\
#define KEY_F8 21\
#define KEY_F9 22\
#define KEY_F10 23\
#define KEY_F11 24\
#define KEY_F12 25\

#define KEY_LEFT 28\
#define KEY_UP 29\
#define KEY_RIGHT 30\
#define KEY_DOWN 31\

#define KEY_LEFT_RELEASE 0x011c\
#define KEY_UP_RELEASE 0x011d\
#define KEY_RIGHT_RELEASE 0x011e\
#define KEY_DOWN_RELEASE 0x011f\
