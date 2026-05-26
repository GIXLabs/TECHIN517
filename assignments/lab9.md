# Lab 9: Sim to Real

Now that you've made you have increased the robustness of reinforcement learning through domain randomization, you'll learn how to run your policy on the real robot with ROS.
This lab shows how you would run the cube-lifting policy from labs 7 and 8 as a ROS2 action.  


## Learning Objectives

- Export RL policies from Nvidia Isaac Lab
- Deploy RL policies from Nvidia Isaac Lab to ROS


## Given

- [Nvidia tutorial on deploying RL policies in ROS](https://nvidia-isaac-ros.github.io/reference_workflows/isaac_for_manipulation/packages/isaac_manipulator_ur_dnn_policy/index.html)

- [Nvidia ROS policy example code](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_manipulation/tree/release-4.3/isaac_manipulator_ur_dnn_policy)


## TODO

1. Make sure your ros workspace is up-to-date, this lab requries a new action file in `soa_interfaces` and the new `soa_sim2real` package.  
2. Play the policy in Isaac Lab.    
    ```bash
    isaaclab -p scripts/rsl_rl/play.py --task=Template-Soa-Lab-v0 --num_envs 1
    ```
    By running the play command, Isaac Lab exports a snapshot of the trained policy.  
3. Move the policy from Isaac Lab logs to ROS.  
    Look into the log folder of the model you trained:  
    `/path/to/your/soa_lab/logs`  
    Exporting the policy saves a `exported` folder with `.onnx` and `.pt` model files, and a `params` folder with parameter `.yaml` files in the latest log folder.  
    Move the `policy.pt` file into `soa_ros2/soa_sim2real/models`.  
4. Complete the `TODO`s in `soa_sim2real/observation_assembler.py`  
5. Complete the `TODO`s in `soa_sim2real/policy_runner.py`.
6. Complete the `TODO`s in `soa_sim2real/lift_object_server.py`.

**DO NOT RUN YOUR POLICY ON THE ROBOT**

Despite all this work, the policy still isn't ready for sim-to-real transfer and running the policy would make the robot crash out and destroy your setup.  

If you were to run it, you would:
1. Bringup the robot with cameras and the forward command controller
2. Launch the aruco cube tracker to give the observations an object frame
3. Launch the lift object action server
4. Call the action server from an action client, or the command line

If you run your policy in real-life, you will probably break your robot, and your team will be sad.


## Deliverables

1. Copy your `observation_assembler.py`, `policy_runner.py`, and `lift_object_server.py` files into your lab report.
2. Write a paragraph speculating about what additional work would be required to run the policy on the real robot.  
    **Do not use AI.**  
    Check out some of the resources below for inspiration.  
    What additional system ID work would be required?  
    What other rewards / events / curriculum could make the polciy more ready for the real world?  
    What additional sensors or processing could be added to the real robot to better transfer observations?  


## Resources

https://docs.nvidia.com/learning/physical-ai/sim-to-real-so-101/latest/index.html

https://www.agilityrobotics.com/content/crossing-sim2real-gap-with-isaaclab

https://irvin.quest/basic-sim2real/

https://www.youtube.com/watch?v=rKgIrFbZTeY

https://www.youtube.com/watch?v=8wJVWRbssu8
