---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for Control and status registers
---------------------------------------------------------------------------------------
-- File           : csr.vhd
-- Author         : auto-generated by wbgen2 from csr.wb
-- Created        : Tue Sep  4 16:47:37 2012
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE csr.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity csr is
  port (
    rst_n_i                                  : in     std_logic;
    wb_clk_i                                 : in     std_logic;
    wb_addr_i                                : in     std_logic_vector(2 downto 0);
    wb_data_i                                : in     std_logic_vector(31 downto 0);
    wb_data_o                                : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
-- Port for std_logic_vector field: 'PCB revision' in reg: 'Carrier informations'
    csr_carrier_pcb_rev_i                    : in     std_logic_vector(4 downto 0);
-- Port for std_logic_vector field: 'Reserved register' in reg: 'Carrier informations'
    csr_carrier_reserved_i                   : in     std_logic_vector(10 downto 0);
-- Port for std_logic_vector field: 'Carrier type' in reg: 'Carrier informations'
    csr_carrier_type_i                       : in     std_logic_vector(15 downto 0);
-- Port for std_logic_vector field: 'Bitstream type' in reg: 'Bitstream type'
    csr_bitstream_type_i                     : in     std_logic_vector(31 downto 0);
-- Port for std_logic_vector field: 'Bitstream date' in reg: 'Bitstream date'
    csr_bitstream_date_i                     : in     std_logic_vector(31 downto 0);
-- Port for BIT field: 'FMC slot 1 presence' in reg: 'Status'
    csr_stat_fmc1_pres_i                     : in     std_logic;
-- Port for BIT field: 'FMC slot 2 presence' in reg: 'Status'
    csr_stat_fmc2_pres_i                     : in     std_logic;
-- Port for BIT field: 'System clock PLL status' in reg: 'Status'
    csr_stat_sys_pll_lck_i                   : in     std_logic;
-- Port for BIT field: 'DDR3 bank4 calibration status' in reg: 'Status'
    csr_stat_ddr3_bank4_cal_done_i           : in     std_logic;
-- Port for BIT field: 'DDR3 bank5 calibration status' in reg: 'Status'
    csr_stat_ddr3_bank5_cal_done_i           : in     std_logic;
-- Port for std_logic_vector field: 'GPIO inputs' in reg: 'Status'
    csr_stat_gpio_in_i                       : in     std_logic_vector(3 downto 0);
-- Port for std_logic_vector field: 'Reserved' in reg: 'Status'
    csr_stat_reserved_i                      : in     std_logic_vector(22 downto 0);
-- Port for std_logic_vector field: 'Front panel LEDs' in reg: 'Control'
    csr_ctrl_fp_leds_o                       : out    std_logic_vector(7 downto 0);
-- Port for std_logic_vector field: 'Debug LEDs' in reg: 'Control'
    csr_ctrl_dbg_leds_o                      : out    std_logic_vector(3 downto 0);
-- Port for std_logic_vector field: 'GPIO termination' in reg: 'Control'
    csr_ctrl_gpio_term_o                     : out    std_logic_vector(3 downto 0);
-- Port for BIT field: 'GPIO 1 direction' in reg: 'Control'
    csr_ctrl_gpio_1_dir_o                    : out    std_logic;
-- Port for BIT field: 'GPIO 2 direction' in reg: 'Control'
    csr_ctrl_gpio_2_dir_o                    : out    std_logic;
-- Port for BIT field: 'GPIO 3 and 4 direction' in reg: 'Control'
    csr_ctrl_gpio_34_dir_o                   : out    std_logic;
-- Port for std_logic_vector field: 'GPIO outputs' in reg: 'Control'
    csr_ctrl_gpio_out_o                      : out    std_logic_vector(3 downto 0);
-- Port for std_logic_vector field: 'Reserved' in reg: 'Control'
    csr_ctrl_reserved_o                      : out    std_logic_vector(8 downto 0)
  );
