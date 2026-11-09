# College Student Mental Health: Pre- and Post-COVID-19 Analysis

**Authors:** Caylee Collins and Kate Miller  
**Project:** Penn State DS 340W

## What is this project?

We used data from the Healthy Minds Study to look at depression and anxiety among undergraduate students. We compared the 2017–2018 and 2022–2023 survey periods, examined differences by gender and STEM enrollment, and built models to predict PHQ (depression) and GAD (anxiety) scores.

This project builds on a published study of STEM students and mental health. We recreated parts of that earlier analysis, added the 2017–2018 data, and compared several predictive models using the 2022–2023 data.

**You do not need to know R to follow these instructions.** The main file is `Run Project.Rmd`. Choose the option that fits you:

- **Quick start:** Already have R, RStudio, and Git installed? Clone the repository, open the RStudio project, and knit the master RMD.
- **Option A (recommended for beginners):** Install R and RStudio, download the repository as a ZIP, and follow every setup step.
- **Option B:** Use Posit Cloud to run RStudio in your browser, without installing R locally. The free tier may not have enough memory for the complete analysis.

> **Important:** GitHub stores the files; GitHub itself does not run the R Markdown code. You need RStudio on your computer or an online R environment such as Posit Cloud. You also need an internet connection the first time packages are installed.

## Table of contents

Click a link below to jump to that part of this README.

