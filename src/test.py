import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

voltage = [12, 53, 1, 0 , 0, 12, 86, 12, 24, 156, 250, 0, 3, 235, 100]
@cocotb.test()
async def test_LSNN(dut):
    CONSTANT_CURRENT = 40
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="ms")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut.ui_in.value = CONSTANT_CURRENT 

    for i in voltage:
        dut.ui_in.value = i
        await RisingEdge(dut.clk)

    for _ in range(100):
        await RisingEdge(dut.clk)
    
    dut._log.info("Finished Test!")