end csr;

architecture syn of csr is

signal csr_ctrl_fp_leds_int                     : std_logic_vector(7 downto 0);
signal csr_ctrl_dbg_leds_int                    : std_logic_vector(3 downto 0);
signal csr_ctrl_gpio_term_int                   : std_logic_vector(3 downto 0);
signal csr_ctrl_gpio_1_dir_int                  : std_logic      ;
signal csr_ctrl_gpio_2_dir_int                  : std_logic      ;
signal csr_ctrl_gpio_34_dir_int                 : std_logic      ;
signal csr_ctrl_gpio_out_int                    : std_logic_vector(3 downto 0);
signal csr_ctrl_reserved_int                    : std_logic_vector(8 downto 0);
signal ack_sreg                                 : std_logic_vector(9 downto 0);
signal rddata_reg                               : std_logic_vector(31 downto 0);
signal wrdata_reg                               : std_logic_vector(31 downto 0);
signal bwsel_reg                                : std_logic_vector(3 downto 0);
signal rwaddr_reg                               : std_logic_vector(2 downto 0);
signal ack_in_progress                          : std_logic      ;
signal wr_int                                   : std_logic      ;
signal rd_int                                   : std_logic      ;
signal bus_clock_int                            : std_logic      ;
signal allones                                  : std_logic_vector(31 downto 0);
signal allzeros                                 : std_logic_vector(31 downto 0);

begin
-- Some internal signals assignments. For (foreseen) compatibility with other bus standards.
  wrdata_reg <= wb_data_i;
  bwsel_reg <= wb_sel_i;
  bus_clock_int <= wb_clk_i;
  rd_int <= wb_cyc_i and (wb_stb_i and (not wb_we_i));
  wr_int <= wb_cyc_i and (wb_stb_i and wb_we_i);
  allones <= (others => '1');
  allzeros <= (others => '0');
