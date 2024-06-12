# Golf Analytics SQL Repository

This repository contains SQL scripts used to analyze golfers' performance data. The scripts create and manipulate temporary tables to filter user data and compute various performance metrics, providing insights into players' rounds and handicap indices.

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [File Structure](#file-structure)
4. [SQL Scripts Overview](#sql-scripts-overview)
   - [01_users_filtered_with_pb_data.sql](#01_users_filtered_with_pb_datasql)
   - [02_user_pb_multi_data.sql](#02_user_pb_multi_datasql)
5. [Usage](#usage)
6. [Contributing](#contributing)
7. [License](#license)

## Introduction

This repository provides a set of SQL scripts designed to create temporary tables and process user data for detailed golf performance analysis. The main focus is on filtering users with significant data and calculating various statistics related to their scores and handicaps.

## Getting Started

To get started with these SQL scripts, ensure you have access to a MySQL database where you can run these queries. The scripts are designed to run on the database `thegrint_analytics` and will expect the first two steps to be completed to setup the needed tables for further analysis.

## File Structure

The repository is structured as follows:

```
thegrint_analytics/
│
├── requests/
│   ├── tmp_user_pb_multi_data/
│   │   ├── Summary/
│   │   │   ├── additional-data-based-on-scores.sql
│   │   │   ├── average-difference-score-after-pb.sql
│   │   │   ├── rounds-played-between-pbs.sql
│   │   ├── 01_users_filtered_with_pb_data.sql
│   │   ├── 02_user_pb_multi_data.sql
│   ├── README.md
```

## SQL Scripts Overview

### 01_users_filtered_with_pb_data.sql

This script filters the user data to include only those with at least 50 rounds played and a personal best score of 60 or higher. It creates several temporary tables to process and store this filtered data.

**Steps:**

1. **Create Temporary User IDs Table**:

   - Filters users with at least 50 rounds and a personal best score of 60 or higher.

2. **Filter User Scores**:

   - Joins the filtered user IDs with the original scores to create a filtered dataset.

3. **Add User's Best Score Date**:

   - Adds the date of the user's best score to the table.

4. **Create Final Filtered Data Table**:
   - Combines all the previous steps to produce a final table with the filtered user data.

### 02_user_pb_multi_data.sql

This script creates a table to store detailed performance metrics for each user, including personal best scores, average scores, and various handicap indices.

**Steps:**

1. **Create User Performance Data Table**:

   - Aggregates various statistics for each user, such as their best round, subsequent round performances, and average handicaps.

2. **Filter Invalid Metrics**:
   The following filters are applied at a user's individual rounds level before aggregating up to the user level. This allows retention of the most amount of users while excluding extreme values that might provide incorrect aggregation data.

   - Handicap Index: -30 to +100
   - Round Score: -30 to +175
   - Length of Time Between Personal Bests: 0 to +1000 rounds

3. **Compute Detailed Metrics**:
   - Calculates metrics such as time between personal bests, score differences, and average scores for the next rounds.

## Usage

1. **Run the Filtering Script**:

   - Execute `01_users_filtered_with_pb_data.sql` to create the initial filtered dataset.

   ```sql
   source requests/tmp_user_pb_multi_data/01_users_filtered_with_pb_data.sql;
   ```

2. **Run the Performance Metrics Script**:

   - Execute `02_user_pb_multi_data.sql` to create the detailed user performance data.

   ```sql
   source requests/tmp_user_pb_multi_data/02_user_pb_multi_data.sql;
   ```

3. **Additional Analysis**:
   - Use the provided queries in the `Summary` directory to perform further analysis based on the created tables.
