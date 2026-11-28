# MTH1060XA-Capstone-Group5

# Social Media Influence Analysis (Agent-Based Model in MATLAB)

MTH1060XA Capstone Project 5, Group 5, Fall 2026, USIU-Africa

**Members:** Ahlam Mohammed (672466), Mann Patel (676738), Rama Idris (673085)

## Overview

An agent-based model of how information spreads through a social network. Each user is an agent with a trust level, a sharing propensity and an exposure status. The model studies how three factors affect the reach of information:

- **User trust** (low 0.30 vs high 0.80)
- **Content virality** (low 0.30 vs high 0.70)
- **Network structure** (random vs small-world)

Combining these gives 8 scenarios, each run 10 times (80 simulation runs in total) on a network of 100 users.

## Repository structure

| Folder | Contents |
|---|---|
| `Codes/` | MATLAB scripts and functions |
| `Results/` | Figures, CSV and `.mat` files produced by the scripts |
| `Reports/` | Final project report (Word and PDF) |
| `Presentation/` | Project presentation slides |

## How to run

1. Open MATLAB and set the current folder to `Codes/`.
2. Run `SocialMediaSimulation.m` for a single simulation (random network, high trust, high virality). It saves the diffusion plot.
3. Run `CompareScenarios.m` for all 8 scenarios with 10 runs each. It saves the comparison figures and results table.
4. Run `CascadeVisualization.m` for the information cascade plot.

All outputs are saved automatically to the `Results/` folder, which must sit next to `Codes/`. MATLAB creates it if it is missing.

## Files in `Codes/`

| File | Purpose |
|---|---|
| `SocialAgent.m` | Agent class (ID, HasSeen, Trust, SharingPropensity, ParentID, ExposureTime) |
| `createSocialNetwork.m` | Builds the random or small-world network as an adjacency matrix |
| `runDiffusion.m` | Runs one diffusion simulation and returns the spread and cascade data |
| `SocialMediaSimulation.m` | Runs and plots a single simulation |
| `CompareScenarios.m` | Runs the 8 scenarios, 10 runs each, and plots the comparison |
| `CascadeVisualization.m` | Draws who shared with whom as a cascade graph |

## Model summary

- A user who has seen the information can pass it to neighbours who have not seen it.
- The probability of a successful share is **P = V × T × S**, where V is content virality, T is the trust of the receiving user and S is the sharing propensity of the sharing user (random between 0.6 and 0.8). P is limited to the range 0 to 1.
- Each user shares at most once, and newly informed users share in the next time step.
- Simulations run for up to 20 time steps, starting from User 1.

## Changing the scenarios

The trust levels, virality levels and network types are set at the top of `CompareScenarios.m` (`trustLevels`, `viralityLevels` and `networkTypes`). Values for a single run are set in the `params` block of `SocialMediaSimulation.m`.

## Main findings

- Wide spread occurred only when **both trust and virality were high** (Scenario 4: 78.30% average reach, Scenario 8: 69.70%). The other six scenarios stayed below 7%.
- Random and small-world networks did not differ clearly, because the gap is smaller than the run-to-run variation.
- Results vary a lot between runs when conditions are favourable, so a single run can differ from the average.

See the report in `Reports/` for the full analysis.
