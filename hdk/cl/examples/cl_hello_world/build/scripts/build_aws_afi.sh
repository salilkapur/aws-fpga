aws ec2 create-fpga-image \
        --region us-east-1 \
        --name afi_hello_world \
        --description HelloWorld \
        --input-storage-location Bucket=fpgaafi,Key=cl_hello_world/18_09_28-023324.Developer_CL.tar \
        --logs-storage-location Bucket=fpgaafi,Key=afi_build_logs/afi_hello_world_build_log.txt \
        --no-dry-run
