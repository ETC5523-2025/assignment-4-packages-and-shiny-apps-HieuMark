# Creating synthetic datasets approximating the four bar graphs (A-D) from Fig.5 of "COVID-19 in low-tolerance border quarantine systems: Impact of the Delta variant of SARS-CoV-2".
# This code will:
# 1. Generate discrete-day counts (days 0..20) for traveler and worker "breach" events for each panel.
# 2. Add Poisson noise to simulate sampling variation.
# 3. Save CSV files to for download.
import numpy as np
import pandas as pd
import os

np.random.seed(42)

days = np.arange(0,21)

def make_counts(total, peak_day, spread, tail_scale=1.0):
    # Use a shifted gamma-like shape via a discretized lognormal-ish distribution
    mu = max(0.1, peak_day)
    sigma = max(0.4, spread)
    # create a continuous PDF centered near peak_day using lognormal transform
    x = days + 1e-6
    # map so that mode ~ mu by adjusting lognormal parameters approximately
    # solve roughly: mode = exp(mu_ln - sigma_ln^2) -> choose mu_ln so mode ~ mu
    sigma_ln = sigma/ max(0.5, mu+1)
    mu_ln = np.log(max(0.5, mu)) + sigma_ln**2
    pdf = (1/(x * sigma_ln * np.sqrt(2*np.pi))) * np.exp(- (np.log(x) - mu_ln)**2 / (2*sigma_ln**2))
    pdf = np.maximum(pdf, 0)
    pdf = pdf / pdf.sum()
    # scale to total, then add Poisson noise
    lam = pdf * total * tail_scale
    counts = np.random.poisson(lam)
    # if sum counts is zero due to tiny totals, distribute minimally
    s = counts.sum()
    if s == 0 and total>0:
        # distribute one per top bins
        order = np.argsort(-pdf)
        for i in range(min(total, len(days))):
            counts[order[i]] += 1
    # adjust to match total roughly by scaling if needed
    s = counts.sum()
    if s > 0:
        counts = np.round(counts * (total / s)).astype(int)
    return counts

# Panel specifications (inferred from figure captions)
specs = {
    "A_R0_3_VE_0": {"trav_total":5893, "work_total":422, "trav_peak":0.8, "trav_spread":0.6, "work_peak":5, "work_spread":1.2},
    "B_R0_3_VE_90": {"trav_total":320, "work_total":3, "trav_peak":0.8, "trav_spread":0.5, "work_peak":4, "work_spread":0.8},
    "C_R0_6_VE_0": {"trav_total":7614, "work_total":1747, "trav_peak":1.0, "trav_spread":0.9, "work_peak":5, "work_spread":1.2},
    "D_R0_6_VE_80": {"trav_total":922, "work_total":31, "trav_peak":1.2, "trav_spread":1.0, "work_peak":6, "work_spread":1.5},
}

results = {}
for name, p in specs.items():
    t_counts = make_counts(p["trav_total"], p["trav_peak"], p["trav_spread"], tail_scale=1.0)
    w_counts = make_counts(p["work_total"], p["work_peak"], p["work_spread"], tail_scale=1.0)
    # ensure arrays length 21
    results[name] = pd.DataFrame({
        "day": days,
        "traveler_counts": t_counts,
        "worker_counts": w_counts
    })

# Save CSVs
here = os.path.dirname(__file__)
out_dir = os.path.join(here, "synth_data")
os.makedirs(out_dir, exist_ok=True)
for name, df in results.items():
    path = os.path.join(out_dir, f"{name}.csv")
    df.to_csv(path, index=False)

print("CSV files and PNG plots saved to:", out_dir)
print("Files:")
for fn in sorted(os.listdir(out_dir)):
    print(fn)
