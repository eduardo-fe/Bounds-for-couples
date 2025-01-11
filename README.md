# README: Bounds for Average Treatment Effect on Couples

This repository contains the code and supplementary files for the paper **"Bounds for Average Treatment Effect on Couples with an Application to the Retirement-Consumption Puzzle"**, forthcoming in *Economics Letters*.

## Overview
The paper introduces a methodology to estimate bounds for the average treatment effect (ATE) on couples, with a specific application to the Retirement-Consumption Puzzle. The provided code reproduces the empirical results presented in the paper. You will need the Living Costs and Food Survey (2002 -2017)

## Files in the Repository

1. **`datapreparation.do`**:
   - This script is the first to be executed.
   - It preprocesses the raw data, creating a clean dataset ready for analysis.

2. **`omega.ado`**:
   - Contains the core functions used in the analysis.
   - Includes procedures for estimating bounds and performing related computations.

3. **`boundsPeerEffects_v3.do`**:
   - This script is called by `omega.ado`.
   - Handles the specific implementation of bounds calculations and peer effect modeling.

## Instructions for Use

1. **Setup**:
   - Ensure you have Stata installed (version 16 or later recommended).
   - Place all scripts in the same working directory.

2. **Run the Scripts**:
   - Start with `datapreparation.do` to prepare the data.
   - The `datapreparation.do` script will ensure the dataset is formatted correctly for subsequent steps.
   - Execute `omega.ado` to load the necessary functions.
   - `boundsPeerEffects_v3.do` will be automatically called during the execution of `omega.ado`.

3. **Output**:
   - The scripts will generate key tables and figures presented in the paper.
   - Results are saved in the designated output folder, which can be customized in the code.

## Citation
If you use this code, please cite the paper:

```
Fé, E. (Forthcoming). Bounds for Average Treatment Effect on Couples with an Application to the Retirement-Consumption Puzzle. *Economics Letters*.
```

## License
This repository is shared under the MIT License. See the LICENSE file for more details.

## Contact
For questions or further assistance, please contact the author.
