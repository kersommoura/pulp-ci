sudo yum -y install ansible
echo 'localhost' > hosts
source "${RHN_CREDENTIALS}"
export ANSIBLE_CONFIG="${PWD}/ci/ansible/ansible.cfg"
ansible-playbook --connection local -i hosts ci/ansible/configure-rhel7.yaml \
    -e "rhn_password=${RHN_PASSWORD}" \
    -e "rhn_pool=${RHN_POOL}" \
    -e "rhn_username=${RHN_USERNAME}"