/* stdtime.asm - Comp16 Standard Time Assembley File
 * Edward Wawrzynek
 * Used prefixes - time_, hang!,  wait! (will change)
 * --------
 * This will be changed soon, but currently has two simple macros
 * TODO: A hardware timer needs to be implemented in comp16
 * 	 These macros need to be moved to functions mostly grounded in real units, and time keeping func's need to be added
 * 	 A few programs will have to be converted to use unit based delays
 * 	 this file will just contain time definitions
 */

#include std.asm\


//Timer ports
#define TIMEIO_MS 9\
#define TIMEIO_S 10\
