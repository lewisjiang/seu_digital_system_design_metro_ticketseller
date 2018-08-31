----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/09/10 11:58:13
-- Design Name: 
-- Module Name: st_transfer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity st_transfer is------------------------本次采用函数，纯查找
    Port ( 
    clk : in STD_LOGIC;
    ubt_phy:in std_logic;
    dbt_phy:in std_logic;
    lbt_phy:in std_logic;
    rbt_phy:in std_logic;
    cbt_phy:in std_logic;
    manual_reset:in std_logic;
    seg:out std_logic_vector(7 downto 0);
    no:out std_logic_vector(7 downto 0);
    led:buffer std_logic_vector(7 downto 0);
    rgb1:out std_logic_vector(2 downto 0);
    rgb2:out std_logic_vector(2 downto 0)
    --bp:buffer std_logic:='0'
    );
end st_transfer;

architecture Behavioral of st_transfer is
type state_type is (s0,s1,s2,s3,s4,s5,s6,s7);
type length4 is array (0 to 3) of integer;
type length3 is array (0 to 2) of integer range 0 to 127;
type length8 is array (0 to 7) of integer range 0 to 10;
type length16 is array (0 to 15) of integer range 0 to 255;
type w_array is array (0 to 4949) of integer range 0 to 3;
type order_of_code is array (0 to 99) of integer range 0 to 127;

constant n_station:length4:=(27,26,29,18);--到底是1234线还是4321线？？？18站是4号线
constant maxprice:integer:=6;
constant maxn_tkt:integer:=10;
constant oc:order_of_code:=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113);
constant w0:w_array :=(1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,1,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,2,2,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,2,2,2,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,3,3,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,3,3,3,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,3,3,3,3,3,3,3,3,3,3,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,1,1,1,1,2,2,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,2,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,2,2,2,1,1,1,1,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,2,2,2,2,1,1,1,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,1,1,3,3,3,3,3,3,3,3,3,3,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,1,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,2,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,2,2,2,2,1,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,3,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,3,3,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,3,3,3,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,3,1,1,1,1,2,2,2,2,2,2,2,2,3,1,1,1,1,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,1,1,1,1,2,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1);
signal ubt,dbt,rbt,lbt,cbt,q0u,q1u,q0d,q1d,q0r,q1r,q0l,q1l,q0c,q1c:std_logic;
signal state:state_type:=s0; 
signal clk1:std_logic:='0';
signal clk2:std_logic:='0';
signal clk3:std_logic:='0';
signal c_station:integer range 0 to 31:=15;
signal c_lin:integer range 0 to 3:=0;

signal done:std_logic:='0';
signal fin_feedback:std_logic:='0';
signal blinker:std_logic:='0';

signal total:integer range 0 to 127;
signal tp_sum:length4:=(0,0,0,0) ;
signal paid:integer range 0 to 127;
signal inneed:integer range 0 to 127;
signal surplus:integer range 0 to 127;
signal station:integer range 0 to 31;
signal lin:integer range 0 to 3;
signal price:integer:=2;
signal price2:integer:=2;
signal n_tkt:integer:=1;

function cosx(samp:integer) return integer is
variable x:integer;
variable flg:integer range -1 to 1;
begin
if samp>511 then x:=(samp-512)/2;
else x:=samp/2;-------------原来没有除以2，原来511为255
end if;
if x>127 then x:=255-x;
end if;
if 0<=x and x<=63 then flg:=1;
    elsif 63<x and x<=127 then flg:=-1;
    else flg:=0;
end if;--(72-72/63*x)------------(-x*x*9/512+72)
return 72+flg*(-x*x*9/512+72);--(x*x*x*x*73/32/128/128/128-355*x*x/16384+72);--=flag*(((pi/128)^4*x^4)*3 - ((pi/128)^2*x^2)*36 + 72);
end function cosx;

function mins (station,lin,c_station,c_lin: integer) return integer is
    variable c_code:integer;
    variable t_code:integer;
    variable c,t:integer;
begin
c_code:=c_lin*32+c_station;
t_code:=lin*32+station;
for i in 0 to 99 loop-------------------------本条线上的换乘点与本站的距离
    if oc(i)=c_code then
        c:=i;
        exit;
    end if;
end loop;
for i in 0 to 99 loop
    if oc(i)=t_code  then
        t:=i;
        exit;
    end if;
end loop;
if c>=t then
    return w0(100*t+c-(t+2)*(t+1)/2)+1;
else return w0(100*c+t-(c+2)*(c+1)/2)+1;
end if;
end function mins;

