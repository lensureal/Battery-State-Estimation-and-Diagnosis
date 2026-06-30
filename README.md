# Battery State Estimation and Diagnosis

### Model-Based SOC Estimation & Data-Driven RUL Prediction for Lithium-Ion Batteries

A two-part laboratory project contrasting the two dominant paradigms in battery management.
Part I builds a physics-based equivalent-circuit model of a battery pack and estimates its
**State of Charge (SOC)** online with a **Kalman filter**. Part II trains an **LSTM** on real
cycling data to forecast battery health and predict **Remaining Useful Life (RUL)**.

**Authors:** Group laboratory project — **Franz Wendel** and three fellow students
(co-authors' names withheld for privacy) · **Supervisor:** Jiaqi Yao ·
**Professor:** Prof. Dr.-Ing. Julia Kowal
**Institution:** TU Berlin — Chair of Electrical Energy Storage Technology
(*Fachgebiet Elektrische Energiespeichertechnik*)

📄 The full lab reports are in [`reports/`](reports/).

---

## Overview

| Part | Problem | Approach | Tools |
| --- | --- | --- | --- |
| **I** | State of Charge — how full is the cell *now*? | Equivalent-circuit model + **Kalman filter** | MATLAB / Simulink |
| **II** | Remaining Useful Life — how many cycles are *left*? | **LSTM** trained on degradation data | Python / PyTorch |

## Group Work I — Model-Based SOC Estimation

A 36 V / 10 Ah pack (**10s4p**, 40 × LG 18650HE4 cells, 360 Wh) is modelled with a first-order
Thévenin equivalent circuit — ohmic `R0`, one `R1`–`C1` branch, and an SOC-dependent `OCV(SOC)`
— cast into state-space form and implemented in **Simulink** with SOC-driven lookup tables.
The model is discretised and used by a discrete-time **Kalman filter** (predict / update) that
estimates SOC from terminal voltage and current. Initialised with a deliberately wrong guess
(**10 % vs. a true 1 %**), the filter converges smoothly to the coulomb-counting reference and
tracks it without drift.

📁 [`01_model_based_soc_estimation/`](01_model_based_soc_estimation/) — Simulink model,
parameter script, cell-parameter data.

## Group Work II — Data-Driven RUL Prediction

An LSTM forecasts the SOH-vs-cycle degradation curve and, from it, the RUL. Data is the public
**NASA Li-ion battery dataset** (B0006/B0007 train, B0005 validation, B0018 test); SOH =
`Capacity / 2.0 Ah`, with end-of-life at SOH = 0.7. The model is a PyTorch `nn.LSTMCell` with a
**sigmoid** head (predictions stay in [0, 1]), trained with teacher forcing and run
autoregressively at inference. A grid search gave a best configuration of **lr 1e-3, 200 epochs,
hidden size 128**. RUL error shrinks as more history is supplied:

| History (cycles) | 10 | 20 | 30 | 40 | 50 | 60 | 70 | 80 | 90 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RUL error (cycles) | 12 | 11 | 10 | 8 | 7 | 8 | 7 | 5 | 3 |

📁 [`02_data_driven_rul_prediction/`](02_data_driven_rul_prediction/) — `preprocessing.ipynb`,
`lstm.ipynb`, raw + preprocessed data, and an example trained checkpoint.

## Repository contents

| Path | Description |
| --- | --- |
| `reports/` | The two full lab reports (PDF). |
| `01_model_based_soc_estimation/` | Simulink model, parameter script and cell data for the ECM + Kalman-filter SOC estimator. |
| `02_data_driven_rul_prediction/` | Notebooks, NASA dataset (raw + preprocessed) and a trained model for the LSTM SOH/RUL predictor. |

## Authors & acknowledgements

A **group laboratory project**; its results are shared among all members. Only the publishing
author is named — the other co-authors' names are omitted for privacy.

**Franz Wendel** · *(three further co-authors — names withheld)* · **Jiaqi Yao** (supervisor) ·
**Prof. Dr.-Ing. Julia Kowal** (professor)

Carried out at the Chair of Electrical Energy Storage Technology, TU Berlin. The Group Work II
data is the publicly available NASA Ames PCoE lithium-ion battery dataset.

## Citation

> Wendel, F., et al. (2026). *Battery State Estimation and Diagnosis: Model-Based SOC
> Estimation and Data-Driven RUL Prediction.* Group laboratory project, Technische Universität
> Berlin.

## License

All rights reserved — published to document an academic project; no reuse, redistribution or
modification without the authors' prior written permission. The NASA dataset under
`02_data_driven_rul_prediction/data/` remains the property of its original publisher.
