# Lab 1: LeRobot Ex Machina

In this quarter, we will survey AI in robotics with robot arms.  
We will use the [SO101 arm](https://github.com/TheRobotStudio/SO-ARM100) to explore imitation learning, computer vision, and reinforcement learning.  
The first step is to assemble the arms and configure the working environment.  
Many of the labs for this course assume you have a GPU that works with Nvidia technologies.  
If you do not, please use the desktops in the robotics lab area.  


## Learning Objectives

- Assemble and calibrate a robot arm.
- Configure a Docker container to develop the arm with ROS, lerobot, and GPUs.


## TODO

**As a project team**

1. Collect a robot arm kit from the instructors.  
Fill out the included packing slip to confirm you recieved all necessary parts.  

2. Follow the [instructions](https://huggingface.co/docs/lerobot/en/so101) to assemble your arm while you discuss your project.  

**Individually**

1. Clone this repo with the following command:
    ```bash
    git clone --recursive https://github.com/GIXLabs/TECHIN517.git
    ```
    The `--rescursive` option also clones the included dependencies.  
    The scripts in this repo will not work properly without them.  

2. Configure your Docker install to work with Nvidia GPUs:  
Run the following command to make sure your GPU drivers are installed:  
    ```bash
    nvidia-smi
    ```  
    This should print information about your GPU, otherwise you will need to install the right drivers.  
    Next you will need to install [Nvidia's container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
    Follow the instructions for Debian / Ubuntu.  

3. Fill out the partial [Dockerfile](/docker/INCOMPLETE_Dockerfile).  
Follow the `TODO` comments in the file.  
You should not need to modify the `devcontainer.json` or `setup.sh` files.  
Your `Dockerfile` should work with these other configurations to create a working dev environment.  
We will use a separate container to use Isaac Sim later.  

4. Follow the [instructions](https://huggingface.co/docs/lerobot/en/so101) to configure and calibrate the arms.  
Use the name on the side of the robot for the calibration name.  
If you configured your container properly, all lerobot command should work properly.  

5. Read through [LeRobot's guide](https://huggingface.co/docs/lerobot/il_robots) on imitation learning.  
Follow [the guide to teleoperate using a camera](https://huggingface.co/docs/lerobot/cameras#setup-cameras).  
Use both the wrist-mounted camera and the overhead depth camera.  

6. Train the policy again after 50 total examples.  
    We highly recommend recording a couple episodes before going for all 50 to ensure everything is working properly.  
    Hihgly recommend recording with the following argument to avoid additional setup:
    ```bash
    --dataset.push_to_hub=False
    ```
    Highly recommend training with the following argument to avoid additional setup:
    ```bash
    --push_to_hub=false
    ```
    **Plan for training to take a few hours**  
    Record a video of running inference after 50 examples.


## Deliverables 

1. Return the packing slip that came with the kit with everyone's name to confirm you recieved all the necessary parts.  

2. Submit a video of you teleoperating the robot arm.  
You might need to wait on another team to finish assembling their leader / follower arm.  
Please be patient with the other team(s) and assemble your arm as soon as possible.

3. Submit your Dockerfile.

4. Submit a screenshot of the SO101 arm in Rviz2 in the Docker container.

5. Upload your arms calibration to the course Google Drive to share with the class.   
Any time you need to use a new arm, you should be able to download the calibration.  
If you need to update the calibration at any point, make sure to update the file in the drive as well. 

6. Submit your video of running inference after training with 50 examples.


## FAQ

**Q:** I have a GPU but `nvidia-smi` doesn't print anything, how do I install the drivers?  
**A:** Open the "Software and Updates" program and look for drivers under the "Additional Drivers" section.  

**Q:** My motors aren't working, why?  
**A:** You might need to update the motor's firmware.  
Refer to [the documentation](https://huggingface.co/docs/lerobot/feetech) for a guide on how to do so.  

**Q:** When I try to calibrate an arm it errors out and says it's out of bounds, what do I do?  
**A:** Unplug both power and data from the 

**Q:** The motor position values jump when trying to calibrate the arm, then the arm jumps when teleoping the robot, why?  
**A:** Try calibrating the robot again, only move one joint at a time slowly.

**Q:** The calibration script says my motor's values are out of range, what do I do?  
**A:** You can use [this open-source software](https://github.com/CarolinePascal/FT_SCServo_Debug_Qt/tree/fix/port-search-timer) to check the firmware version of the motors.  
Make sure that all motors have the same version.  
If a motor has a different version, you will need a Windows computer to change the firmware.  
If all motors have the right firmware, try disconnecting and reconnecting the power and trying again.  
This might take many tries.  

**Q:** When I try to record an example it says the camera times-out even though the camera works during teleoperation?  
**A:** Check out [this Github issue](https://github.com/huggingface/lerobot/issues/1675).  
You should be able to record examples at 30fps with the given cameras.  

**Q:** The lerobot-record script hangs at the end, why won't it finish?  
**A:** Your container might not be able to launch the Rerun GUI, record with ```--display_data=false``` to avoid startup/shutdown issues.  


## Resources

[Seeed Studios Wiki Guide for the SO101](https://github.com/Seeed-Studio/wiki-documents/blob/docusaurus-version/docs/Robotics/Robot_Kits/Lerobot/Lerobot_SO100Arm.md)

[Dockefile Keywords List](https://docs.docker.com/reference/dockerfile/)  
As you modify the given Dockerfile, checkout this list to see what the keywords do.  

[Docker for Robotics YouTube Playlist by Articulated Robotics](https://www.youtube.com/playlist?list=PLunhqkrRNRhaqt0UfFxxC_oj7jscss2qe)  
Environment management is extremely important for robotics development!  
We would run into infinitely more issues if all students installed these workspaces onto their own host machines.  
This lab requires you to modify a Dockerfile because understanding Docker genuinely makes development so much easier.  
