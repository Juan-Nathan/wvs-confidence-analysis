# ====================================================
# Setup: Clear Environment, Load Data, Sample & Subset
# ====================================================
rm(list = ls())
set.seed(33270961)

# Load full WVS dataset
VCData = read.csv("WVSExtract.csv")

# Sample 50,000 participants without replacement
VC = VCData[sample(1:nrow(VCData), 50000, replace = FALSE), ]

# Create personal reduced dataset
VC = VC[, c(
  1:6,
  sort(sample(7:46, 17, replace = FALSE)),
  47:53,
  sort(sample(54:69, 10, replace = FALSE))
)]

# ====================================================
# Descriptive Analysis of Dataset
# ====================================================

# --- Dataset dimensions and structure ---
cat("Dataset dimensions (rows, columns):\n")
print(dim(VC))  # Number of rows and columns

cat("\nStructure of the dataset:\n")
str(VC)  # Data types and structure

# --- Count of numerical and non-numerical variables ---
num_vars <- names(VC)[sapply(VC, is.numeric)]
non_num_vars <- names(VC)[sapply(VC, is.character)]

cat("\nNumber of numerical variables:", length(num_vars), "\n")
cat("Number of non-numerical variables:", length(non_num_vars), "\n")

# --- Top 10 most frequent countries ---
cat("\nTop 10 most frequent countries:\n")
country_counts <- sort(table(VC$Country), decreasing = TRUE)
print(head(country_counts, 10))

# --- Columns with standard missing values (NA) ---
cat("\nColumns with standard missing values (NA):\n")
missing_summary <- colSums(is.na(VC))
print(missing_summary[missing_summary > 0])

# --- Count of negative values per numeric column ---
cat("\nCount of negative values in each numeric column:\n")
negative_counts <- sapply(VC[num_vars], function(x) sum(x < 0, na.rm = TRUE))
negative_counts <- negative_counts[negative_counts > 0]
negative_counts <- sort(negative_counts, decreasing = TRUE)
print(negative_counts)

# --- Summary statistics after replacing invalid values (< 0) with NA ---
VC_clean <- VC
num_vars_clean <- names(VC_clean)[sapply(VC_clean, is.numeric)]
VC_clean[num_vars_clean] <- lapply(VC_clean[num_vars_clean], function(x) ifelse(x < 0, NA, x))

cat("\nSummary statistics (excluding non-substantive negative values):\n")
print(summary(VC_clean[num_vars_clean]))

# ====================================================
# Compare Romania vs Other Countries
# ====================================================

# --- Subset data into Romania and others ---
romania <- VC[VC$Country == "ROU", ]
others  <- VC[VC$Country != "ROU", ]

# --- Replace invalid negative values with NA ---
num_vars <- names(VC)[sapply(VC, is.numeric)]
romania[num_vars] <- lapply(romania[num_vars], function(x) ifelse(x < 0, NA, x))
others[num_vars]  <- lapply(others[num_vars],  function(x) ifelse(x < 0, NA, x))

# --- Compute mean of numeric variables for Romania and others ---
romania_means <- sapply(romania[num_vars], function(x) mean(x, na.rm = TRUE))
others_means  <- sapply(others[num_vars],  function(x) mean(x, na.rm = TRUE))

# --- Combine into comparison dataframe ---
comparison <- data.frame(
  Variable = num_vars,
  Romania_Mean = romania_means,
  Others_Mean = others_means,
  Difference = romania_means - others_means
)

# --- Sort by largest absolute mean differences ---
comparison_sorted <- comparison[order(abs(comparison$Difference), decreasing = TRUE), ]

# --- View top 15 differing attributes ---
head(comparison_sorted, 15)

# --- Visualize top 15 differences with a bar chart ---
library(ggplot2)

top_diff <- head(comparison_sorted, 15)

ggplot(top_diff, aes(x = reorder(Variable, Difference), y = Difference)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Top Differences Between Romania and Other Countries",
    subtitle = "Positive = Higher mean in Romania, Negative = Lower mean in Romania",
    x = "Variable",
    y = "Mean Difference (Romania - Others)"
  ) +
  theme_minimal(base_size = 12)

# ====================================================
# Regression Models – Romania Only
# ====================================================

# --- Clean Romania data ---
romania <- VC[VC$Country == "ROU", ]
romania[sapply(romania, is.numeric)] <- lapply(romania[sapply(romania, is.numeric)], 
                                               function(x) ifelse(x < 0, NA, x))

# --- Identify target and predictor variables ---
target_vars <- setdiff(grep("^C", names(romania), value = TRUE), "Country")
predictors <- setdiff(names(romania), c("Country", target_vars))

# --- Fit and summarize linear models for each target variable ---
for (target in target_vars) {
  cat("\n===============================\n")
  cat("Linear model summary for:", target, "\n")
  cat("===============================\n")
  
  formula <- as.formula(paste(target, "~", paste(predictors, collapse = "+")))
  model_data <- romania[, c(target, predictors)]
  model_data <- model_data[complete.cases(model_data), ]
  cat(nrow(model_data))
  model <- lm(formula, data = model_data)
  print(summary(model))
}

# --- Adjusted R² summary plot for Romania models ---
model_results <- data.frame(
  Institution = c("CReligious", "CGovernment", "CElections", "CPolice", "CUnions", "CCourts",
                  "CBanks", "CMajCompanies", "CEnvOrg", "CUniversities"),
  Adjusted_R2 = c(0.3387, 0.2838, 0.2216, 0.2057, 0.1572, 0.1533,
                  0.1559, 0.07525, 0.08471, 0.1143)
)

