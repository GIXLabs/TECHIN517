# Lab 8: Advanced RL

It is amazing to see robot arms quickly learn manipulation tasks in simulation.  
However, getting the system to work once is typically not sufficient for controlling the real arm with the same policy.  
The real world presents a huge variance in parameters such as environmental factors, joint dynamics, object poses, etc.  
In this lab, we will learn how to train across a range of these factors to increase the robustness of the policy.


## Learning Objectives

- Increase domain randomization to make RL policies more robust
- Evaluate headless training

## Given

- [GIX soa_lab](https://github.com/GIXLabs/soa_lab)  
    We know this environment configuration can train a policy in simulation.  
    Over the course of this lab you will include events, rewards, and curriculum that challenge the policy to work in more challenging scenarios, towards transfering the policy from simulation to reality.  


## TODO

1. Add the following imports to the environment config:
    ```python
    from isaaclab.utils.noise import AdditiveGaussianNoiseCfg as Gnoise
    from isaaclab.utils.noise import AdditiveUniformNoiseCfg as Unoise
    ```
    - Add +/- `0.005` `Unoise` to the `joint_pos_rel` observations.  
    - Add +/- `0.05` `Unoise` to the `joint_vel_rel` observations.  
    - Add +/- `0.002` `Gnoise` to the `ee_position_in_robot_root_frame` observation.  
    - Add +/- `0.001` `Gnoise` to the `object_position_in_robot_root_frame` observation.  
    - Add `history_length=3` to the `last_action` observation.  
    - Set `enable_corruption=True` for observations.  
2. Modify the `reset_object_position` to randomize the cube's reset position.
3. Add an events to: 
    - Randomize the robot's joint positions on reset
    - `apply_arm_disturbances` on an interval.
    - Randomize the robots physics material to randomize friction.
    - Randomize actuator gains
    - Randomize joint friction
    - Randomize object mass
    
    Functions for all of these randomizations should be in the `mdp`.
4. Add curiculum to:
    - Increase the range of object location spawning position
    - Modify the goal Z-height of the object
    - Increase the object pose noise
    - Increase the arm joint reset range
    - Increase joint friction range

    Add a few terms per modification to step modifications gradually.  
    Spread out the iterations you modify parameters; don't change too many parameters in too short of a iteration span.  
5. Train headless and monitor the training using Tensorboard.
    ```bash
    isaaclab -p scripts/rsl_rl/train.py --task=Template-Soa-Lab-v0 --num_envs 8192 --max_iterations 5000 --headless
    ```
    ```bash
    ./isaaclab.sh -p -m tensorboard.main --logdir /path/to/your/soa_lab/logs/rsl_rl --bind_all
    ```
    Continue training and modifying the environment config until Tensorboard shows the `Train/mean_reward` converging at a high reward.
6. Play the trained policy after training is complete
    ```bash
    isaaclab -p scripts/rsl_rl/play.py --task=Template-Soa-Lab-v0 --num_envs 1
    ```


## Deliverables

1. Submit your final `Train/mean_reward` graph.
2. Submit a video of the policy working in simulation. 
3. Write a paragraph explaining how you would apply reinforcement learning to your project.  
    **Do not use AI.**  
    What other information, assets, and variables would you need to include in the simulation?  
    What would you randomize to effectively cover the domain of your project?


## Resources

[Reinforcement Learning by Sutton and Barto](http://incompleteideas.net/book/RLbook2020.pdf)  
This book is often referred to as the "RL Bible".  
Reading through chapter 3 is a good intro into the MDPs used by Isaac Lab.

[A (Long) Peek into Reinforcement Learning by Lilian Weng](https://lilianweng.github.io/posts/2018-02-19-rl-overview/)  
A good overview of the key concepts and math for reinforcement learning.

[Wheeled Lab by researchers at UW!](https://www.youtube.com/watch?v=Y4b-cz2xB1w)