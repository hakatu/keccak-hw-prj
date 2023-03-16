--Algorithm Name: Keccak
--Authors: Guido Bertoni, Joan Daemen, Michaël Peeters and Gilles Van Assche
--Date: August 29, 2009

--This code, originally by Guido Bertoni, Joan Daemen, MichaÃ«l Peeters and
--Gilles Van Assche as a part of the SHA-3 submission, is hereby put in the
--public domain. It is given as is, without any guarantee.

--For more information, feedback or questions, please refer to our website:
--http://keccak.noekeon.org/

library work;
	use work.keccak_globals.all;
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


--datapath entity
entity crypto_fpga is
   port(
      init:in std_logic;
      EoM:in std_logic;
      load:in std_logic;
      fetch:in std_logic;
      ack:out std_logic;
      idata:in std_logic_vector(15 downto 0);
      odata:out std_logic_vector(15 downto 0);
      rst_n : in std_logic;
      clk : in std_logic
   );
end crypto_fpga;


architecture rtl of crypto_fpga is

component keccak   
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    start : in std_logic;
    din     : in  std_logic_vector(15 downto 0);
    din_valid: in std_logic;
    buffer_full: out std_logic;
    last_block: in std_logic;    
    ready : out std_logic;
    dout    : out std_logic_vector(15 downto 0);
    dout_valid : out std_logic);

end component;

  ----------------------------------------------------------------------------
  -- Internal signal declarations
  ----------------------------------------------------------------------------

 
--signal zero_state : k_state;
  signal sig_din_valid	:	std_logic;
  signal sig_buf_full	:	std_logic;
  signal sig_last_block :	std_logic;
  signal sig_ready	:	std_logic;
  signal sig_dout_valid	:	std_logic;
  signal reg_odata : std_logic_vector(15 downto 0);
  signal sig_odata : std_logic_vector(15 downto 0);
  type st_type is (st_INIT,st_load,st_last,st_wait2,st_wait1,st_fetch);
  signal st : st_type;


  
begin  -- Rtl

-- port map

keccak_map : keccak port map(
		    	clk     => clk,
			rst_n   => rst_n,
			start 	=> init,
			din     => idata ,
			din_valid => sig_din_valid,
			buffer_full => sig_buf_full,
			last_block => sig_last_block,  
			ready => sig_ready,
			dout  => sig_odata,
			dout_valid => sig_dout_valid
		);


 
 -- state register and counter of the number of rounds
 -- type st_type is (st_INIT,st_load,st_last,st_fetch,st_idle);
 
  p_main : process (clk,rst_n)
    
  begin  
		if rst_n = '0' then                 -- asynchronous rst_n (active low)
                st <= st_INIT;
                sig_din_valid<='0';
                sig_last_block<='0';

   		elsif clk'event and clk = '1' then  -- rising clk edge
			reg_odata <= sig_odata;
		case st is
			when st_INIT =>
                if(load='1') then	
						if(sig_buf_full='0') then
								ack <='0';
		               			sig_din_valid<='1';
							--	st <= st_load;
								st <= st_wait1;
						else	
								ack <='0';
		               			sig_din_valid<='0';
								st <= st_INIT;
						end if;
				else
						ack <= '0';
						st <= st_INIT;
				end if;
               			sig_last_block<='0';
			
			when st_wait1 =>
					ack<='1';
					sig_din_valid<='0';
					st <= st_wait2;
					sig_last_block<='0';
				
			when st_wait2 =>
					ack<='0';
					sig_din_valid<='0';
					st <= st_load;
					sig_last_block<='0';
					
			when st_load =>
				if(load='0') then
					ack <= '0';
		            sig_din_valid<='0';
		            sig_last_block<='0';
					if(fetch='1') then
						st <= st_last;
					else
						st <= st_load;
					end if;
				elsif(load = '1') then
					if(sig_buf_full='0') then
						ack <= '0';
						st <= st_wait1;
						sig_din_valid<='1';
						sig_last_block<='0';
					else
						ack <= '0';
						st <= st_load;
		               	sig_din_valid<='0';
		               	sig_last_block<='0';
					end if;
				end if;	

			when st_last =>
				if(sig_ready='1') then
					st <= st_fetch;
					sig_last_block <='1';
				else
					st <= st_last;
					sig_last_block <='0';
				end if;					
				sig_din_valid <='0';
				ack<='0';

			when st_fetch=>
				sig_last_block <='1';
				ack <=sig_dout_valid;
				if(sig_ready='0') then
					st <= st_INIT;
				else	
					st <= st_fetch;
				end if;
			end case;		
    		end if;
  end process p_main;
odata <= reg_odata;

end rtl;
