# 🌍 World Values Survey: Confidence in Social Organisations

This project investigates how individual characteristics influence **confidence in social institutions** across countries, using data from the **World Values Survey (WVS) Wave 7**. The analysis focuses on **Romania** and compares its patterns with other countries globally and with a **cluster of socio-economically similar nations**.

## 🎯 Objectives

The main goals of this analysis are to:

1. Perform descriptive analysis of WVS data and understand its structure.
2. Compare participant attributes between **Romania** and all other countries.
3. Identify how well participant responses predict **confidence in societal institutions**.
4. Cluster countries using external socio-economic indicators to find those **similar to Romania** and assess how confidence predictors compare within that group.

## 🌐 Dataset

- **Source**: [World Values Survey (WVS)](https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp)
- **Subset**: Sampled 50,000 participants using a random seed.
- **Attributes**: Includes demographic, belief-based, and institutional confidence variables.

## 📊 Institutions Studied

The following institutions were analyzed, identified by columns in the dataset prefixed with `"C"`:

- Government
- Courts
- Elections
- Universities
- Environmental Organisations
- Major Companies
- Banks
- Police
- Religious Institutions
- Trade Unions

## 🛠 Tools & Methods

- **Language**: R  
- **Libraries**: `dplyr`, `ggplot2`
- **Techniques**:
  - Data cleaning and preprocessing
  - Descriptive statistics
  - Linear regression modeling
  - Hierarchical clustering (Ward's method)
  - Country-level comparisons using mean values and Adjusted R²

## 🧪 Questions Addressed

### 1. Descriptive Analysis  
- Examined dataset dimensions, variable types, distributions, missing values, and invalid codes.

### 2. Focus Country (Romania) vs. All Others  
- Compared Romania's participant attributes against the other countries.
- Fitted linear models to predict confidence in institutions using predictor attributes.
- Identified top predictors and their strength (using Adjusted R²).

### 3. Focus Country vs. Cluster of Similar Countries  
- Clustered countries using 11 external indicators:
  - GDP per capita
  - Fertility rate
  - CO₂ emissions
  - Democracy index
  - Healthcare expenditure
  - Internet usage
  - Life expectancy
  - LGBT equality index
  - Religious composition
  - Average years of schooling
  - Unemployment rate
- Evaluated how well participant attributes within the cluster predicted confidence in social institutions.
- Compared predictor patterns between the cluster and Romania, and between the cluster and all other countries.

## 📈 Key Findings

### Romania-specific findings:
- Confidence in religious institutions, government, and elections was best predicted by individual characteristics.
- These models had the highest adjusted R², indicating stronger fit and explanatory power.

### Strong and consistent predictors across analyses:
- VPolitics (political interest), VReligion (religiosity), and TNeighbourhood (trust in neighbors) were the most reliable predictors across Romania, its peer cluster, and the global group.

### Effectiveness of clustering:
- Regression models fitted to Romania's peer group (based on external indicators) produced predictor patterns that closely matched those in Romania, more so than models based on all other countries.
- This confirms that the clustering approach was effective, improving the relevance and interpretability of the analysis by grouping countries with similar socio-economic and cultural contexts.

## 👤 Author

Developed by Juan Nathan.
