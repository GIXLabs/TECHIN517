# Lab 7: Reinforcement Learning

By now, you're familiar with how much work it takes to accumulate enough data to train AI for robotics.  
Simulating robots is one strategy to generate huge amounts data quickly for robots to learn faster.  
In this lab, we'll begin using Isaac Lab inside of Nvidia's Isaac Sim to explore Reinforcement Learning (RL).  


## Learning Objectives

- Complete the code for a managed environment in Isaac Lab.
- Train your first RL policy in Isaac Lab.
- Monitor training of the RL policy.
- Play the policy for evaluation.


## Given

- [Gymnasium by OpenAI, maintained by Farama](https://gymnasium.farama.org/)  
    Many robot RL simulators are based on the gym framework initially developed by OpenAI.  
    Reading through the documentation and basic examples is a good introduction for learning more about RL.

- [RL Libraries Included in Isaac Lab](https://isaac-sim.github.io/IsaacLab/main/source/overview/reinforcement-learning/rl_frameworks.html)  
    Integrations like this is why we're using Isaac Lab instead of developing RL in Gazebo or the real robot.  
    Isaac Lab is purpose-built for running RL studies in parallel across thousands of simulations.  

- [Lychee AI Example SO101 Isaac Lab Environment Config](https://github.com/MuammerBay/isaac_so_arm101/tree/main)  
    Muammer Bay and his Patreon community were major developers of the SO101 and robot learning in early 2025.  
    Many of the labs for this class were based on their work.  
    This lab is specifically based off of the above example.


## TODO

1. Clone the class' soa_labs Isaac Lab "external environment" repo:
    ```bash
    git clone https://github.com/GIXLabs/soa_lab.git
    ```
2. Share the repo with the Isaac Lab container.  
    If you clone the repo into your TECHIN517 repo then it should already be shared.  
    If not, add it to the Isaac Lab `docker-compose.yaml` file.
3. Write 2 to 3 sentences about the function of each term in environment config.
4. Install the correct dependencies inside of the container:
    ```bash
    /workspace/isaaclab/_isaac_sim/python.sh -m pip install --force-reinstall --no-deps "setuptools==78.1.1"
    /workspace/isaaclab/_isaac_sim/python.sh -m pip install --no-deps --force-reinstall "rsl-rl-lib==2.3.3"
    ```
4. Install the `soa_lab` python library in the Isaac Lab container using:
    ```bash
    cd /workspace/isaaclab
    ./isaaclab.sh -p -m pip install -e /path/to/your/soa_lab/source/soa_lab
    ```
5. Train reinforcement learning using the SOA environment config using:
    ```bash
    cd /path/to/your/soa_lab
    isaaclab -p scripts/rsl_rl/train.py --task=Template-Soa-Lab-v0 --num_envs 4096 --max_iterations 10000
    ```
    You shouldn't need all 10,000 iterations for the robot to learn how to pick up a cube.  
    Watch the training until it looks like all the arms are completing the task correctly.  
    You can control-C the training when it works without waiting for all iterations.  
    This can go faster or slower by changing the number of environments with `--num_envs`.  
6. Monitor training with [Tensorboard](https://www.tensorflow.org/tensorboard) using:
    ```bash
    docker exec -it isaac-lab-ros2 bash
    cd /workspace/isaaclab
    ./isaaclab.sh -p -m tensorboard.main --logdir /path/to/your/soa_lab/logs/rsl_rl --bind_all
    ```
    Turn on "Reload data" using the gear icon at the top.  
    Capture a screenshot of the `Train/mean_reward` graph for the deliverables below.
7. Play the policy on a single arm to verify it worked:
    ```bash
    isaaclab -p scripts/rsl_rl/play.py --task=Template-Soa-Lab-v0 --num_envs 1
    ```
8. Try changing one of the rewards between +/- 0.5 to 5.0.  
    Train the model again for roughly the same amount of time as your successful run.  
    Capture a second screenshot of the `Train/mean_reward` graph for the deliverable below.


## Deliverables

1. Submit your code explanation writing.

2. Submit both screenshots of your `Train/mean_reward` graph.

3. Submit a video of the SO101 in Isaac Lab successfully picking the cube to the goal position.

4. Write a paragraph comparing the training process before and after you changed a reward.  
    **Do not use AI.**  
    Which reward did you change?  
    Hypothesize about why it effected the training results.


## Resources

[Isaac Lab Official Documentation](https://isaac-sim.github.io/IsaacLab/main/index.html)

[Isaac Lab Official Examples](https://isaac-sim.github.io/IsaacLab/main/source/overview/environments.html)  
If you ever need to develop an environment config from scratch, the best place to start is by referencing working examples.

[Isaac Lab External Project Creation Documentation](https://isaac-sim.github.io/IsaacLab/main/source/overview/own-project/template.html)  
[Lychee AI YouTube Tutorial](https://www.youtube.com/watch?v=i51krqsk8ps)  
NVIDIA provides these tools to create "external projects" for Isaac Lab to enable collaboration and version control.  
Before these tools, researchers were saving their work in the Isaac Lab directory.  
This made it difficult to disentangle their work to upgrade Isaac Lab, and for others to recreate their results.

[Comparison of different RL simulation environments by FS Studio on LinkedIn](https://www.linkedin.com/pulse/comparative-analysis-robotic-simulation-environments-fs-studio-cpjic)  
There are many simulation platforms for robotics, many of which support RL to some extent.  
Each platform has different trade-offs for support / documentation / community / features / etc.  
We are using NVIDIA Isaac Sim and Isaac Lab to give you experience in the state-of-the-art.