-- 
-- Main register bank access process.
  process (bus_clock_int, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      ack_sreg <= "0000000000";
      ack_in_progress <= '0';
      rddata_reg <= "00000000000000000000000000000000";
      csr_ctrl_fp_leds_int <= "00000000";
      csr_ctrl_dbg_leds_int <= "0000";
      csr_ctrl_gpio_term_int <= "0000";
      csr_ctrl_gpio_1_dir_int <= '0';
      csr_ctrl_gpio_2_dir_int <= '0';
      csr_ctrl_gpio_34_dir_int <= '0';
      csr_ctrl_gpio_out_int <= "0000";
      csr_ctrl_reserved_int <= "000000000";
    elsif rising_edge(bus_clock_int) then
-- advance the ACK generator shift register
      ack_sreg(8 downto 0) <= ack_sreg(9 downto 1);
      ack_sreg(9) <= '0';
      if (ack_in_progress = '1') then
        if (ack_sreg(0) = '1') then
          ack_in_progress <= '0';
        else
        end if;
      else
        if ((wb_cyc_i = '1') and (wb_stb_i = '1')) then
          case rwaddr_reg(2 downto 0) is
          when "000" => 
            if (wb_we_i = '1') then
            else
              rddata_reg(4 downto 0) <= csr_carrier_pcb_rev_i;
              rddata_reg(15 downto 5) <= csr_carrier_reserved_i;
              rddata_reg(31 downto 16) <= csr_carrier_type_i;
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "001" => 
            if (wb_we_i = '1') then
            else
              rddata_reg(31 downto 0) <= csr_bitstream_type_i;
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "010" => 
            if (wb_we_i = '1') then
            else
              rddata_reg(31 downto 0) <= csr_bitstream_date_i;
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "011" => 
            if (wb_we_i = '1') then
              rddata_reg(0) <= 'X';
              rddata_reg(1) <= 'X';
              rddata_reg(2) <= 'X';
              rddata_reg(3) <= 'X';
              rddata_reg(4) <= 'X';
            else
              rddata_reg(0) <= csr_stat_fmc1_pres_i;
              rddata_reg(1) <= csr_stat_fmc2_pres_i;
              rddata_reg(2) <= csr_stat_sys_pll_lck_i;
              rddata_reg(3) <= csr_stat_ddr3_bank4_cal_done_i;
              rddata_reg(4) <= csr_stat_ddr3_bank5_cal_done_i;
              rddata_reg(8 downto 5) <= csr_stat_gpio_in_i;
              rddata_reg(31 downto 9) <= csr_stat_reserved_i;
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "100" => 
            if (wb_we_i = '1') then
              csr_ctrl_fp_leds_int <= wrdata_reg(7 downto 0);
              csr_ctrl_dbg_leds_int <= wrdata_reg(11 downto 8);
              csr_ctrl_gpio_term_int <= wrdata_reg(15 downto 12);
              rddata_reg(16) <= 'X';
              csr_ctrl_gpio_1_dir_int <= wrdata_reg(16);
              rddata_reg(17) <= 'X';
              csr_ctrl_gpio_2_dir_int <= wrdata_reg(17);
              rddata_reg(18) <= 'X';
              csr_ctrl_gpio_34_dir_int <= wrdata_reg(18);
              csr_ctrl_gpio_out_int <= wrdata_reg(22 downto 19);
              csr_ctrl_reserved_int <= wrdata_reg(31 downto 23);
            else
              rddata_reg(7 downto 0) <= csr_ctrl_fp_leds_int;
              rddata_reg(11 downto 8) <= csr_ctrl_dbg_leds_int;
              rddata_reg(15 downto 12) <= csr_ctrl_gpio_term_int;
              rddata_reg(16) <= csr_ctrl_gpio_1_dir_int;
              rddata_reg(17) <= csr_ctrl_gpio_2_dir_int;
              rddata_reg(18) <= csr_ctrl_gpio_34_dir_int;
              rddata_reg(22 downto 19) <= csr_ctrl_gpio_out_int;
              rddata_reg(31 downto 23) <= csr_ctrl_reserved_int;
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when others =>
-- prevent the slave from hanging the bus on invalid address
            ack_in_progress <= '1';
            ack_sreg(0) <= '1';
          end case;
        end if;
      end if;
    end if;
  end process;
  
  
-- Drive the data output bus
  wb_data_o <= rddata_reg;
-- PCB revision
-- Reserved register
-- Carrier type
-- Bitstream type
-- Bitstream date
-- FMC slot 1 presence
-- FMC slot 2 presence
-- System clock PLL status
-- DDR3 bank4 calibration status
-- DDR3 bank5 calibration status
-- GPIO inputs
-- Reserved
-- Front panel LEDs
  csr_ctrl_fp_leds_o <= csr_ctrl_fp_leds_int;
-- Debug LEDs
  csr_ctrl_dbg_leds_o <= csr_ctrl_dbg_leds_int;
-- GPIO termination
  csr_ctrl_gpio_term_o <= csr_ctrl_gpio_term_int;
-- GPIO 1 direction
  csr_ctrl_gpio_1_dir_o <= csr_ctrl_gpio_1_dir_int;
-- GPIO 2 direction
  csr_ctrl_gpio_2_dir_o <= csr_ctrl_gpio_2_dir_int;
-- GPIO 3 and 4 direction
  csr_ctrl_gpio_34_dir_o <= csr_ctrl_gpio_34_dir_int;
-- GPIO outputs
  csr_ctrl_gpio_out_o <= csr_ctrl_gpio_out_int;
-- Reserved
  csr_ctrl_reserved_o <= csr_ctrl_reserved_int;
  rwaddr_reg <= wb_addr_i;
-- ACK signal generation. Just pass the LSB of ACK counter.
  wb_ack_o <= ack_sreg(0);
end syn;