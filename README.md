# Azure CycleCloud template for ADVC

## Prerequisites

1. Prepaire for your ADVC bilnary.
1. Install CycleCloud CLI

## How to install 

1. tar zxvf cyclecloud-ADVC<version>.tar.gz
1. cd cyclecloud-ADVC<version>
1. put ADVC library/model on <template>/blobs directory.
1. pug OSS PBS Pro files on <template>/blobs directory.
1. Rewrite "Files" attribute for your binariy in "project.ini" file. 
1. run "cyclecloud project upload azure-storage" for uploading template to CycleCloud
1. "cyclecloud import_template -f templates/pbs_extended_nfs_advc.txt" for register this template to your CycleCloud

## How to run ADVC

1. Check License Server setting
1. Upload and Modify PBS script file
1. qsub ~/advcrun.sh (sample as below)

<pre><code>
#!/bin/bash 
#PBS -j oe
#PBS -l select=2:ncpus=44
NP=88

## Platform MPI
#MPI_ROOT="/shared/home/azureuser/apps/Solver-2018-R1_3/platform_mpi/bin"
#export MPI_HASIC_UDAPL=ofa-v2-ib0
#export MPI_IB_PKEY="0x8008"

#disable source comamnd in advc-solver.conf
sed -i -e "s/^source/#source/g" ${HOME}/apps/Solver-2019R1_0r19/etc/advc-solver.conf

#Geneeal settings
export ADVC_DIR="/shared/home/azureuser/apps/Solver-2019R1_0r19/bin" 
export ALDE_LICENSE_FILE=27000@<Yout License Server IPAddress>

# MPI settings
export MPI_ROOT="/opt/intel/impi/2018.4.274"
export I_MPI_ROOT=$MPI_ROOT
export I_MPI_DEBUG=9
export I_MPI_FABRICS=shm:ofa # for 2019, use I_MPI_FABRICS=shm:ofi
# H16r 
#export I_MPI_FABRICS=shm:dapl
#export I_MPI_DAPL_PROVIDER=ofa-v2-ib0
#export I_MPI_DYNAMIC_CONNECTION=0
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/shared/home/azureuser/apps/Solver-2019R1_0r19/user_lib
source /opt/intel/compilers_and_libraries/linux/mpi/bin64/mpivars.sh

# running config
INPUT=/mnt/exports/shared/home/azureuser/model_v2.adv

cd ${PBS_O_WORKDIR}
${ADVC_DIR}/ADVCSolver ${INPUT} -np ${NP} | tee ADVC-`date +%Y%m%d_%H-%M-%S`.log
</pre></code>

## Known Issues
1. This tempate support only single administrator. So you have to use same user between superuser(initial Azure CycleCloud User) and deployment user of this template
2. Currently AutoScale is disabled. you have to create execute node and get IP. In addtion, create hosts file for your execute node environment.

# Azure CycleCloud用テンプレート:ADVC(NFS/PBSPro)

[Azure CycleCloud](https://docs.microsoft.com/en-us/azure/cyclecloud/) はMicrosoft Azure上で簡単にCAE/HPC/Deep Learning用のクラスタ環境を構築できるソリューションです。

![Azure CycleCloudの構築・テンプレート構成](https://raw.githubusercontent.com/hirtanak/osspbsdefault/master/AzureCycleCloud-OSSPBSDefault.png "Azure CycleCloudの構築・テンプレート構成")

Azure CyceCloudのインストールに関しては、[こちら](https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud) のドキュメントを参照してください。

ADVC用のテンプレートになっています。
以下の構成、特徴を持っています。

1. OSS PBS ProジョブスケジューラをMasterノードにインストール
2. H16r, H16r_Promo, HC44rs, HB60rsを想定したテンプレート、イメージ
	 - OpenLogic CentOS 7.6 HPC を利用 
3. Masterノードに512GB * 2 のNFSストレージサーバを搭載
	 - Executeノード（計算ノード）からNFSをマウント
4. MasterノードのIPアドレスを固定設定
	 - 一旦停止後、再度起動した場合にアクセスする先のIPアドレスが変更されない

![テンプレート構成](https://raw.githubusercontent.com/hirtanak/osspbsdefault/master/OSSPBSDefaultDiagram.png "テンプレート構成")

OSS PBS Defaultテンプレートインストール方法

前提条件: テンプレートを利用するためには、Azure CycleCloud CLIのインストールと設定が必要です。詳しくは、 [こちら](https://docs.microsoft.com/en-us/azure/cyclecloud/install-cyclecloud-cli) の文書からインストールと展開されたAzure CycleCloudサーバのFQDNの設定が必要です。

1. テンプレート本体をダウンロード
2. 展開、ディレクトリ移動
3. cyclecloudコマンドラインからテンプレートインストール 
   - tar zxvf cyclecloud-ADVC<version>.tar.gz
   - cd cyclecloud-ADVC<version>
   - cyclecloud project upload azure-storage
   - cyclecloud import_template -f templates/pbs_extended_nfs_starccm.txt
4. 削除したい場合、 cyclecloud delete_template ADVC コマンドで削除可能

***
Copyright Hiroshi Tanaka, hirtanak@gmail.com, @hirtanak All rights reserved.
Use of this source code is governed by MIT license that can be found in the LICENSE file.
