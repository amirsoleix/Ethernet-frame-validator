module receiver(clock, in, out, size, desMAC, srcMAC, done);
  input in, clock;
  output reg [11:0] size; // Outputs the size of Payload in bytes
  output reg [47:0] desMAC, srcMAC;
  output reg [1499:0] out;
  output reg done;
  reg [13:0] value; // Determines the place in string when reading input.
  reg [7:0] sfdVal = 8'b11010101; // Conventional value for SFD
  reg [14:0] ET;
  reg [1499+32:0] Payload;
  reg [32:0] CRC32 = 33'b100000100110000010001110110110111;
  integer i, j;

  initial
  begin
    value = 0;
    out = 0;
    size = 0;
    done = 0;
  end

  always@(posedge clock)
  begin
    if(value == 0)
    begin
      desMAC = 0;
      srcMAC = 0;
      ET = 0;
      Payload = 0;
      size = 0;
      out = 0;
      done = 0;
    end
    if(value >= 0 && value <= 55)
    begin
      if(in == (value + 1) % 2)
        value = value + 1;
      else
        value = 0;
    end
    else if( value > 55 && value <= 63)
    begin
      if(in == sfdVal[value - 56])
        value = value + 1;
      else
        value = 0;
    end // After this section, the Ethernet frame is detected and hence we don't check format of the string anymore.
    else if(value > 63 && value <= 111)
    begin
      desMAC = (desMAC << 1) + in;
      value = value + 1;
    end
    else if(value > 111 && value <= 159)
    begin
      srcMAC = (srcMAC << 1) + in;
      value = value + 1;
    end
    else if(value > 159 && value <= 175)
    begin
      ET = (ET << 1) + in;
      if(value == 175)
        ET = ET << 3; // Calculates the number of bits for Payload and stores the value in ET (EtherType).
      value = value + 1;
    end
    else if(value > 175 && value <= 175 + ET + 32) // Since we want to reverse the CRC calculation we store the values of Payload and FCS respectively in a single string.
    begin
      Payload = (Payload << 1) + in;
      if(value == 175 + ET)
        out = Payload;
      if(value == 175 + ET + 32) // Condition for end of Ethernet packet
      begin
        // Checking validity of information transmission by performing polynomial divison.
        for(i = ET + 31; i > 32; i = i - 1)
          if(Payload[i] == 1)
          begin
            for(j = 0; j < 33; j = j + 1)
              Payload[i - j] = Payload[i - j] ^ CRC32[32 - j];
          end
        if(Payload == 0)
        begin
          done = 1;
          size = ET >> 3; // Size of Payload in bytes
          value = 0;
        end
        else
        begin
          done = 0; // Data is corrupted during transmission.
          value = 0;
        end
      end
      value = value + 1;
    end
  end
endmodule