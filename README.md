# 3D CFD Simulation of Ammonia Leakage and Dispersion in an Industrial Room

## Overview
This project presents a **3D Computational Fluid Dynamics (CFD) simulation** of ammonia (NH₃) leakage inside an enclosed industrial room. The objective is to analyze the **dispersion behavior of leaked ammonia gas**, understand the **mixing dynamics with air**, and evaluate how **obstacles inside the room influence gas transport**.

The simulation was performed using **SimScale**, with the geometry modeled in **Onshape**. A transient incompressible CFD model with turbulence modeling was used to capture the flow characteristics and dispersion patterns.

---

## Problem Statement
Ammonia is widely used in **industrial refrigeration and chemical processing pipelines**. Leakage of ammonia in enclosed spaces can lead to **toxic exposure risks and safety hazards**.

Understanding how ammonia disperses within confined environments is essential for:

- Industrial safety analysis  
- Ventilation system design  
- Leak detection strategies  

This project simulates a **pipeline leakage scenario** inside a closed room to study **gas dispersion patterns over time**.

---

## Geometry
The simulation domain represents a simplified industrial room.

**Room dimensions**

```
10 m × 6 m × 4 m
```

Components included in the model:

- Industrial room enclosure  
- Cylindrical obstacle representing equipment  
- Pipeline leak opening on the wall  

The geometry was created in **Onshape CAD** and exported to SimScale for simulation.

---

## Simulation Setup

### Solver
Transient incompressible flow solver.

### Turbulence Model
```
k-ω SST turbulence model
```

### Passive Scalar Transport
Ammonia concentration was modeled using a **passive scalar transport equation**, allowing the simulation to track the **dispersion of NH₃ within the air domain**.

### Boundary Conditions

| Boundary | Condition |
|--------|--------|
| Leak opening | Velocity inlet |
| Room outlet | Pressure outlet |
| Walls | No-slip wall condition |

Leak velocity:

```
30 m/s
```

Outlet pressure:

```
0 Pa (gauge pressure)
```

Initial ammonia concentration:

```
0 (pure air inside the room initially)
```

Ammonia concentration at leak:

```
1 (pure NH₃ source)
```

---

## Simulation Parameters

| Parameter | Value |
|--------|--------|
| Simulation type | Transient |
| Total simulation time | 100 s |
| Time step | 0.2 s |
| Turbulence model | k-ω SST |

Probe points were placed at multiple locations in the room to track **time evolution of ammonia concentration and velocity**.

---

## Results

The simulation provides insights into:

- Formation of the **ammonia jet plume** from the leak
- **Interaction of the plume with the cylindrical obstacle**
- Development of **recirculation regions**
- Mixing and dispersion of ammonia within the room

Key visualizations generated include:

- Velocity field contours
- Ammonia concentration distribution
- Probe point time-series plots
- Flow interaction with obstacles

These results help illustrate how **gas dispersion evolves inside enclosed industrial environments**.

---

## Key Observations

- The leak generates a **high velocity jet** entering the room.
- The cylindrical obstacle introduces **wake turbulence and recirculation zones**, enhancing mixing.
- Ammonia concentration increases progressively as the plume spreads through the room.

---

## Project Workflow

```
Onshape (CAD modeling)
        ↓
Geometry export
        ↓
SimScale (CFD simulation)
        ↓
Transient flow solution
        ↓
Post-processing and visualization
```

---

## Repository Contents

```
Ammonia-Leak-CFD
│
├── geometry
│   └── Diffusion.step
│   └── Leakage.step
│
├── images & animations
│   ├── chart.png
│   ├── image.png
│   ├── result.mp4
│
├── data
│   └── probe_concentration.csv
│
└── presentation
    └── ammonia_leak_simulation.pdf
```

**Note:**  
The full CFD solver output (~11 GB) is not included due to repository size limitations. Only processed results and visualization outputs are provided.

---

## Future Work

Possible extensions of this project include:

- Using a **detailed industrial CAD model** instead of a simplified room geometry  
- Incorporating **thermal effects and temperature-driven buoyancy**  
- Studying **different leakage sizes and pressures**  
- Investigating the impact of **ventilation systems** on gas dispersion  

---

## Tools Used

- **Onshape** – CAD modeling  
- **SimScale** – CFD simulation platform  
- **CFD turbulence modeling (k-ω SST)**  

---

## Author

**Srajan Mishra**  
