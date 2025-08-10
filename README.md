# Polaris

## Contributors
- Soumil Verma — [LinkedIn](https://www.linkedin.com/in/soumilverma/) — Communication Protocols & Sensor Integration Lead — Developed IMU/SPI interfaces and sensor fusion for real-time control
- Vikash Gunalan — [LinkedIn](https://www.linkedin.com/in/vikash-gunalan/) — Mechanical & Control Systems Lead — Designed motion platform and implemented PID control logic for balancing algorithms  
- **Mentored By:** Johnny Hazboun — [LinkedIn](https://www.linkedin.com/in/johnny-hazboun/)


## Project Overview
Polaris is a custom 2D Ball Balancer system, developed as part of the [Purdue STARS 2025](https://engineering.purdue.edu/semiconductors/stars) program.  
Inspired by the concept of creating our own microcontroller, we designed Polaris as an Application-Specific Integrated Circuit (ASIC) prototype, implemented entirely in SystemVerilog, and tested using a Lattice ICE40 FPGA and GTKWave.

The system integrates real-time motion control, sensor fusion, and communication protocols to stabilize a ball along two axes. While final PID tuning was not completed due to time constraints, the project successfully demonstrated all core subsystems — including sensor data acquisition, filtering, and actuator control — operating together in real time.


## Pin Layout
## External Hardware

![image0](docs/IMG_4426.jpeg)
![image1](docs/IMG_4424.jpeg)
![image2](docs/IMG_4427.jpeg)



3D Printed Components: Seen above.
LCD Display: TFT 1602, Seen above.
Custom PCB:

IMU: ICM-20948
https://invensense.tdk.com/wp-content/uploads/2024/03/DS-000189-ICM-20948-v1.6.pdf 
IR Sensor: MH Flying Fish
Shift Registers: SNx4AHC125 Quadruple Bus Buffer Gates With 3-State Outputs                                                                                                                                              
https://www.ti.com/lit/ds/symlink/sn74ahc125.pdf 
Level Shifter: SNx4HC125 Quadruple Buffers with 3-State Outputs
https://www.ti.com/lit/ds/symlink/sn74hc125.pdf?ts=1754597629858&ref_url=https%253A%252F%252Fwww.ti.com%252Fproduct%252FSN74HC125 

Breadboarding / Wiring
![image3](docs/breadboard.jpg)
![image4](docs/lcd.jpg)
 


## Functionality Description and Testing
This project is automatic! All the user has to do is turn it on with the “enable” button and reset it if they want to. After that simply, place a ping pong ball on the platform (or lightly lob it onto the platform) and the platform will adjust to try to bring it to the center. If it is unable to, adjust the setpoint and PID gains. 


## RTL Diagrams
Only the top level and SPI RTLs are shown here. Click [here](https://drive.google.com/file/d/1eGJFjpFtNKYYbWGMnWZV2Z53K3y8pnwY/view?usp=sharing) for the full RTL diagram.

Top Level RTL:
![image5](docs/Stabilizer-Top-Level%20RTL(1).jpg)

SPI with IMU RTL:
![image6](docs/Stabilizer-IMU%20Interface(4).jpg)









