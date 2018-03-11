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

//Graphics Memory Ports
#define GFX_TXT_ADDR 5\
#define GFX_TXT_DATA 6\