begin
---------------------------------------------------------------时钟1:肉眼可见慢速时钟,2hz
clock1:process(clk2)
variable clkcnt:integer range 0 to 199;
begin
if clk2'event and clk2='1' then
    if clkcnt<199 then clkcnt:=clkcnt+1;
    elsif clkcnt=199 then clkcnt:=0;clk1<=not clk1;
    end if;
end if;
end process clock1;
---------------------------------------------------------------时钟2:数码管扫描时钟,800hz，每个灯100hz
clock2:process(clk)
variable clkcnt:integer range 0 to 62_499;
begin
if clk'event and clk='1' then
    if clkcnt<62_499 then clkcnt:=clkcnt+1;
    elsif clkcnt=62_499 then clkcnt:=0;clk2<=not clk2;
    end if;
end if;
end process clock2;
---------------------------------------------------------------时钟3:triled,600k小周期,13.9kHz
clock3:process(clk)
variable clkcnt:integer range 0 to 3599;
begin
if clk'event and clk='1' then
    if clkcnt<3599 then clkcnt:=clkcnt+1;
    elsif clkcnt=3599 then clkcnt:=0;clk3<=not clk3;
    end if;
end if;
end process clock3;

---------------------------------------------------------------------按键响应
ubt<=q0u AND (NOT(q1u));
dbt<=q0d AND (NOT(q1d));
lbt<=q0l AND (NOT(q1l));
rbt<=q0r AND (NOT(q1r));
cbt<=q0c AND (NOT(q1c));
btn_response:process(clk)
--process在时钟下降沿也会执行，所以其中每个语句必须判断上升沿，才不会出现意想不到的结果
variable bt_delay:integer range 0 to 19_999_999;
variable delay_flag:std_logic :='0';
constant max_cnt:integer:=19_999_999;
begin
if (clk'event and clk='1') then
    if delay_flag='0' then
    q0u<=ubt_phy; q1u<=q0u;
    q0d<=dbt_phy; q1d<=q0d;
    q0l<=lbt_phy; q1l<=q0l;
    q0r<=rbt_phy; q1r<=q0r;
    q0c<=cbt_phy; q1c<=q0c;
    end if;
    if (ubt='1' or dbt='1' or rbt='1' or lbt='1' or cbt='1')then delay_flag:='1';----此行及以下为消抖延时
    end if;
    if delay_flag='1'then
        if bt_delay<max_cnt then bt_delay:=bt_delay+1;
        elsif bt_delay=max_cnt then bt_delay:=0;delay_flag:='0';
        end if;
    end if;
end if;
end process btn_response;
-----------------------------------------------------------------------------三色灯
triled:process(clk3,state)
variable rot:integer range 0 to 2:=0;
variable pwm:length3:=(0,0,0); 
--variable pwmmax:integer:=72;
variable sampling:integer range 0 to 511;
variable unitpwm:integer range 0 to 215:=0;
begin
if clk3='1' and clk3'event then
    if state=s1 then
        if unitpwm<215 then unitpwm:=unitpwm+1;
            elsif unitpwm=215 then 
                unitpwm:=0;
                for i in 0 to 2 loop
                    pwm(i):=cosx(sampling+85*i)/4;
                end loop;
                if sampling<511 then sampling:=sampling+1;-------------原来是255
                else sampling:=0;
                end if;
        end if;
        if rot<2 then rot:=rot+1;
        else rot:=0;
        end if;
        for i in 0 to 2 loop
            if i=rot and unitpwm<pwm(i) then
                rgb1(i)<='1';
                rgb2(i)<='1';
            else rgb1(i)<='0';rgb2(i)<='0';
            end if;
        end loop;
    else 
        for i in 0 to 2 loop
            rgb1(i)<='0';
            rgb2(i)<='0';
        end loop;
    end if;
end if;
end process triled;

-------------------------------------------------------------------------------状态转移
st_trans:process(clk)
variable vpaid:integer range 0 to 127:=0;-----------为了描述容易多次变化的已付款，引入一个变量
variable change_cnt:integer range 0 to 99_999_999:=0;
begin
if (clk'event and clk='1') then--对于同步过的按键信号，是不是下降沿触发更好一点
if manual_reset='1' and (state = s1 or state=s2 or state=s3 or state=s4)then state<=s0;
    else
    case state is
    when s0 =>  led<="00000001";--是if顺序执行好还是if嵌套好？为了逻辑稳健性顺序用变量，嵌套用信号?
                if cbt='1' then state<=s1;
                else
                    if ubt='1' and c_station<(n_station(c_lin)-1) then c_station<=c_station+1;--站加
                    elsif dbt='1' and c_station>0 then c_station<=c_station-1;--站减
                    end if;
                    if lbt='1' and c_lin<(n_station'length-1) then c_lin<=c_lin+1;--线路循环
                    elsif lbt='1' and c_lin=(n_station'length-1) then c_lin<=0;
                    end if;
                end if;
    when s1 =>  led<="00000010";--待机
                vpaid:=0;
               -- done<='0';--1
                price<=2;
                lin<=0;
                station<=15;
                surplus<=0;--5
                inneed<=0;
                paid<=0;
                total<=0;
                n_tkt<=1;--9
                for i in 0 to 3 loop
                   tp_sum(i)<=0;
                end loop;
                if ubt='1' or dbt='1'or lbt='1'or rbt='1' or cbt='1' then state<=s2;
                end if;
    when s2 =>  led<="00000100";--选单价
                if rbt='1' then state<=s3;
                    else if ubt='1' and price<maxprice then price<=price+1;
                         elsif dbt='1'and price>2 then price<=price-1;
                         elsif cbt='1' then state<=s4;
                    end if;
                end if;
    when s3 =>  led<="00001000";--选站
                if rbt='1' then state<=s1;
                elsif cbt='1' then 
                -------------------------------------------------price<=计算价格
                    price<=mins(station,lin,c_station,c_lin);
                    state<=s4;
                -------------------------------------------------price<=计算价格    
                else
                     if ubt='1' and station<(n_station(lin)-1) then station<=station+1;--站加
                     elsif dbt='1' and station>0 then station<=station-1;--站减
                     end if;
                     if lbt='1' and lin<(n_station'length-1) then lin<=lin+1;--线路循环
                     elsif lbt='1' and lin=(n_station'length-1) then lin<=0;
                     end if;
                 end if;
    when s4 =>  led<="00010000";--选票数
                if rbt='1' then
                    state<=s1;
                elsif cbt='1' then 
                    total<=price*n_tkt;
                    inneed<=price*n_tkt;
                    state<=s5;
                elsif ubt='1' and n_tkt<maxn_tkt then n_tkt<=n_tkt+1;--票数加
                elsif dbt='1' and n_tkt>1 then n_tkt<=n_tkt-1;--票数减
                end if;
    when s5 =>  led<="00100000";--投币
                if ubt='1' then vpaid:=vpaid+5;
                    tp_sum(1)<=tp_sum(1)+1;--记录币种
                end if;
                if dbt='1' then vpaid:=vpaid+20;
                    tp_sum(3)<=tp_sum(3)+1;
                end if;
                if lbt='1' then vpaid:=vpaid+10;
                    tp_sum(2)<=tp_sum(2)+1;
                end if;
                if cbt='1' then vpaid:=vpaid+1;
                    tp_sum(0)<=tp_sum(0)+1;
                end if;
                paid<=vpaid;
                if rbt='1' then state<=s7;
                else if total-vpaid>0 then inneed<=total-vpaid;
                     else inneed<=0;
                         surplus<=vpaid-total;
                         state<=s6;
                         --------------------------------------提示达到金额
                     end if;
                end if;
    when s6 =>  led<="01000000";--找零
    --------------------慢慢减下去,完成信号在另一个process里面
                if surplus=0 and n_tkt=0 then                     
                if fin_feedback='0' then done<='1';
                    for i in 0 to 7 loop------------------------
                        led(i)<=blinker;
                    end loop;
                    elsif fin_feedback='1' then 
                        state<=s1;
                        done<='0';------------------------------
                end if;
                elsif surplus>=0 and n_tkt>0 then 
                    if change_cnt<99_999_999 then change_cnt:=change_cnt+1;
                    elsif change_cnt=99_999_999 then
                        change_cnt:=0;
                        if surplus-10>=0 then surplus<=surplus-10;
                        elsif surplus-5>=0 then surplus<=surplus-5;
                        elsif surplus-1>=0 then surplus<=surplus-1;
                        end if;
                        if surplus=0 then ----------------------------------新增出票显示
                            if n_tkt>0 then n_tkt<=n_tkt-1;
                            end if;
                        end if;
                    end if;
                end if;
    when s7 =>  --退款
                if paid>0 then
                    led<="10000000";
                    if change_cnt<99_999_999 then change_cnt:=change_cnt+1;
                    elsif change_cnt=99_999_999 then
                        change_cnt:=0;
                        if tp_sum(3)>0 then tp_sum(3)<=tp_sum(3)-1;
                        paid<=paid-20;
                        elsif tp_sum(2)>0 then tp_sum(2)<=tp_sum(2)-1;
                        paid<=paid-10;
                        elsif tp_sum(1)>0 then tp_sum(1)<=tp_sum(1)-1;
                        paid<=paid-5;
                        elsif tp_sum(0)>0 then tp_sum(0)<=tp_sum(0)-1;
                        paid<=paid-1;
                        end if;
                    end if;
                elsif paid=0 then
                    if fin_feedback='0' then done<='1';-----------
                    for i in 0 to 7 loop
                        led(i)<=blinker;
                    end loop;
                    elsif fin_feedback='1' then 
                        state<=s1;
                        done<='0';
                    end if;----------------------------------------
                end if;
    end case;
end if;
end if;
end process st_trans;
--------------------------------------------------------------完成信号
finish:process(clk1)
variable fincnt:integer range 0 to 5:=0;
begin
if clk1='1' and clk1'event then
    if fincnt<5 and done='1' and ( state=s6 or state=s7 )then 
        fincnt:=fincnt+1;
        blinker<=not blinker;
    elsif fincnt=5 and done='1'and ( state=s6 or state=s7 ) then 
        fin_feedback<='1';
    elsif not(state=s6 or state=s7) then 
        fin_feedback<='0';fincnt:=0;
    end if;
end if;
end process finish;

-------------------------------------------------------------------------------数码管显示数字
digi_display_num:process(state,clk2)
variable todisp:integer range 0 to 10:=0;--一个数码
variable num:integer range 0 to 999999;--要显示的数
--variable num_old:integer range 0 to 99999999:=0;
variable rot:integer range 0 to 7:=0;--轮转亮数码管
variable digis:length8:=(0,0,0,0,0,0,0,0);
variable md:integer range 1 to 10_000_000;
begin
if clk2'event and clk2='1' then
case state is
    when s0 =>  num:=(c_lin+1)*100+c_station+1;
    when s2 =>  num:=price;
    when s3 =>  num:=(lin+1)*100+station+1;
    when s4 =>  num:=price*100+n_tkt;
    when s5 =>  num:=total*100+inneed;
    when s6 =>  if surplus>0 then num:=paid*10000+total*100+surplus;
                elsif surplus=0 then num:=n_tkt*100+surplus;
                end if;
    when s7 =>  num:=paid;
    when others=> num:=0;
end case;
----------------------------计算各位数字
for i in 0 to 7 loop
digis(i):=0;
end loop;
    for i in 5 downto 0 loop-------------------------------不使用除法的各位数字取法
        case i is --可用数组
        when 5 => md:=100_000;
        when 4 => md:=10_000;
        when 3 => md:=1_000;
        when 2 => md:=100;
        when 1 => md:=10;
        when 0 => md:=1;
        end case;
        loop2:
        for j in 1 to 9 loop
            if num-md<0 then 
                exit loop2;
            else num:=num-md;
                 digis(i):=digis(i)+1;
            end if;
        end loop;
    end loop;
    

if state=s1 then rot:=1;
else
    if rot=7 then rot:=0;
    else rot:=rot+1;
    end if;
end if;

case rot is 
    when 0 => todisp:=digis(0);
    when 1 => if digis(1)=0 then todisp:=10;
                   else todisp:=digis(1);
              end if;
    when 2 => if state=s2 then todisp:=10;
              else todisp:=digis(2);
              end if;
    when 3 => if digis(3)=0 then todisp:=10;
                   else todisp:=digis(3);
              end if;
    when 4 => if not(state=s0 or state=s2 or state=s3 or state=s4 or state=s5) then todisp:=digis(4);
              else todisp:=10;
              end if;
    when 5 => if digis(5)=0 then todisp:=10;
                   else todisp:=digis(5);
              end if;
    when others=> todisp:=10;
--    when 6 =>
--    when 7 =>
end case;

case rot is
when 0 => no<= "11111110";
when 1 => no<= "11111101";
when 2 => no<= "11111011";
when 3 => no<= "11110111";
when 4 => no<= "11101111";
when 5 => no<= "11011111";
when 6 => no<= "10111111";
when 7 => no<= "01111111";
when others => no<= "11111111";
end case;

case todisp is
    when 0=>seg<="11000000";
    when 1=>seg<="11111001";
    when 2=>seg<="10100100";
    when 3=>seg<="10110000";
    when 4=>seg<="10011001";
    when 5=>seg<="10010010";
    when 6=>seg<="10000010";
    when 7=>seg<="11111000";
    when 8=>seg<="10000000";
    when 9=>seg<="10010000";
    when others=>seg<="11111111";
end case;
end if;
end process digi_display_num;

end Behavioral;