# MTH1060XA-Capstone-Group5
# Social Media Influence Analysis (Agent-Based Model in MATLAB)
MTH1060XA Capstone Project 5, Group 5, Fall 2026, USIU-Africa

Members: Ahlam Mohammed (672466), Mann Patel (676738), Rama Idris (673085)

## Overview
An agent-based model of how information spreads through a social network,
studying the effects of trust, content virality and network structure
(random vs small-world).

## How to run
1. Open MATLAB and set the current folder to `Code/`.
2. Run `SocialMediaSimulation.m` for a single simulation.
3. Run `CompareScenarios.m` for the 8 scenarios × 10 runs.
4. Run `CascadeVisualization.m` for the cascade plot.
Outputs are saved to `Results/`.

## Files
- `SocialAgent.m`: agent class
- `createSocialNetwork.m`: builds random / small-world networks
- `runDiffusion.m`: the diffusion simulation
- `Report/Project_Report.pdf`: full analysis
- `Presentation/`: slides
