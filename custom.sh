for node in juno.ihep.ac.cn dcomputing.ihep.ac.cn juno_nightlies.ihep.ac.cn
do 
    if ! mount | grep -q /cvmfs/$node ; then
        sudo mkdir -p /cvmfs/$node
        sudo mount -t cvmfs $node /cvmfs/$node 2>/dev/null >/dev/null || echo "Failed to mount /cvmfs/$node" 
    fi
done

export LANG=en_US.UTF-8
export EOS_MGM_URL=root://junoeos01.ihep.ac.cn/
