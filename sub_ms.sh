#!/bin/bash
#SBATCH -n 104
#SBATCH -N 1


# 打印任务信息
echo "Starting job $SLURM_JOB_ID at " `date`
echo "SLURM_SUBMIT_DIR is $SLURM_SUBMIT_DIR"
echo "Running on nodes: $SLURM_NODELIST"


# 执行任务

module load MaterialsStudio

export I_MPI_HYDRA_BOOTSTRAP=ssh
# 这里演示如何提交CASTEP任务。若要运行DMol3, MysoDyn, DFTB，可以取消相应的注释。
$MS2023/CASTEP/bin/RunCASTEP.sh -np $SLURM_NTASKS Ag

#apptainer exec --writable-tmpfs ${APPTAINER_MS2020} /opt/run_ms.sh DMol3/bin/RunDMol3.sh -np $SLURM_NTASKS Ag
#apptainer exec --writable-tmpfs ${APPTAINER_MS2020} /opt/run_ms.sh MesoDyn/bin/RunMesoDyn.sh -np $SLURM_NTASKS Ag
#apptainer exec --writable-tmpfs ${APPTAINER_MS2020} /opt/run_ms.sh DFTB/bin/RunDFTB.sh -np $SLURM_NTASKS Ag

# 若要使用Forcite、Sorption等程序，你需要用MS客户端创建一个Perl任务脚本，并使用RunMatScript.sh命令运行它：
# 关于如何创建Perl脚本请参考下面的链接：
#   https://nusit.nus.edu.sg/services/hpc/application-software/material-studio/
#apptainer exec --writable-tmpfs ${APPTAINER_MS2020} /opt/run_ms.sh Scripting/bin/RunMatScript.sh -np $SLURM_NTASKS Ag

# 任务结束
echo "Job $SLURM_JOB_ID done at " `date`
