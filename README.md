# College Student Mental Health: Pre- and Post-COVID-19 Analysis

**Authors:** Caylee Collins and Kate Miller\
**Project:** Penn State DS 340W  
**GitHub repository:** [college-student-mental-health](https://github.com/kmillerpsu/college-student-mental-health)

## What is this project?

We used data from the Healthy Minds Study to look at depression and anxiety among undergraduate students. We compared the 2017–2018 and 2022–2023 survey periods, examined differences by gender and STEM enrollment, and built models to predict PHQ (depression) and GAD (anxiety) scores.

This project builds on a published study of STEM students and mental health. We recreated parts of that earlier analysis, added the 2017–2018 data, and compared several predictive models using the 2022–2023 data.

**You do not need to know R to follow these instructions.** The main file is `Run Project.Rmd`. Choose the option that fits you:

- **Quick start:** Already have R, RStudio, and Git installed? Clone the repository, open the RStudio project, and knit the master RMD.
- **Option A (recommended for beginners):** Install R, RStudio, and Git; clone the repository into RStudio or download a ZIP if you only need to run the analysis.
- **Option B:** Use Posit Cloud to run RStudio in your browser, without installing R locally. The free tier may not have enough memory for the complete analysis.

> **Important:** GitHub stores the files; it does not run the R Markdown code. You need RStudio on your computer or an online R environment such as Posit Cloud. An internet connection is needed to download the repository and install R packages. GitHub Desktop is not required; Git is enough.

## Table of contents

Click a link below to jump to that part of this README.

- [Quick start: Already have RStudio](#quick-start-already-have-rstudio)
- [Before you start: Check the files](#before-you-start-check-the-files)
- [Option A: Run everything on a new computer](#option-a-run-everything-on-a-new-computer-recommended)
  - [Step 1: Install R](#step-1-install-r)
  - [Step 2: Install RStudio Desktop](#step-2-install-rstudio-desktop)
  - [Step 2A: Install Rtools on Windows](#step-2a-install-rtools-on-windows)
  - [Step 2B: Install Git](#step-2b-install-git)
  - [Step 3: Download or clone the GitHub repository](#step-3-download-or-clone-the-github-repository)
  - [Step 4: Open the project in RStudio](#step-4-open-the-project-in-rstudio)
  - [Step 5: Check that RStudio is in the right folder](#step-5-check-that-rstudio-is-in-the-right-folder)
  - [Step 6: Run the full analysis](#step-6-run-the-full-analysis)
  - [Step 7: Find the results](#step-7-find-the-results)
- [Option B: Run the project online using Posit Cloud](#option-b-run-the-project-online-using-posit-cloud)
- [Updating the GitHub repository](#updating-the-github-repository)
- [If something goes wrong](#if-something-goes-wrong)
- [What each file does](#what-each-file-does)
- [Data availability and what can be reproduced](#data-availability-and-what-can-be-reproduced)
- [Repository structure](#repository-structure)

---

## Quick start: Already have RStudio

**Use this section if R, RStudio Desktop, and Git are already installed.** If you still need any of them, follow [Option A](#option-a-run-everything-on-a-new-computer-recommended).

1. **Clone the GitHub repository.** Open a terminal (or RStudio's **Terminal** tab), move to the folder where you want to keep the project, and run:
   ```
   git clone https://github.com/kmillerpsu/college-student-mental-health.git
   ```
   Alternatively, in RStudio select **File → New Project → Version Control → Git**, paste the same repository URL, choose a location, and click **Create Project**. This menu option requires Git to be installed and configured on your computer.
2. **Open the project.** If it did not open automatically, open `college-student-mental-health/college-student-mental-health.Rproj` in RStudio.
3. **Check the files.** Confirm that `Run Project.Rmd` is in the project root, scripts 02–04 are in `code/`, and the CSV files are in `data/processed/` and `data/split/`. You can test the training file by running `file.exists("data/split/training_data.csv")` in the Console; it should return `TRUE`.
4. **Run the report.** Open `Run Project.Rmd` and click **Knit → Knit to HTML**. The master file checks for missing packages, installs them as needed, and runs the three analysis scripts. An internet connection is needed if packages must be installed.
5. **Find your results.** Open the resulting HTML report, usually next to `Run Project.Rmd`. The CSV tables and figure images are saved under `outputs/paper_only/tables/` and `outputs/paper_only/figures/`.

You do not need to knit Scripts 02, 03, and 04 separately. If something fails, see [If something goes wrong](#if-something-goes-wrong). For installation instructions, see [Option A](#option-a-run-everything-on-a-new-computer-recommended).

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

Install R before RStudio. Download it from the official [CRAN website](https://cran.r-project.org/).

**Windows (10/11)**

1. Select **Download R for Windows → base → Download R for Windows**.
2. Open the `.exe` installer from Downloads and complete the setup. Default options are generally fine.
3. If you have an ARM-based Windows computer, check CRAN's Windows instructions for your architecture before choosing an installer.

**macOS**

1. Select **Download R for macOS** on CRAN.
2. Check **Apple menu → About This Mac** to see whether the chip is **Apple silicon (M1/M2/M3/M4 or later)** or **Intel**.
3. Download the `.pkg` that matches your processor and supported macOS version, then open it and follow the installer.
4. If macOS blocks the installer, open **System Settings → Privacy & Security** and review the message before proceeding.

**Linux**

1. Select **Download R for Linux** and follow the instructions for your distribution (such as Ubuntu, Debian, Fedora, or openSUSE).
2. Use the commands shown for your distribution. On Ubuntu/Debian with an appropriately configured R repository, the installation command is typically `sudo apt install r-base`.
3. Install any system libraries requested by your package manager. Some R packages need development libraries or compilers.

**Check the installation:** After RStudio is installed in Step 2, open its **Console** and enter `R.version.string`. It should return an R version instead of an error.

### Step 2: Install RStudio Desktop

1. Go to the official [RStudio Desktop download page](https://posit.co/download/rstudio-desktop/).
2. Select the free RStudio Desktop installer for **Windows**, **macOS**, or your **Linux distribution**. For macOS, choose the version appropriate for your machine when the site offers different builds.
3. Run the Windows installer, open the macOS download and move RStudio into **Applications**, or install the appropriate Linux package using your distribution's package installer.
4. Open RStudio. It should detect the R installation from Step 1.
5. If it cannot find R, close RStudio, confirm R installed successfully, and reopen it. On Windows you can also use **Tools → Global Options → General → R version → Change**, if available.

**R and RStudio are separate programs.** R runs the code; RStudio is the application used to work with it.

### Step 2A: Install Rtools on Windows

Rtools contains build tools needed when certain R packages must be compiled from source. **Rtools is for Windows only.** It is not always needed if R can install prebuilt packages, but installing a compatible version in advance may prevent package installation errors.

1. In RStudio's **Console**, enter `getRversion()` to see the installed R version.
2. Open [CRAN's Rtools page](https://cran.r-project.org/bin/windows/Rtools/).
3. Select the Rtools version that CRAN lists as compatible with your R version. For example, CRAN lists **Rtools 4.5** for R 4.5 and later in the corresponding toolchain series. **Do not automatically choose the newest Rtools for an older R installation.**
4. Download the appropriate installer for your Windows architecture and run it. Keep the default installation directory unless CRAN instructs otherwise.
5. Restart RStudio after installation.
6. If a package installation requires compilation, you can check whether build tools are available by running:

   ```r
   install.packages("pkgbuild", repos = "https://cloud.r-project.org")
   pkgbuild::has_build_tools(debug = TRUE)
   ```

   A `TRUE` result indicates the build tools are available. If you get `FALSE`, review the messages and the instructions on the CRAN Rtools page.

**macOS:** Do not install Rtools. If a package needs compilation, macOS may require Apple's Command Line Tools (`xcode-select --install` in Terminal) and sometimes additional compilers. **Linux:** Do not install Rtools; use your distribution's compiler and development-library packages when required.

### Step 2B: Install Git

Git allows RStudio to download the project as a repository and track changes. Git and GitHub are different: **Git is installed on your computer; GitHub is the website hosting this repository. You do not need GitHub Desktop.**

**Windows**

1. Go to [https://git-scm.com/downloads](https://git-scm.com/downloads) and select **Windows**.
2. Download **Git for Windows** for your architecture and run the `.exe` installer (downloading the file alone does not install Git).
3. The default installation options are usually sufficient. Leave Git Credential Manager enabled if the installer offers it.
4. Finish installation and restart RStudio.

**macOS**

1. Open **Terminal** and enter `git --version`.
2. If macOS prompts you to install Apple's Command Line Tools, follow that prompt. This normally installs Git. You can also use an installer linked from [git-scm.com](https://git-scm.com/downloads/mac).
3. Run `git --version` again to confirm installation.

**Linux**

1. Open a terminal and install Git using your distribution's package manager, such as `sudo apt install git` on Ubuntu/Debian or `sudo dnf install git` on Fedora.
2. Enter `git --version` to check that it is installed.

**Connect Git to RStudio**

1. Open **RStudio Desktop → Tools → Global Options → Git/SVN**.
2. Check **Enable version control interface for RStudio projects** if the option is present.
3. Look at the **Git executable** field. If RStudio already found Git, leave it as is.
4. If it is blank, select **Browse** and locate Git. A common Windows path is `C:\Program Files\Git\bin\git.exe`. Other installations may use a different path. On macOS or Linux, run `which git` in Terminal to find the executable.
5. Click **Apply → OK** and restart RStudio.
6. In **Tools → Terminal → New Terminal** (or the Terminal tab), run `git --version`. It should print a version number. Enter terminal commands in the **Terminal**, not the R **Console**.

If **Git/SVN** does not appear, confirm that Git was installed (not just downloaded), restart RStudio, and check that you are using RStudio Desktop rather than viewing GitHub in a browser. See [RStudio's version-control instructions](https://docs.posit.co/ide/user/ide/guide/tools/version-control.html).

### Step 3: Download or clone the GitHub repository

**Repository:** [https://github.com/kmillerpsu/college-student-mental-health](https://github.com/kmillerpsu/college-student-mental-health)  
**Clone URL:** `https://github.com/kmillerpsu/college-student-mental-health.git`

**Method 1 — Clone with RStudio (recommended)**

1. Open the repository page in your browser. Click **Code → Local → HTTPS** and copy the URL ending in `.git`.
2. In RStudio, select **File → New Project → Version Control → Git**.
3. Paste the URL into **Repository URL**. The project directory name should fill in automatically.
4. Under **Create project as subdirectory of**, browse to a location such as **Documents**. Select the **parent folder** where you want the repository saved; do not create another copy of the repository folder inside itself.
5. Click **Create Project**. RStudio will download the repository and open it as a project.
6. In the **Files** tab, confirm you can see `Run Project.Rmd`, `code/`, `data/`, and `college-student-mental-health.Rproj`.
7. If the repository is private, GitHub authentication or permission may be required. To clone a public repository, a GitHub account usually is not needed.

If **Version Control** or **Git** is missing from the New Project menu, return to Step 2B and confirm RStudio recognizes Git.

**Method 2 — Clone from a terminal**

1. Open **Terminal**, **PowerShell**, or **Git Bash**. Change to a location where you want the project folder stored.
2. Enter:

   ```bash
   git clone https://github.com/kmillerpsu/college-student-mental-health.git
   ```

3. In RStudio, select **File → Open Project** and open `college-student-mental-health/college-student-mental-health.Rproj`.

**Method 3 — Download a ZIP (no Git required)**

1. Open the [repository page](https://github.com/kmillerpsu/college-student-mental-health) and select **Code → Download ZIP**.
2. Find the file in Downloads and **extract it before opening any R Markdown file**. On Windows, right-click and choose **Extract All**; on macOS, double-click the ZIP; on Linux, use your file manager's extraction option.
3. Move the extracted folder to Documents or another location where you have permission to save files.
4. Open its `.Rproj` file in RStudio. A ZIP download lets you run the analysis, but it does **not** include Git history or support Git Pull/Push. Clone the repository instead if you plan to upload edits back to GitHub.

Do not move or rename the project's `code/` or `data/` subfolders, or the numbered analysis files. The master RMD expects these exact paths.

### Step 4: Open the project in RStudio

1. If RStudio opened the project automatically after cloning, continue to Step 5.
2. Otherwise, open `college-student-mental-health.Rproj` from the cloned or extracted repository folder by double-clicking it, or use **File → Open Project** in RStudio.
3. Check the **Files** pane. You should see `Run Project.Rmd`, `code/`, and `data/`.
4. Open **`Run Project.Rmd`**, the main file at the top level of the project. Do not open one of the individual numbered scripts to run the full project.
5. If you cloned the repository using Git, the **Git** tab should appear in RStudio. It may be located alongside the Environment and History tabs. If you used ZIP, no Git tab is expected for that folder.

### Step 5: Check that RStudio is in the right folder

1. Find the **Console** pane in RStudio.
2. Copy the following command, paste it into the Console, and press **Enter**:

```
getwd()
```

3. RStudio should print the path to your downloaded project folder.
4. Now paste this command and press **Enter**:

```
file.exists("data/split/training_data.csv")
```

5. The result should be `TRUE`. If it is `FALSE`, go back to Step 4 and open the `.Rproj` file from the correct extracted folder. Also check that the CSV is inside `data/split/`.

### Step 6: Run the full analysis

1. Make sure `Run Project.Rmd` is open in the editor.
2. Click the **Knit** button near the top of the editor (look for a small yarn-ball icon).
3. If RStudio asks which output format to use, choose **Knit to HTML**.
4. **If RStudio asks whether to install missing or required packages, choose Yes or Install.** The packages are needed to run the analysis. Keep an internet connection active and allow installation to finish before knitting again, if prompted. The master file also checks for missing R packages and attempts to install them from CRAN. Messages beginning with `trying URL` normally mean packages are downloading.
5. If a dialog asks you to choose a CRAN download mirror, choose a nearby mirror or the cloud mirror; the script normally sets this automatically.
6. Do not close RStudio while the file is running. Some models, especially random forest and XGBoost, can take additional processing time.
7. When knitting succeeds, an HTML report called something like `Run Project.html` should open in RStudio's viewer or a browser window.
8. Scroll through the report. It is designed to show the **six tables and six figures used in the updated paper**, rather than all the intermediate output from the individual scripts.

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
   - `figures/` — image files for the six paper figures.
6. The HTML report uses formatted tables (including `knitr::kable`) and figures. The CSV files are included so the underlying numbers can also be checked.

**Note:** The main project does **not** promise a folder named `outputs/reports/`. Look for the HTML report next to the master RMD and the exported files under `outputs/paper_only/`.

---

## Option B: Run the project online using Posit Cloud

Posit Cloud gives you an RStudio workspace in a web browser. You do not need to install R or RStudio on your computer for this option.

### Step 1: Create an account

1. Go to [**https://posit.cloud/**](https://posit.cloud/).
2. Select **Sign Up** to create an account, or **Log In** if you already have one.
3. Follow the account setup steps shown on the website.
4. After signing in, go to **Your Workspace** (the personal workspace in the sidebar).

### Step 2: Import the GitHub project

1. In Your Workspace, find **New Project**.
2. Open its menu or drop-down arrow and choose **New Project from Git Repository**. The exact menu wording may vary slightly.
3. Copy this repository address:

```
https://github.com/kmillerpsu/college-student-mental-health.git

```

4. Paste that address into the box asking for the Git repository URL.
5. Confirm or click **OK/Create Project**.
6. Posit Cloud will copy the repository files into a new online RStudio project.
7. When the RStudio interface opens, use the **Files** tab to check for `Run Project.Rmd`, `code/`, and `data/`.

If the repository is private or you do not have access, the import may require GitHub authorization. The Git repository URL must be an **HTTPS** URL, not an SSH URL.

### Step 3: Check the input files

1. In the RStudio Console inside Posit Cloud, paste:

```
file.exists("data/split/training_data.csv")
```

2. Press **Enter**.
3. If it prints `TRUE`, the example input file is in the expected location.
4. If it prints `FALSE`, check the `data/split/` folder and make sure you imported the full repository.

### Step 4: Knit the report

1. In the Files pane, click `Run Project.Rmd`.
2. Click **Knit**, then select HTML if prompted.
3. **If RStudio asks you to install required packages, choose Yes or Install** and let installation finish. The master file will also attempt to install missing R packages before running the analysis scripts.
4. When the report finishes, open the resulting HTML output.
5. To find the exported tables and figures, open `outputs/paper_only/` in the Files pane.
6. To save a result to your own computer, select the file in the Files pane and use the **More → Export** or **Export** option, if available in your interface.

### Important limitation for Posit Cloud

The Posit Cloud free plan has limited memory and processing resources. Our project uses large survey datasets and machine-learning models, so **the complete run may fail on the free plan even when the code is correct**. If you see an out-of-memory error, a disconnected session, or a resource-limit message, use Option A on a computer with more memory or use a Posit Cloud plan/workspace with more resources. Package installation also requires an internet connection in the online workspace.

The current Posit Cloud plans and limits are listed at [**https://posit.cloud/plans**](https://posit.cloud/plans).

---

## Updating the GitHub repository

These steps are for people who have permission to write to this GitHub repository. **Cloning or downloading the project does not give someone permission to change the original repository.** If you only need to reproduce the paper, you can skip this section.

### Step 1: Open your cloned project

1. Open `college-student-mental-health.Rproj` in RStudio.
2. Verify the **Git** tab is visible. If the repository was downloaded as a ZIP, go back to [Step 3](#step-3-download-or-clone-the-github-repository) and clone it instead.
3. Make changes to project files in RStudio, and **save** each edited file (`Ctrl+S` on Windows/Linux or `Cmd+S` on macOS).

### Step 2: Set your Git name and email (once per computer)

Open RStudio's **Terminal** tab and run the following commands, substituting your own name and the email associated with your GitHub commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

These identify the author of future commits. They do not log you into GitHub. You can check your configuration with `git config --global --list`.

### Step 3: Get the latest changes before uploading your own

1. In RStudio's **Git** tab, click **Pull**, or run `git pull` in the Terminal.
2. If Git reports a conflict or says local changes would be overwritten, **do not delete or discard files**. Save your work and resolve the conflict before continuing.
3. When working with other people, pull before beginning an editing session whenever possible.

### Step 4: Commit your changes locally

1. In the **Git** tab, review the files listed as changed.
2. Check the **Staged** box only for the files you want to upload. **Do not stage private information, access tokens, temporary files, or large generated outputs unless those are meant to be shared.**
3. Click **Commit**. In the window that opens, enter a short message describing the changes, such as `Update README setup instructions`.
4. Click **Commit** and close the confirmation window.

Equivalent commands in the Terminal (after reviewing the filenames with `git status`) are:

```bash
git add README.md
git commit -m "Update README setup instructions"
```

The commit is now saved **on your computer**; it is not yet uploaded to GitHub.

### Step 5: Push your commit to GitHub

1. In RStudio's **Git** tab, click **Push** (the upward arrow), or run `git push` in the Terminal.
2. If prompted, authenticate with GitHub using the browser/credential manager or another method configured for your account. **Your ordinary GitHub account password is not used as a password for Git over HTTPS.** Do not put a token in this README or save it in the project files.
3. If GitHub refuses the push because you do not have write access, ask the repository owner for collaborator access. Alternatively, fork the repository in GitHub and make changes in your own fork.
4. Refresh [the GitHub repository](https://github.com/kmillerpsu/college-student-mental-health), open the changed file, and confirm your update appears. A commit that has not been pushed will not appear on the website.

**To upload the edited README for this project:** Save this file as `README.md` in the root of the cloned repository, replacing the old README after keeping a backup if necessary. Stage `README.md`, commit it, and push. You do not need to re-upload the whole project or create a new repository.

**To add other files to the repository:** Copy them into the appropriate local project folder, check that the filenames and contents are correct, then stage, commit, and push them in the same way. Avoid pushing duplicate copies of the full dataset or generated files unless they are required by the project and permitted to be shared.

---

## If something goes wrong

### “Required project files were not found” or “Cannot find ...csv”

- Make sure the GitHub ZIP was **extracted**.
- Open the project's `.Rproj` file rather than an individual RMD from your Downloads folder.
- Confirm `Run Project.Rmd` is at the top level of the project folder.
- Confirm scripts `02`, `03`, and `04` are inside `code/` with **exactly the expected filenames**.
- Confirm the processed CSVs are in `data/processed/` and the split CSVs are in `data/split/`.

### Git is missing from RStudio or `git` is not recognized

- Confirm you ran the Git installer, not just downloaded it. Close and reopen RStudio afterward.
- Check **Tools → Global Options → Git/SVN**, enable the version-control interface, and select the installed Git executable if RStudio did not detect it.
- In RStudio's **Terminal**, enter `git --version`. If the command is not recognized, check Git's installation or PATH setting and restart RStudio.
- If you downloaded a ZIP rather than cloning, the Git tab will not be available for that copy.

### GitHub authentication fails when pushing

- Confirm you have permission to push to the repository. Anyone can clone a public repository, but only collaborators can push to it.
- Use the browser sign-in offered by Git Credential Manager, or follow GitHub's current instructions for a personal access token or SSH key. Do not enter your GitHub account password into an old Git password prompt.
- If a push is rejected because the remote branch has changed, pull and resolve any conflicts before pushing again.

### “There is no package called ...” or package installation fails

- **If RStudio asks to install missing packages, select Yes or Install.** These packages are required for the project. Wait until installation is complete before trying to knit again.
- Check your internet connection.
- Close and reopen RStudio, then knit the master RMD again.
- The master file attempts to install missing packages, but some packages need additional system dependencies. On Windows, follow [Step 2A](#step-2a-install-rtools-on-windows) if a source package needs compilation. On macOS/Linux, follow the compiler or system-library message shown in the error.
- In the Console, you can try installing the named package manually if needed, for example:

```
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
- The **raw 2017–2018 data file is not included** in the repository due to its size. To request it for reproducing that earlier cleaning stage, email [**kmm8841@psu.edu**](mailto:kmm8841@psu.edu).
- The cleaned 2017–2018 dataset is included under `data/processed/`, so the main comparisons and downstream analyses can run without the raw 2017–2018 file, provided all listed processed and split datasets are present.
- Since the surveys include different respondents in the two periods, results describe differences between independent groups; they do not prove that the pandemic caused those changes.
- Re-running models on another machine may give small differences because of R/package versions and computing environments, even though a fixed seed is used.

## Repository structure

```
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

**Quick reminder:** To reproduce the paper results, open the `.Rproj` file, open `Run Project.Rmd`, and click **Knit**. You do not need to run Scripts 01–04 individually. [Back to the table of contents](#table-of-contents).