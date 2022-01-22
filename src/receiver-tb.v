module receiver_tb;
  reg in, clock;
  wire [11:0] size;
  wire [47:0] desMAC, srcMAC;
  wire [1499:0] out;
  wire done;
  integer i;

  initial clock = 0;
  always #5 clock = ~clock; // Given synchronized clock


  // The runtime of simulation for each case is 2320ns hence amounting the total simulation time to 4640ns. (Please consider this value while using Modelsim to obtain the full result.)
  initial
  begin
    for(i = 0; i < 31; i = i + 1) //+620ns
    begin
      in = 1; #10;
      in = 0; #10;
    end
    // +980ns
    in = 1; #20;
    in = 0; #480; // 48*10 for destination MAC address
    in = 1; #480; // 48*10 for source MAC address
    
    // EtherType value (Equals 3 since input is 3 bytes)
    // +160ns
    in = 0; #140;
    in = 1; #20;

    // Giving the solved test case to the input (Read report for more information)
    // +240ns
    in = 1; #10;
    in = 0; #50;
    in = 1; #10;
    in = 0; #20;
    in = 1; #10;
    in = 0; #40;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #40;
    in = 1; #10;
    in = 0; #10;

    // Giving the calculated value of FCS
    // +320ns
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #10;
    in = 0; #20;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #10;
    in = 0; #40;
    in = 1; #20;
    in = 0; #20;
    in = 1; #30;
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;

    // A period of rest between two frames (First frame is true and second one is false.)
    in = 0; #50;

    for(i = 0; i < 31; i = i + 1)
    begin
      in = 1; #10;
      in = 0; #10;
    end
    in = 1; #20;
    in = 0; #480; // 48*10 for destination MAC address
    in = 1; #480; // 48*10 for source MAC address
    
    // EtherType value
    in = 0; #140;
    in = 1; #20;

    // Giving the solved test case to the input
    in = 1; #10;
    in = 0; #50;
    in = 1; #10;
    in = 0; #20;
    in = 1; #10;
    in = 0; #40;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #40;
    in = 1; #10;
    in = 0; #10;

    // Giving the wrong value of FCS
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #10;
    in = 0; #20;
    in = 1; #10;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #20;
    in = 0; #10;
    in = 1; #10;
    in = 0; #40;
    in = 1; #20;
    in = 0; #20;
    in = 1; #30;
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;
  end

  receiver ethernetFrame(clock, in, out, size, desMAC, srcMAC, done);
endmodule