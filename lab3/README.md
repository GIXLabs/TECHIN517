# Lab 3


## Learning Objectives

- Setup a robot manipulator using MoveIt
- Control the SO101 arm using forward kinematics
- Control the SO101 arm using inverse kinematics


## TODO

1. Create a MoveIt configuration package for the robot arm:  
    1. Run the following command to bringup the MoveIt Setup Assistant:  
        ```bash
        ros2 launch moveit_setup_assistant setup_assistant.launch.py
        ```
    2. On the start screen, choose "Create New MoveIt Configuration Package"  
        Set the URDF file to: `/home/ubuntu/techin517/so101_ws/src/so101_ros2/so101_description/urdf/so101_new_calib.urdf`  
    3. On the Self-Collisions page, press "Generate Collision Matrix"  
    4. On the Virtual Joints page, select "Add Virtual Joint"  
        Name it `virtual_joint`  
        Set the Child Link to `base_link`  
        Set the Parent Link to `world`  
        Make sure it's a `fixed` joint
    5. On the Planning Groups page, select "Add Group"  
        Call this group `arm`  
        For the kinematic solver, choose: `kdl_kinematics_plugin/KDLKinematicsPlugin`  
        For the group default planner, choose: `RRTConnect`  
        Press "Add Joints" and add: 
        - `shoulder_pan`
        - `shoulder_lift`
        - `elbow_flex`
        - `wrist_flex`
        - `wrist_roll`

        Press "Add Group" again  
        Call this group `gripper`  
        Press "Add Joints", add the `gripper`, and save
    6. On the Robot Poses page, select "Add Pose"  
        Call this pose `open`  
        Change the planning group to `gripper`  
        Slide the position all the way open  
        Save and select "Add Pose" again  
        Call this pose `close`  
        Change the planning group to `gripper`
        Slide the position all the way closed
    7. On the End Effectors page, select "Add End Effector"  
        Name it `end_effector`  
        Set the group to `gripper`  
        Set the parent link to `gripper_link`  
        Set the parent group to `arm`  
    8. On the ROS2 Controllers page, select: "Auto Add JointTrajectoryController Controllers For Each Planning Group"  
        Click on the gripper controller and select "Edit Selected"  
        Change the controller type to `position_controllers/GripperActionController`
    9. On the MoveIt Controllers page, select: "Auto Add FollowJointsTrajectory Controllers For Each Planning Group"  
        Click on the gripper controller and select "Edit Selected"  
        Change the controller type to `GripperCommand`
    10. On the Author Information page, enter your name and school email
    11. On the Configuration Files page, select "Browse"  
        Navigate to the `src` folder of your workspace  
        Create a folder called `so101_moveit_config`  
        Click "choose"  
        Click "Generate Package"  
    12. Click "Exit Setup Assistant"  
    13. In the newly created package, open the file `so101_moveit_config/config/joint_limits.yaml`  
        Change all integers to floats: e.g. `10` >> `10.0`
    14. Build your workspace  
    15. Make sure it worked by running
        ```bash
        # TODO
        ```

2. Fill in the example code to pick up a block using forward kinematics.

3. Fill in the example code to pick up a block using inverse kinematics.


## Deliverables


## FAQ


## Resources
