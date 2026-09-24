# 🌍 Indian Urban Air Quality Analysis

![Python](https://img.shields.io/badge/Python-Data%20Analysis-blue)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Cleaning-purple)
![SQL](https://img.shields.io/badge/SQL-Analysis-orange)
![Statistics](https://img.shields.io/badge/Statistics-Analysis-green)
![Data Analytics](https://img.shields.io/badge/Data%20Analytics-Portfolio-yellow)
![Status](https://img.shields.io/badge/Project-Completed-success)

> A data analyst portfolio project analysing 10,000 AQI observations across
> 24 Indian cities using Python and SQL to evaluate air-quality distributions,
> pollutant relationships, city-level patterns, environmental factors,
> data quality, and statistical validity.

---

# 📊 Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Observations | **10,000** |
| Cities | **24** |
| Mean AQI | **273.7** |
| Median AQI | **273** |
| Minimum AQI | **50** |
| Maximum AQI | **499** |
| Poor or Worse | **66.9%** |
| Severe AQI | **21.6%** |
| Good AQI | **0.1%** |
| Strongest AQI Correlation | **CO, r = 0.018** |
| Significant Variables | **0 of 13** |
| Health Impact Score Values | **1** |

---

# 📈 Key Findings

## 🌍 Overall AQI Analysis

| AQI Category | Observations | Share |
|---|---:|---:|
| Good | **10** | **0.10%** |
| Satisfactory | **1,134** | **11.34%** |
| Moderate | **2,162** | **21.62%** |
| Poor | **2,312** | **23.12%** |
| Very Poor | **2,222** | **22.22%** |
| Severe | **2,160** | **21.60%** |

Overall, **66.9% of observations fall into the Poor, Very Poor,
or Severe categories**, while only **10 observations (0.1%)** are
classified as Good.

> **Important:** The analysis found that the AQI distribution is unusually
> flat. Therefore, these category shares should not be interpreted as a
> real-world pollution profile of Indian cities.

---

## 🏙️ City-Level AQI Analysis

| City | Average AQI |
|---|---:|
| Ahmedabad | **288.8** |
| Kolkata | **283.7** |
| Thane | **283.4** |
| Jaipur | **281.6** |
| Vadodara | **279.8** |
| ... | ... |
| Ludhiana | **263.8** |

Ahmedabad has the highest observed mean AQI at **288.8**, while
Ludhiana has the lowest at **263.8**.

The difference between the highest and lowest city means is approximately
**25 AQI points**.

However, statistical testing found **no significant city effect**
(ANOVA p = 0.405). Therefore, the observed city ranking should not
be interpreted as evidence that one city is genuinely more polluted
than another in this dataset.

---

## 🧪 Pollutant Analysis

The dataset contains six major pollutant variables:

| Pollutant | Mean |
|---|---:|
| PM2.5 | **130.41** |
| PM10 | **161.00** |
| NO2 | **42.45** |
| CO | **5.05** |
| SO2 | **26.19** |
| O3 | **52.49** |

Correlation analysis was performed between AQI and the available
pollutant variables.

The strongest observed correlation was:

```text
AQI ↔ CO
Correlation = 0.018
