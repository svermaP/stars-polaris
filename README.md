# Polaris

## Contributors
- Soumil Verma — [LinkedIn](https://www.linkedin.com/in/soumilverma/) — Communication Protocols & Sensor Integration Lead — Developed IMU/SPI interfaces and implemented sensor fusion for real-time control
- Vikash Gunalan — [LinkedIn](https://www.linkedin.com/in/vikash-gunalan/) — Mechanical & Control Systems Lead — Designed motion platform and implemented PID control algorithms for real-time balancing
- **Mentored By:** Johnny Hazboun — [LinkedIn](https://www.linkedin.com/in/johnny-hazboun/)


## Project Overview
Polaris is a custom 2D Ball Balancer system, developed as part of the [Purdue STARS 2025](https://engineering.purdue.edu/semiconductors/stars) program.  
Inspired by the concept of creating our own microcontroller, we designed Polaris as an Application-Specific Integrated Circuit (ASIC) prototype, implemented entirely in SystemVerilog, verified through simulation analysis in GTKWave, and tested on a Lattice ICE40 FPGA

The system integrates real-time motion control, sensor fusion, and communication protocols to stabilize a ball along two axes. While final PID tuning was not completed due to time constraints, the project successfully demonstrated all core subsystems — including sensor data acquisition, filtering, and actuator control — operating together in real time.

## External Hardware  
Polaris uses the following key hardware components:
- **3D Printed Components:**
- **Platform and structural parts** (seen below)  
- **LCD Display:** TFT 1602  
- **Custom PCB:**  
  - **IMU:** [ICM-20948 Datasheet](https://invensense.tdk.com/wp-content/uploads/2024/03/DS-000189-ICM-20948-v1.6.pdf)  
  - **IR Sensor:** MH Flying Fish  
  - **Shift Registers:** [SN74AHC125 Datasheet](https://www.ti.com/lit/ds/symlink/sn74ahc125.pdf)  
  - **Level Shifter:** [SN74HC125 Datasheet](https://www.ti.com/lit/ds/symlink/sn74hc125.pdf)

![image0](docs/IMG_4426.jpeg)
![image1](docs/IMG_4424.jpeg)
![image2](docs/IMG_4427.jpeg)


**Breadboarding / Wiring**  
This is an example of how the system can be wired. For reference, the most important connections for using the system are described in the comments of *top.sv*.  
![image3](docs/breadboard.jpg)
![image4](docs/lcd.jpg)
 


## Functionality Description and Testing
This project is automatic! Once powered on via the “enable” button, Polaris automatically begins stabilizing. The user can place a ping pong ball on the platform, and the system will adjust the platform angle in real time to center the ball. If needed, the setpoint and PID gains can be adjusted to optimize performance. Play around with it and push the system to its limits!

## How to use
The top.sv file has the main Stabilizer module instantiated, and should work as is. Make sure to configure your inputs and outputs as detailed by the comments below the instantiation. Note: All the inputs are active-high, except reset which is expected to be active low.


## RTL Diagrams
Only the top level and SPI RTLs are shown here. Click [here](https://drive.google.com/file/d/1eGJFjpFtNKYYbWGMnWZV2Z53K3y8pnwY/view?usp=sharing) for the full RTL diagram.

Top Level RTL:
![image5](docs/Stabilizer-Top-Level%20RTL(1).jpg)

SPI with IMU RTL:
![image6](docs/Stabilizer-IMU%20Interface(4).jpg)
