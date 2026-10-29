# College Student Mental Health: Pre- and Post-COVID-19 Analysis

## Project Overview

This project examines mental health among college students, with an emphasis on depression, anxiety, and differences across demographic and academic groups. Using data from the Healthy Minds Study (HMS), we investigate how student mental health differed before and after the COVID-19 pandemic and whether factors such as gender and STEM enrollment are associated with mental health outcomes.

The project builds upon an existing research analysis of college student mental health. We first reproduce key components of the original study, then extend the analysis through descriptive statistics, hypothesis testing, regression, and predictive modeling.

Our primary mental health outcomes are:

- **PHQ:** Patient Health Questionnaire depression scores.
- **GAD:** Generalized Anxiety Disorder anxiety scores.

The repository contains the data and R Markdown files necessary to reproduce our analyses.

## Repository Structure

```text
college-student-mental-health/
│
├── README.md
├── Run Project.Rmd
├── college-student-mental-health.Rproj
├── .gitignore
│
├── code/
│   ├── 01 - Parent Paper Recreation.Rmd
│   ├── 02 - Descriptive Analysis.Rmd
│   ├── 03 - Hypothesis Tests and Regression.Rmd
│   ├── 04 - Predictive Modeling.Rmd
│   └── original_parent_paper_analysis.R
│
└── data/
    ├── raw/
    │   └── original_data.csv
    ├── processed/
    │   ├── pre_covid_clean.csv
    │   └── post_covid_clean.csv
    └── split/
        ├── training_data.csv
        ├── test_data.csv
        └── validation_data.csv
```

## Code Files

### Run Project.Rmd — Main Project File

This is the primary entry point for reproducing the project.

The file checks for required datasets and scripts, installs missing R packages, and runs Scripts 02–04 in sequence. These scripts generate HTML reports containing the descriptive analyses, statistical tests, regression results, and predictive modeling outputs.

**Start here if you want to reproduce the main project analyses.**

### 01 - Parent Paper Recreation.Rmd

Reproduces analyses from the original research paper to establish a foundation for our project.

Includes demographic summaries, depression and anxiety regressions, gender and STEM comparisons, statistical tests, and recreated figures.

This script is retained for methodological reference and is not automatically executed by `Run Project.Rmd`.

The corresponding original analysis code is preserved in `original_parent_paper_analysis.R`.

### 02 - Descriptive Analysis.Rmd

Explores the pre- and post-COVID-19 datasets through descriptive statistics and visualizations.

Includes sample characteristics, missing-value assessments, depression and anxiety distributions, demographic comparisons, gender and STEM subgroup summaries, and correlations between mental health outcomes.

### 03 - Hypothesis Tests and Regression.Rmd

Investigates statistical differences in mental health outcomes across survey periods and student characteristics.

Includes pre/post-COVID comparisons, subgroup hypothesis tests, adjusted regression models, interaction effects, and regression diagnostics.

These analyses assess associations and differences between groups; they do not establish that the pandemic caused changes in mental health.

### 04 - Predictive Modeling.Rmd

Evaluates statistical and machine learning models for predicting depression and anxiety scores.

Includes baseline models, multiple linear regression, ridge regression, LASSO, regression trees, random forests, and XGBoost.

Models are evaluated using training, testing, and validation datasets, with performance comparisons based on metrics such as RMSE, MAE, and R².

## Data Directory

### `data/raw/`

Contains `original_data.csv`, the original post-COVID-19 dataset used in the project.

### `data/processed/`

Contains the cleaned datasets used for comparisons:

- `pre_covid_clean.csv` — Cleaned pre-COVID-19 HMS data from the 2017–2018 survey period.
- `post_covid_clean.csv` — Cleaned post-COVID-19 HMS data from the 2022–2023 survey period.

The raw pre-COVID-19 dataset is not included in this repository due to size restrictions. This can be shared via Google Drive upon request; please email kmm8841@psu.edu. Consequently, the pre-COVID-19 cleaning process cannot be fully reproduced from raw data using the repository alone. The processed dataset is provided for downstream analysis.

### `data/split/`

Contains the training, testing, and validation datasets used in predictive modeling.

These files allow the modeling analysis to use the same predefined data partitions across runs.

## How to Reproduce the Analysis

### Step 1: Download the Repository

Clone the repository using Git:

```bash
git clone https://github.com/kmillerpsu/college-student-mental-health.git
```

Alternatively, select **Code → Download ZIP** on GitHub and extract the downloaded folder.

### Step 2: Open the RStudio Project

Install R and RStudio if they are not already available.

Open `college-student-mental-health.Rproj` in RStudio. This helps ensure that the project is opened from the correct directory.

### Step 3: Run the Main Project

Open `Run Project.Rmd` and click **Knit**.

The file is designed to:

1. Check for missing R packages and install them.
2. Verify that the necessary scripts and datasets exist.
3. Execute the descriptive analysis, hypothesis-testing and regression, and predictive-modeling scripts.
4. Generate HTML reports containing the analysis results.

An internet connection may be required for the initial package installation.

### Step 4: View the Results

Review the generated HTML reports in `outputs/reports/`.

The reports contain the statistical summaries, visualizations, model results, and performance comparisons produced by the scripts.

### Running Individual Analyses

Each numbered R Markdown file can also be opened and knitted independently.

This is useful when examining one portion of the analysis without rerunning the entire project.

## Research Workflow

The project follows four stages:

1. **Replication:** Reproduce key findings and methods from the original research.
2. **Exploratory Analysis:** Examine the distributions and characteristics of students in the pre- and post-COVID-19 datasets.
3. **Statistical Inference:** Test differences in mental health outcomes and estimate adjusted associations with demographic and academic factors.
4. **Predictive Modeling:** Compare statistical and machine learning approaches for predicting depression and anxiety scores.

## Reproducibility Notes

- The analyses are written in R and R Markdown.
- Scripts use relative file paths based on the repository structure.
- Missing packages are installed through the main project file.
- Predictive modeling uses predefined training, testing, and validation datasets.
- Some machine learning results may vary slightly depending on package versions and computational environments.
- The original parent-paper analysis is retained separately from the main project workflow.
- Generated HTML reports can be recreated by knitting the corresponding R Markdown files.

## Interpretation and Limitations

The analyses use observational survey data. Differences between the pre- and post-COVID-19 samples should not automatically be interpreted as causal effects of the pandemic.

Differences in sample composition, survey participation, and other unmeasured factors may influence the observed relationships.

Predictive-model performance describes how well models estimate mental health scores in the evaluated datasets; it does not establish causal relationships between predictors and outcomes.

## Project Status

The repository contains the organized analysis scripts and an initial reproducible project workflow. The final research paper and the selection of results presented in the main project report may be refined as the project develops.
