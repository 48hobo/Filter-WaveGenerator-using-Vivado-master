# Filter-WaveGenerator-using-Vivado-master
# Wave-Generator-and-Filter-Based-on-Vivado-master
项目概要：
实现了一个 8 位 FIR 低通滤波器，截止频率为 500Hz，对输入的波形幅值数据（8bit）进行低通滤波；
② 实现了一个可发生不同频率、幅度及相位的正弦波、方波、三角波信号的波形发生器模块，并可接DAC 输出；
③ 实现了开发板与电脑之间的 UART 串口通信，并在此基础上用 Python 编写了一个含 GUI 的 PC 端程序，能够利用串口通信接收开发板传来的输出波形数据并将其可视化，同时也可以对波形发生器的频率、相位、发生波形及开发板传输波形数据的频率加以控制。
应用领域：
① 波形发生器模块发生波形准确，且可通过 PC 端程序设置其各类参数，故可灵活用于各类需要提供特定波形输出的场合，如系统测试、实验等；
② 低通滤波模块可用于各类需滤除高频干扰的场合。

Vivado版本：2018.3

板卡型号：xc7s15ftgb196-1

仓库目录介绍：Sourcecode文件夹存放项目；ExecutableFiles存放.bit文件；TestVid文件夹存放测试视频。