ggplot(model_results, aes(x = reorder(Institution, Adjusted_R2), y = Adjusted_R2)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Adjusted R² for Predicting Confidence in Social Institutions (Romania)",
       x = "Social Institution",
       y = "Adjusted R²") +
  theme_minimal()

# ====================================================
# Regression Models – All Other Countries
# ====================================================

# --- Clean data for non-Romania subset ---
others <- VC[VC$Country != "ROU", ]
others[sapply(others, is.numeric)] <- lapply(others[sapply(others, is.numeric)],
                                             function(x) ifelse(x < 0, NA, x))

# --- Identify target and predictor variables ---
target_vars <- setdiff(grep("^C", names(others), value = TRUE), "Country")
predictors <- setdiff(names(others), c("Country", target_vars))

# --- Fit and summarize models for other countries ---
for (target in target_vars) {
  cat("\n===============================\n")
  cat("Linear model summary for:", target, "\n")
  cat("===============================\n")
  
  formula <- as.formula(paste(target, "~", paste(predictors, collapse = "+")))
  model_data <- others[, c(target, predictors)]
  model_data <- model_data[complete.cases(model_data), ]
  cat(nrow(model_data), "complete cases\n")
  model <- lm(formula, data = model_data)
  print(summary(model))
}

# ====================================================
# Clustering Countries Similar to Romania
# ====================================================

# --- Load external indicators from multiple CSVs ---
library(dplyr)
CO2 <- read.csv("co2.csv")
Democracy <- read.csv("democracy.csv")
LGBT_Equality <- read.csv("equality.csv")
Fertility <- read.csv("fertility.csv")
GDP <- read.csv("gdp_per_capita.csv")
Healthcare <- read.csv("healthcare.csv")
Internet <- read.csv("internet.csv")
Life_Expectancy <- read.csv("life_expectancy.csv")
Religion <- read.csv("religion.csv")
Schooling <- read.csv("schooling.csv")
Unemployment <- read.csv("unemployment.csv")

# --- Merge all indicators into one dataset ---
Data <- CO2 %>%
  inner_join(Democracy, by = "Entity") %>%
  inner_join(LGBT_Equality, by = "Entity") %>%
  inner_join(Fertility, by = "Entity") %>%
  inner_join(GDP, by = "Entity") %>%
  inner_join(Healthcare, by = "Entity") %>%
  inner_join(Internet, by = "Entity") %>%
  inner_join(Life_Expectancy, by = "Entity") %>%
  inner_join(Religion, by = "Entity") %>%
  inner_join(Schooling, by = "Entity") %>%
  inner_join(Unemployment, by = "Entity")

# --- Standardize numeric data for clustering ---
data_scaled <- scale(Data[, -1])
rownames(data_scaled) <- Data$Entity

# --- Compute distance matrix and perform clustering (Ward’s) ---
dist_matrix <- dist(data_scaled)
hc <- hclust(dist_matrix, method = "ward.D2")

# --- Plot dendrogram and extract 18 clusters ---
plot(hc, 
     main = "Hierarchical Clustering of Countries", 
     xlab = "", 
     sub = "", 
     cex = 0.7, 
     hang = -1)
abline(h = 6, col = "red", lty = 2, lwd = 2)
rect.hclust(hc, k = 18, border = "red")

clusters <- cutree(hc, k = 18)
clustered_countries <- data.frame(Country = rownames(data_scaled), Cluster = clusters)
head(clustered_countries)

# --- Identify Romania’s cluster and filter countries in the same cluster ---
romania_cluster <- clustered_countries$Cluster[clustered_countries$Country == "Romania"]
same_cluster <- clustered_countries[clustered_countries$Cluster == romania_cluster, ]
same_cluster

# ====================================================
# Regression Models – Countries Similar to Romania
# ====================================================

# --- Define countries in Romania's cluster ---
cluster_countries <- c("ARG", "ARM", "BRA", "BGR", "CHL", "COL",
                       "CRI", "HRV", "CYP", "GRC", "HUN", "ITA",
                       "LTU", "PAN", "POL", "PRT", "RUS", "SRB",
                       "SVK", "SVN", "ESP")

# --- Filter WVS data for these countries only ---
cluster_data <- VC[VC$Country %in% cluster_countries, ]

# --- Replace negative values with NA ---
cluster_data[sapply(cluster_data, is.numeric)] <- lapply(
  cluster_data[sapply(cluster_data, is.numeric)],
  function(x) ifelse(x < 0, NA, x)
)

# --- Identify target and predictor variables ---
target_vars <- setdiff(grep("^C", names(cluster_data), value = TRUE), "Country")
predictors <- setdiff(names(cluster_data), c("Country", target_vars))

# --- Fit models for each confidence target variable in the cluster ---
for (target in target_vars) {
  cat("\n===============================\n")
  cat("Linear model summary for:", target, "\n")
  cat("===============================\n")
  
  formula <- as.formula(paste(target, "~", paste(predictors, collapse = "+")))
  model_data <- cluster_data[, c(target, predictors)]
  model_data <- model_data[complete.cases(model_data), ]
  cat(nrow(model_data), "complete cases\n")  
  model <- lm(formula, data = model_data)
  print(summary(model))
}

