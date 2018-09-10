py36='python3'
mkdir -p ~/.virtualenvs/pulp-smash/
${py36} -m venv ~/.virtualenvs/pulp-smash
source ~/.virtualenvs/pulp-smash/bin/activate
pip install --upgrade pip
pip install git+https://github.com/PulpQE/pulp-smash.git#egg=pulp-smash
mkdir -p ~/.config/pulp_smash
cat >~/.config/pulp_smash/settings.json <<EOF
{
  "hosts": [
    {
      "hostname": "p3.pulp.vm",
      "roles": {
        "api": {
          "port": 8000,
          "scheme": "http",
          "service": "nginx",
          "verify": false
        },
        "pulp resource manager": {},
        "pulp workers": {},
        "redis": {},
        "shell": {
          "transport": "ssh"
        }
      }
    }
  ],
  "pulp": {
    "auth": [
      "admin",
      "admin"
    ],
    "selinux enabled": false,
    "version": "3.0"
  }
}
EOF
pulp-smash settings path
pulp-smash settings show
pulp-smash settings validate
# Use pytest instead of unittest for XML reports. :-(
pip install pytest
# clone all repos to run tests
mkdir -p ~/.virtualenvs/p3-tests/
cd ~/.virtualenvs/p3-tests/ || exit
# pulp core
git clone https://github.com/pulp/pulp --branch master
# pulp file
git clone https://github.com/pulp/pulp_file --branch master
py.test -v --color=yes --junit-xml=junit-report.xml --pyargs pulp/pulpcore/tests/functional pulp_file/pulp_file/tests/functional
test -f junit-report.xml