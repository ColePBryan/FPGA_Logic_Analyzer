# Delay FIFO Module

> This module is strongly based on the delay FIFO in the Demon Core Verilog port

#### Module Overview

The delay FIFO module is used to delay the arrival of data by a value of 1 - 16 clock cycles. This functionality is obtained by using shift registers that are bit accessable. The delay is created by addressing a specific bit of the shift register that takes N amount of clock cycles to arrive from input, where N is the desired delay.

#### Interface Definitions

#### Module Functionality

This module is used to create a selectable delay between data aquisition and its output. This delay is created with shift registers that are bit addressable. Each shift register is the size of exactly one LUT on a xilinx spartan 7. The value of the address is equivalent to the number of clock tick delays.

#### Parameters, Inputs and Outputs Descriptions

##### Parameters

Parameter Name | Default Value | Description
----- | ------ | ------------------------
DELAY | 3 | Placeholder description
WIDTH | 32 | Placeholder description

##### Inputs

Signal Name | Width | Signal Description
----- | ------ | ------------------------
clock | 1 | Placeholder description
reset | 1 | Placeholder description
validIn | 1 | Placeholder description
dataIn | [WIDTH-1:0] | Placeholder description

##### Outputs

Signal Name | Width | Signal Description
----- | ------ | ------------------------
validOut | 1 | Placeholder description
dataOut | WIDTH-1:0 | Placeholder Description


