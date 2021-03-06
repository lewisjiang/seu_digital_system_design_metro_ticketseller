# seu_digital_system_design_metro_ticketseller 
<p>Course design, "metro ticketseller" on Xilinx Artix-7 in VHDL</p>
<p>School of Information Science and engineering, Southeast University.</p>
## Problem Description
<p>地铁售票模拟系统</p>
<p>功能描述：用于模仿地铁售票的自动售票，完成地铁售票的核心控制功能。</p>

1. 地铁售票机有两个进币孔，可以输入硬币和纸币，售货机有两个进币孔，一个是输入硬币，一个是输入纸币，硬币的识别范围是1 元的硬币，纸币的识别范围是5 元，10 元，20元。乘客可以连续多次投入钱币。
2. 以南京市轨道交通1/2/3/4号线为基准进行设计考虑。站点数较多，需自行编码。
3. 系统可以通过按键设定当前站点为4条线路中任意一站。
4. 乘客买票时可以有两种选择，第一种，乘客已经知道所需费用，直接选择票价，如2元、3元或4元或更多。第二种，不知道票价，选择出站口，系统以目的地与当前站的站数来进行计算价格，计算方式参考南京市轨道交通计价标准。请注意，由于换乘站的存在导致两地之间有可能有多种价格的，以最低价格为准。
5. 得到票价单价后，选择所需购买的票数，然后进行投币，投入的钱币达到所需金额时，售票机自动出票，并一次性找出余额，本次交易结束，等待下一次的交易。在投币期间，乘客可以按取消键取消本次操作，钱币自动一次性退出。

源文件与约束文件已包含。
Source code and the constraints are included.
