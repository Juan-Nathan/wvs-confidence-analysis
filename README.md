# 🌍 Analysis of Confidence in Social Organizations

This project analyzes World Values Survey (WVS) Wave 7 data in R to investigate how individual characteristics across countries predict **confidence in social institutions**. The analysis focuses on **Romania** and compares its patterns with all other countries combined and with a cluster of socio-economically similar nations.

## Dataset

- `WVSExtract.csv`
- **Source**: [WVS](https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp)
- **Personal Subset** (randomly sampled with seed = 33270961):
  - **Observations**: 50,000
  - **Features**: 30 variables, including country, demographic attributes, and belief-based factors  
  - **Targets**: 10 institutional confidence measures 

## Technologies Used

- **Language**: R
- **IDE**: RStudio
- **Packages**: `dplyr`, `ggplot2`

## Objectives

The main goals of this analysis are to:

1. Perform **descriptive analysis** of the data and understand its structure.
2. Compare **participant responses** between Romania and all other countries combined.
3. Identify how well **participant attributes** predict confidence in social organizations.
4. **Cluster** countries using external socio-economic indicators to find those **similar to Romania** and assess how predictors of confidence compare within that group.

## Institutions Studied

The following institutions were analyzed, identified by columns in the dataset prefixed with "`C`":

- Religious institutions
- Governments
- Elections
- Police
- Trade unions
- Courts
- Banks
- Major companies
- Environmental organizations
- Universities

## Project Workflow

### 1. Descriptive Analysis  
- Examined dataset dimensions, variable types, value ranges, missing data, and invalid responses.

### 2. Preprocessing
- Replaced invalid values with `NA` to ensure accurate analysis.

### 3. Focus Country (Romania) vs. All Others  
- Compared Romania's participant responses against all other countries combined.
- Fitted separate linear regression models for Romania and the pooled group of other countries to predict confidence in institutions using participant attributes.
- Identified the most significant predictors of confidence in institutions.

### 4. Focus Country vs. Cluster of Similar Countries  
- Clustered countries using hierarchical clustering (Euclidean distance, Ward.D2 linkage) based on 11 external indicators:
  - CO₂ emissions
  - Democracy index
  - LGBT equality index
  - Fertility rate
  - GDP per capita
  - Healthcare expenditure
  - Internet usage
  - Life expectancy
  - Religious composition
  - Average years of schooling
  - Unemployment rate
- Fitted linear regression models for the group of countries clustered with Romania (excluding Romania itself).
- Evaluated how well participant attributes within the cluster predicted confidence in social institutions.
- Compared model performance and predictor patterns across Romania, the cluster of similar countries, and the pooled group of other countries.

## Key Findings

### Romania-Specific Findings
- Confidence in **religious institutions**, **governments**, and **elections** was best predicted by the participant attributes.
- These models had the **highest adjusted R²**, indicating stronger fit and explanatory power.

### Strong and Consistent Predictors
- `VPolitics` (political interest), `VReligion` (religiosity), and `TNeighbourhood` (trust in neighbors) were the most significant predictors across Romania, its peer cluster, and the pooled group of other countries. Each showed a **positive** effect on confidence in social organizations.

### Effectiveness of Clustering
- Regression models fitted to Romania produced performance and predictor patterns that **more closely matched** its peer group than those of all other countries combined. 
- This confirms that the clustering approach was **effective**, enhancing the relevance and interpretability of the analysis by grouping countries with similar socio-economic and cultural contexts.

## How to Run

1. Clone the repository or download the ZIP file from GitHub.
2. Open the project folder in RStudio.
3. Run the R script (`wvs_confidence_analysis.r`) inside the RStudio environment.

## Author

Developed by Juan Nathan.




