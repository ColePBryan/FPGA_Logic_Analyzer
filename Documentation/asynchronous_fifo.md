# Asynchronous FIFO Module

> This module is strongly based on the asynchronous FIFO in the Demon Core Verilog port

#### Module Overview

The asynchronous FIFO module is used on any clock domain border to transfer data safely between the two clock domains. Clock domain crossing can cause metastability issues. Metastability is caused if a signal is altered without obeying set up and hold time of the receiving flop. Because the clock of the flip flop supplying the signal is not synchronized with the clock of the flip flop receiving the data there is a possibility of disobeying set up and hold times. The FIFO allows the data to be supplied and retrieved on two different clocks helping avoid clocking issues.

#### Interface Definitions

#### Module Functionality

This asynchronous FIFO is used to pass data between two clock domains without running into metastability issues. Much of this FIFO construct is the same as a standard FIFO. ETC ETC ETC go into detail here about the details of this fifo //TODO !!!!

#### Parameters, Inputs and Outputs Descriptions

##### Parameters

Parameter Name | Default Value | Description
--------------------- | ----------------------------- | -------------------------------------------------------------------------------------------
ASYNC_FIFO_MAXINDEX | 3 | Placeholder description
ASYNC_FIFO_MAXDATA | 31 | Placeholder description
ASYNC_FIFO_FULLTHRESHOLD | 4 | Placeholder description

##### Inputs

Signal Name | Width | Signal Description
--------------------- | ----------------------------- | -------------------------------------------------------------------------------------------
wrclk | 1 | Placeholder descrition
wrreset | 1 | Placeholder descrition
rdclk | 1 | Placeholder descrition
rdreset | 1 | Placeholder descrition
read_req | 1 | Placeholder descrition
wrenb | 1 | Placeholder descrition
wrdata | ASYNC_FIFO_MAXDATA:0 | Placeholder description

##### Outputs

Signal Name | Width | Signal Description
--------------------- | ----------------------------- | -------------------------------------------------------------------------------------------
space_avail | 1 | Placeholder description
data_avail | 1 | Placeholder description
data_valid | 1 | Placeholder description
data_out | ASYNC_FIFO_MAXDATA:0 | Placeholder description