- [Quick start: I already use RStudio](#quick-start-already-have-rstudio)
- [Before you start: Check the files](#before-you-start-check-the-files)
- [Option A: Set up on a new computer](#option-a-run-everything-on-a-new-computer-recommended)
  - [Step 1: Install R](#step-1-install-r)
  - [Step 2: Install RStudio](#step-2-install-rstudio-desktop)
  - [Step 3: Download the repository](#step-3-download-the-github-repository)
  - [Step 4: Open the project](#step-4-open-the-project-in-rstudio)
  - [Step 5: Check the working folder](#step-5-check-that-rstudio-is-in-the-right-folder)
  - [Step 6: Run the analysis](#step-6-run-the-full-analysis)
  - [Step 7: Find the results](#step-7-find-the-results)
- [Option B: Run online using Posit Cloud](#option-b-run-the-project-online-using-posit-cloud)
- [Troubleshooting](#if-something-goes-wrong)
- [What each file does](#what-each-file-does)
- [Data availability and reproducibility](#data-availability-and-what-can-be-reproduced)
- [Repository structure](#repository-structure)

---

## Quick start: Already have RStudio

**Use this section if you already have R, RStudio Desktop, and Git set up on your computer and are comfortable working in RStudio.** If you have RStudio but do not have Git installed, follow [Option A](#option-a-run-everything-on-a-new-computer-recommended) to download the repository as a ZIP instead.

1. **Clone the GitHub repository.** Open a terminal (or RStudio's **Terminal** tab), move to the folder where you want to keep the project, and run:

   ```bash
   git clone https://github.com/kmillerpsu/college-student-mental-health.git
   ```

   Alternatively, in RStudio select **File → New Project → Version Control → Git**, paste the same repository URL, choose a location, and click **Create Project**. This menu option requires Git to be installed and configured on your computer.

2. **Open the project.** If it did not open automatically, open `college-student-mental-health/college-student-mental-health.Rproj` in RStudio.
3. **Check the files.** Confirm that `Run Project.Rmd` is in the project root, scripts 02–04 are in `code/`, and the CSV files are in `data/processed/` and `data/split/`. You can test the training file by running `file.exists("data/split/training_data.csv")` in the Console; it should return `TRUE`.
4. **Run the report.** Open `Run Project.Rmd` and click **Knit → Knit to HTML**. The master file checks for missing packages, installs them as needed, and runs the three analysis scripts. An internet connection is needed if packages must be installed.
5. **Find your results.** Open the resulting HTML report, usually next to `Run Project.Rmd`. The CSV tables and figure images are saved under `outputs/paper_only/tables/` and `outputs/paper_only/figures/`.

**That's it.** You do not need to knit Scripts 02, 03, and 04 separately. If something fails, jump to [Troubleshooting](#if-something-goes-wrong). For a slower walkthrough, see [Option A](#option-a-run-everything-on-a-new-computer-recommended).

---

## Before you start: Check the files

You should be able to find these items in the repository:

- `Run Project.Rmd` — the main file to run
- `college-student-mental-health.Rproj` — opens the project with the correct working folder
- `code/02 - Descriptive Analysis.Rmd`
- `code/03 - Hypothesis Tests and Regression.Rmd`
- `code/04 - Predictive Modeling.Rmd`
- `data/processed/pre_covid_clean.csv`
- `data/processed/post_covid_clean.csv`
- `data/split/training_data.csv`
- `data/split/test_data.csv`
- `data/split/validation_data.csv`

**Keep the file and folder names exactly as shown.** In particular, the three numbered RMD files need to stay inside `code/`, and the CSV files need to stay in their respective `data/` subfolders. Do not rename them or move them next to the master file.

If any of these files is missing from the downloaded repository, the analysis cannot run until that file is provided. The code cannot generate the missing cleaned or split datasets by itself.

---

## Option A: Run everything on a new computer (recommended)

### Step 1: Install R

1. Open a web browser (Chrome, Edge, Safari, etc.).
2. Go to **https://cran.r-project.org/**.
3. Select your operating system: **Windows**, **macOS**, or **Linux**.
4. Follow the download link for the current R version.
5. Download the installer and open it.
6. Follow the installation prompts. The default settings are fine for most users.
7. Finish the installation. You do **not** need to open the separate R application.

### Step 2: Install RStudio Desktop

1. Go to **https://posit.co/download/rstudio-desktop/**.
2. Download the free RStudio Desktop version for your operating system.
3. Open the installer and follow the prompts.
4. Open **RStudio** after installation. It should find the R installation automatically.
5. If RStudio says it cannot find R, close RStudio, make sure Step 1 completed successfully, and reopen it.

**R and RStudio are two different programs. Install R first, then RStudio.**

### Step 3: Download the GitHub repository

**No Git installation is required for the ZIP method.**

1. Open **https://github.com/kmillerpsu/college-student-mental-health**.
2. Near the top of the file list, click the green **Code** button.
3. Click **Download ZIP**.
4. Find the ZIP file in your computer's **Downloads** folder.
5. Extract it before trying to run the project:
   - **Windows:** Right-click the ZIP and select **Extract All**, then **Extract**.
   - **Mac:** Double-click the ZIP to extract it.
6. Open the extracted folder. You should see `Run Project.Rmd`, `code`, `data`, and the `.Rproj` file together.
7. Move the extracted project folder somewhere easy to find, such as **Documents**. You can rename the outer folder, but **do not rename the files or inner folders**.

**Do not run the RMD directly from inside the unopened ZIP file.**

### Step 4: Open the project in RStudio

1. Inside the extracted folder, find `college-student-mental-health.Rproj`.
2. Double-click it. RStudio should open the entire project.
3. In RStudio, look at the **Files** tab, usually in the lower-right pane.
4. Confirm you can see `Run Project.Rmd`, `code`, and `data` in the file list.
5. Click `Run Project.Rmd` in the **Files** tab to open it in the editor.
6. Make sure you opened the **main** `Run Project.Rmd`, not one of the numbered scripts in the `code` folder.

If double-clicking the `.Rproj` file does not work, open RStudio and select **File → Open Project**, then browse to the `.Rproj` file.

### Step 5: Check that RStudio is in the right folder

1. Find the **Console** pane in RStudio.
2. Copy the following command, paste it into the Console, and press **Enter**:

```r
getwd()
```

3. RStudio should print the path to your downloaded project folder.
4. Now paste this command and press **Enter**:

```r
file.exists("data/split/training_data.csv")
```

5. The result should be `TRUE`. If it is `FALSE`, go back to Step 4 and open the `.Rproj` file from the correct extracted folder. Also check that the CSV is inside `data/split/`.

### Step 6: Run the full analysis

1. Make sure `Run Project.Rmd` is open in the editor.
2. Click the **Knit** button near the top of the editor (look for a small yarn-ball icon).
3. If RStudio asks which output format to use, choose **Knit to HTML**.
4. Allow the file to run. **The first run can take longer** because it checks for missing packages and installs them automatically from CRAN.
5. If a dialog asks you to choose a CRAN download mirror, choose a nearby mirror or the cloud mirror; the script normally sets this automatically.
6. Do not close RStudio while the file is running. Some models, especially random forest and XGBoost, can take additional processing time.
7. When knitting succeeds, an HTML report called something like `Run Project.html` should open in RStudio's viewer or a browser window.
8. Scroll through the report. It is designed to show the **six tables and five figures included in the final paper**, rather than all the intermediate output from the individual scripts.

**What the master file does automatically:**

1. Checks for the R packages it needs and installs any missing ones.
2. Checks that the three analysis RMDs and the five cleaned/split CSV files exist.
3. Runs scripts 02, 03, and 04 separately (so duplicate chunk names such as `setup` do not interfere).
4. Creates the paper's tables and figures using the results from those scripts.
5. Builds one readable HTML report.

**No need to click Run on every chunk or manually run the three numbered scripts first.**

### Step 7: Find the results

1. In RStudio, open the **Files** pane.
2. Find the newly created HTML file, usually next to `Run Project.Rmd` in the main project folder. Its name depends on the master RMD filename.
3. Click the HTML file to view it. You can also open it with a web browser.
4. Open the `outputs` folder, then open `paper_only`.
5. Inside `outputs/paper_only/`, look for:
   - `tables/` — CSV copies of the six paper tables (plus any necessary intermediate table exports).
   - `figures/` — image files for the five paper figures.
6. The HTML report uses formatted tables (including `knitr::kable`) and figures. The CSV files are included so the underlying numbers can also be checked.

**Note:** The main project does **not** promise a folder named `outputs/reports/`. Look for the HTML report next to the master RMD and the exported files under `outputs/paper_only/`.

---

## Option B: Run the project online using Posit Cloud

Posit Cloud gives you an RStudio workspace in a web browser. You do not need to install R or RStudio on your computer for this option.

### Step 1: Create an account

1. Go to **https://posit.cloud/**.
2. Select **Sign Up** to create an account, or **Log In** if you already have one.
3. Follow the account setup steps shown on the website.
4. After signing in, go to **Your Workspace** (the personal workspace in the sidebar).

### Step 2: Import the GitHub project

1. In Your Workspace, find **New Project**.
2. Open its menu or drop-down arrow and choose **New Project from Git Repository**. The exact menu wording may vary slightly.
3. Copy this repository address:

```text
https://github.com/kmillerpsu/college-student-mental-health.git
```

4. Paste that address into the box asking for the Git repository URL.
5. Confirm or click **OK/Create Project**.
6. Posit Cloud will copy the repository files into a new online RStudio project.
7. When the RStudio interface opens, use the **Files** tab to check for `Run Project.Rmd`, `code/`, and `data/`.

If the repository is private or you do not have access, the import may require GitHub authorization. The Git repository URL must be an **HTTPS** URL, not an SSH URL.

### Step 3: Check the input files

1. In the RStudio Console inside Posit Cloud, paste:

```r
file.exists("data/split/training_data.csv")
```

2. Press **Enter**.
3. If it prints `TRUE`, the example input file is in the expected location.
4. If it prints `FALSE`, check the `data/split/` folder and make sure you imported the full repository.

### Step 4: Knit the report

1. In the Files pane, click `Run Project.Rmd`.
2. Click **Knit**, then select HTML if prompted.
3. The master file will attempt to install any missing R packages and run the analysis scripts.
4. When the report finishes, open the resulting HTML output.
5. To find the exported tables and figures, open `outputs/paper_only/` in the Files pane.
6. To save a result to your own computer, select the file in the Files pane and use the **More → Export** or **Export** option, if available in your interface.

### Important limitation for Posit Cloud

The Posit Cloud free plan has limited memory and processing resources. Our project uses large survey datasets and machine-learning models, so **the complete run may fail on the free plan even when the code is correct**. If you see an out-of-memory error, a disconnected session, or a resource-limit message, use Option A on a computer with more memory or use a Posit Cloud plan/workspace with more resources. Package installation also requires an internet connection in the online workspace.

The current Posit Cloud plans and limits are listed at **https://posit.cloud/plans**.

---

## If something goes wrong

### “Required project files were not found” or “Cannot find ...csv”

- Make sure the GitHub ZIP was **extracted**.
- Open the project's `.Rproj` file rather than an individual RMD from your Downloads folder.
- Confirm `Run Project.Rmd` is at the top level of the project folder.
- Confirm scripts `02`, `03`, and `04` are inside `code/` with **exactly the expected filenames**.
- Confirm the processed CSVs are in `data/processed/` and the split CSVs are in `data/split/`.

### “There is no package called ...” or package installation fails

- Check your internet connection.
- Close and reopen RStudio, then knit the master RMD again.
- The master file automatically installs missing packages, but some packages need additional system dependencies on certain computers. Follow the full error message if an installer asks for a compiler or build tools.
- In the Console, you can try installing the named package manually if needed, for example:

```r
install.packages("xgboost", repos = "https://cloud.r-project.org")
```

- After installation completes, try **Knit** again.

### “Duplicate chunk label 'setup'”

Use the latest `Run Project.Rmd` from this repository. Its chunks have unique labels, and it runs the numbered scripts separately. If you get this message, verify that you have not mixed an older master RMD with newer scripts or copied two code chunks with the same name into one file.

### The project runs out of memory or takes too long

The modeling scripts use random forests and XGBoost. Close unnecessary programs and try again on a computer with more available memory. If you are using Posit Cloud Free, use a machine or plan with higher resource limits.

### “Knit” fails and I don't understand the error

1. Read the **first error message** in the R Markdown/Render output, not just the last line saying execution halted.
2. Note which file and chunk are named in the error.
3. Confirm you followed Steps 3–5 for the local option, or Steps 2–3 for Posit Cloud.
4. Copy the error message when asking for help, so someone can identify which step failed.

---

## What each file does

- **`Run Project.Rmd`** is the main entry point. It runs Scripts 02–04 and produces the paper-focused report. **Start here.**
- **`code/01 - Parent Paper Recreation.Rmd`** recreates parts of the original study for comparison. It is kept for reference and is **not** run automatically by the main file.
- **`code/original_parent_paper_analysis.R`** preserves the original parent-paper analysis code.
- **`code/02 - Descriptive Analysis.Rmd`** creates descriptive statistics, comparisons, and plots for the two academic years.
- **`code/03 - Hypothesis Tests and Regression.Rmd`** runs the statistical tests, adjusted regressions, and interaction analyses.
- **`code/04 - Predictive Modeling.Rmd`** trains and evaluates the prediction models.
- **`data/processed/`** contains the cleaned 2017–2018 and 2022–2023 datasets used for comparisons.
- **`data/split/`** contains the 2022–2023 training, testing, and validation datasets. The project uses the existing approximately **70% / 20% / 10%** split, with seed **415** used in the modeling workflow.

The main predictive analysis compares baseline prediction, linear regression, gender-by-STEM interaction regression, ridge regression, LASSO regression, a regression tree, random forest, and XGBoost. Model performance is reported using RMSE, MAE, R², and classification accuracy.

## Data availability and what can be reproduced

- `data/raw/original_data.csv` contains the original 2022–2023 data used in the project.
- The **raw 2017–2018 data file is not included** in the repository due to its size. To request it for reproducing that earlier cleaning stage, email **kmm8841@psu.edu**.
- The cleaned 2017–2018 dataset is included under `data/processed/`, so the main comparisons and downstream analyses can run without the raw 2017–2018 file, provided all listed processed and split datasets are present.
- Since the surveys include different respondents in the two periods, results describe differences between independent groups; they do not prove that the pandemic caused those changes.
- Re-running models on another machine may give small differences because of R/package versions and computing environments, even though a fixed seed is used.

## Repository structure

```text
college-student-mental-health/
|
|-- README.md
|-- Run Project.Rmd                  # Start here
|-- college-student-mental-health.Rproj
|-- .gitignore
|
|-- code/
|   |-- 01 - Parent Paper Recreation.Rmd
|   |-- 02 - Descriptive Analysis.Rmd
|   |-- 03 - Hypothesis Tests and Regression.Rmd
|   |-- 04 - Predictive Modeling.Rmd
|   `-- original_parent_paper_analysis.R
|
|-- data/
|   |-- raw/
|   |   `-- original_data.csv
|   |-- processed/
|   |   |-- pre_covid_clean.csv
|   |   `-- post_covid_clean.csv
|   `-- split/
|       |-- training_data.csv
|       |-- test_data.csv
|       `-- validation_data.csv
|
`-- outputs/                          # Generated when analyses run
    `-- paper_only/
        |-- tables/                  # CSV table exports
        `-- figures/                 # Paper figure images
```

**Expected additional output:** Knitting `Run Project.Rmd` creates a main HTML report, usually in the same directory as the master RMD. Generated output files and folders may not appear on GitHub until someone runs the project or commits them.

---

**Quick reminder:** If you only want to reproduce the results in our final paper, open the `.Rproj` file, open `Run Project.Rmd`, and click **Knit**. You do not need to run Scripts 01–04 individually. [Back to the table of contents](#table-of-contents).
