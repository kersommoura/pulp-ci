py36='python3'
sudo yum -y install ansible
mkdir -p ~/pulp3-dev
cd ~/pulp-dev
git clone https://github.com/pulp/devel.git 
cd ansible

  echo 'localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python2' > hosts
  source "${{RHN_CREDENTIALS}}"
  ansible-playbook configure-rhel-7.yml \
    -i hosts \
    -e "rhn_username=${{RHN_USERNAME}}" \
    -e "rhn_password=${{RHN_PASSWORD}}" \
    -e "rhn_pool=${{RHN_POOL}}"
  prefix='scl enable rh-python36 --'
else
  echo 'localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3' > hosts
  prefix=''
fi
# Install pulpcore. (The Ansible code disables SELinux.)
ansible-playbook pulp-from-source.yml --inventory hosts
# Install pulp_file.
sudo su - vagrant bash -c "
${{prefix}} ~/.virtualenvs/pulp/bin/pip install git+https://github.com/pulp/pulp_file.git#egg=pulp-file
yes yes | ${{prefix}} ~/.virtualenvs/pulp/bin/pulp-manager makemigrations pulp_file
${{prefix}} ~/.virtualenvs/pulp/bin/pulp-manager migrate pulp_file
"
sudo systemctl restart pulp_resource_manager pulp_worker@1 pulp_worker@