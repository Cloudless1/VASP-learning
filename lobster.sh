#!/bin/bash

#SBATCH -n 104 
#SBATCH -N 1
#SBATCH -J yjr-v5

# 打印任务信息
echo "Starting job $SLURM_JOB_ID at " `date`
echo "SLURM_SUBMIT_DIR is $SLURM_SUBMIT_DIR"
echo "Running on nodes: $SLURM_NODELIST"

# 执行任务
## 载入lobster
module load lobster/5.1.1
lobster-4.1.0 > lobster-out.txt

# 任务结束
echo "Job $SLURM_JOB_ID done at " `date`
