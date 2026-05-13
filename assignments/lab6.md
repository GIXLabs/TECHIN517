# Lab 6: The Green Pill: Isaac Sim

This week we will begin using Nvidia's Isaac Sim.  
Isaac Sim is another simulation platform that includes features for [simulating robots, computer-vision synthetic data generation, maintaining digital-twins, reinforcement learning, more](https://docs.isaacsim.omniverse.nvidia.com/6.0.0/index.html).  


## Learning Objectives

- Import a URDF into Isaac Sim.
- Specify parameters required to accurately simulate robot arms.
- Connect information from ROS to Isaac Sim. 


## Given

- [Isaac Sim](https://developer.nvidia.com/isaac/sim)

- [Lychee AI tutorial for importing the SO101 into Isaac Sim](https://www.youtube.com/watch?v=AMfEtZ4hyLY)  
    In this tutorial, Muammer Bay shows the correct settings for accurately simulating the arm.  
    Without these settings, it would take significant testing, trial, and error to make the robot work in simulation.  
    If you would like to continue learning more about robot learning, look for robots that are officially or community supported in the technologies you would like to use.

- [Lychee AI tutorial for teleoperating the SO101 from ROS in Isaac Sim](https://www.youtube.com/watch?v=VChG0cn05_0&t=221s)  
    Around the release of the SO101 arm, there was a large community effort to integrate the arm with robot learning technologies, many of these efforts were driven by Lychee AI and sponsored by NVIDIA.


## TODO

1. Install Isaac Sim and Isaac Lab.  
    There are many ways to install Isaac Sim, we're going to use Nvidia's Isaac Lab Docker container.  
    - Clone Nvidia's Isaac Lab version 2.2.1 **into your home directory on the host computer, not in the container!**:
        ```bash
        cd
        git clone https://github.com/isaac-sim/IsaacLab.git
        cd IsaacLab
        git checkout v2.2.1
        ```
    - Open the repo in VS Code

2. Connect the Isaac Sim container to the class container.
    - In the file `IsaacLab/docker/.ros/fastdds.xml`, add the following `interfaceWhiteList` after `<type>UDPv4</type>`
        ```xml
        <transport_id>UdpTransport</transport_id>
            <type>UDPv4</type>
            <interfaceWhiteList>
                <address>127.0.0.1</address>
            </interfaceWhiteList>
        ```
    - In the file `IsaacLab/docker/.env.ros2`, append `ROS_LOCALHOST_ONLY=1` to the end
    - Add your class repo as a volume in `IsaacLab/docker/docker-compose.yaml`
        ```yaml
        - existing volumes...
        - type: bind
          source: .isaac-lab-docker-history
          target: ${DOCKER_USER_HOME}/.bash_history
        # TODO: add class repo as a shared volume
        - type: bind
          source: <relative/path/to/your/class/repo>
          target: /techin517
        ```
    - Add the dev directory as a volume
        ```yaml
        - type: bind
          source: /dev
          target: /dev
        ```
    - Add the apps directory as a volume
        ```yaml
        - type: bind
          source: ../apps
          target: ${DOCKER_ISAACLAB_PATH}/apps
        ```
    - In `IsaacLab/docker/Dockerfile.ros2`, make the following change:  
        Current:
        ```Dockerfile
        echo "source /opt/ros/humble/setup.bash" >> ${HOME}/.bashrc
        ```
        Change to:
        ```Dockerfile
        echo "source /opt/ros/humble/setup.bash" >> ${HOME}/.bashrc && \
        echo 'export LD_LIBRARY_PATH=/humble/lib:${LD_LIBRARY_PATH}' >> ${HOME}/.bashrc
        ```
    - Build the container with ROS2 support  
        Enter `y` when it asks if you would like to enable X11 forwarding
        ```bash
        ./docker/container.py start ros2
        ```
    - Enter the container
        ```bash
        ./docker/container.py enter ros2
        ```
    - Start Isaac Sim
        ```bash
        runapp
        ```
    - Enter `exit` to leave the container, afterwards shut it down with:
        ```bash
        ./docker/container.py stop ros2
        ```

3. Import the SO101 arm into Isaac Sim.
    - First, navigate to the `soa_description` package and run the following command to convert the `.xacro` file into a `.urdf` file that Isaac Sim can import:
        ```bash
        xacro soa.urdf.xacro > soa.urdf
        ```
    - In Isaac Sim, go to File > Import and choose  
        `/techin517/ros2_ws/src/soa_ros2/soa_description/urdf/soa.urdf`
    - Enter the following settings to approximate the physics of the arm in Isaac Sim:
        - Model: Referenced Model
        - USD Output: `/techin517/`
        - Links: Static Base
        - Default Density: 0.0
        - Joints & Drivers: Check "Ignore Mimic"
        - Joint Configuration: Natural Frequency
        - Drive Type: Force
        - Joint settings
            | Name | Target | Frequency | Damping | 
            | - | - | - | - |
            | elbow_flex | position | 10.0 | 0.7 |
            | gripper | position | 10.0 | 0.7 |
            | shoulder_lift | position | 10.0 | 0.7 |
            | shoulder_pan | position | 10.0 | 0.7 |
            | wrist_flex | position | 10.0 | 0.7 |
            | wrist_roll | position | 10.0 | 0.7 |

            Note: these values might change as you enter other values, make sure they're all correct before continuing
        - Colliders: Do **not** check "Collision From Visuals"
        - Collider Type: Convex Hull
        - Check "Allow Self-Collision"
        - Do **not** check: "Replace Cyllinders with Capsules"

        All credit to [Lychee AI](https://lycheeai-hub.com/project-so-arm101-x-isaac-sim-x-isaac-lab-tutorial-series/so-arm-import-urdf-to-isaac-sim) for providing these values.

4. Stream topics between Isaac Sim to ROS.
    - Go to Tools > Robotics > ROS 2 OmniGraphs > Joint States
    - Articulation Root > World (defaultPrim) > soa > base_link
    - Check the box for Publisher
    - Change publisher topic to /isaac_joint_states
    - Check the box for Subscriber
    - Change the subscriber topic to /isaac_joint_command

5. Teleoperate the arm from ROS to Isaac Sim.
    - Press play in Isaac Sim
    - Start teleoping the arm using ROS:
    ```bash
    ros2 launch soa_bringup soa_bringup.launch.py leader:=true
    ```
    - Run the following in ROS to connect the topics:
    ```bash
    ros2 run topic_tools relay /leader/joint_states /isaac_joint_command
    ```


## Deliverables

1. Submit a video of yourself teleoperating the arm in Isaac Sim.  
    Include your real-life setup with the follower arm and a view of the simulation screen.  

2. Write a paragraph explaining how you would begin to simulate a brand-new robot?  
    **Do not use AI.**  
    What information would you need?  
    What would you have to develop before approaching Isaac Sim?


## FAQ

**Q:** When I run `runapp` there's a lot of error messages about not having a GPU even though I have Nvidia container toolkit, how do I fix it?  
**A:** Try running `./docker/container.py stop ros2` then restart the container.  


## Resources

[Official Isaac Sim 5.0.0 documentation on importing URDFs](https://docs.isaacsim.omniverse.nvidia.com/5.0.0/importer_exporter/ext_isaacsim_asset_importer_urdf.html)  

[Leisaac from LightWheelAI](https://github.com/LightwheelAI/leisaac)  
This repo demonstrates integrating the SO101 robot arm directly from the Lerobot interface.  
Lightwheel AI is a company focused on building simulation infrastructure for physical AI to help other companies train robots in the same manner(s) we're exploring in this class.