# Data Link Layer Implementation for Ethernet Protocol Using Verilog  

Ethernet protocol governs the rules for communication and transmission of data between compouters in a local area network. Datas are sent as a frame, which have specific configurations to allow for generic usage. For more read [here](https://en.wikipedia.org/wiki/Ethernet_frame).  
The Verilog code implements the reciever which works in sync with an external clock. The main module validates the frame transmitted comforms with the CRC32 specification and outputs `Done` in case of success in frame transmission.
