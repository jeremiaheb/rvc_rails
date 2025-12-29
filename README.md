# RVC Rails Backend

[![Build Status](https://github.com/jeremiaheb/rvc_rails/actions/workflows/ci.yml/badge.svg)](https://github.com/jeremiaheb/rvc_rails/actions/workflows/ci.yml)
[![Dependabot enabled](https://img.shields.io/badge/dependabot-enabled-025e8c?logo=Dependabot)](https://github.com/jeremiaheb/rvc_rails/security/dependabot)

## Adding Data

### Adding Sample (AR) Data

1. Create a csv (comma seperated values) file of analysis ready data (AR2.0). Use the [analysisready package](https://github.com/jeremiaheb/analysisready) if necessary. Each file should contain sample data for all species in a given year and region. **DO NOT** include more than one year or region in an individual AR2.0 file.
1. Compress each file into a zip file. **DO NOT** include more than one csv in a zip file.
1. Rename the csv and zip files to match the following convention: &lt;region\_abbreviation&gt;&lt;year&gt;.&lt;file\_extension&gt;. The region abbreviations are: fk - Florida Keys, dt - Dry Tortugas, sefcri - Southeast Florida Coral Reef Initiative. For example, sample data from the Florida Keys in 2012 in zip format will be names "fk2012.zip". Sample data from 2004 in the Dry Tortugas in csv format will be names "dt2004.csv". **NOTE**: Each region/year should have two files: a csv file, and a zip file.
1. Place the csv and zip files directly into the [public/data/sample_data](public/data/sample_data) subdirectory of this Rails application.
1. Add the new year/region domain to the list in [app/controllers/samples_controller.rb](app/controllers/samples_controller.rb).

### Adding Stratum (NTOT) Data

1. Create a csv file with columns named: "YEAR","REGION", "STRAT", "PROT", "NTOT" (number of possible primary sampling units), and "GRID\_SIZE" (side length of a primary sample unit, in meters). **DO NOT** include more than one year and region in a single ntot file.
1. Rename the file according to the following convention: ntot\_&lt;region\_abbreviation&gt;&lt;year&gt;.csv.
1. Place the csv file directly into the [public/data/stratum_data](public/data/stratum_data) subdirectory of this Rails application.
1. Add the new year/region domain to the list in [app/controllers/stratum_controller.rb](app/controllers/stratum_controller.rb).

### Adding Taxonomic Data

1. Create a csv file with columns named: "SPECIES\_CD","SCINAME","COMNAME","LC", "LM","WLEN\_A","WLEN\_B". Where SPECIES\_CD is the first three letters of the generic name and first four letters of the specific name, SCINAME and COMNAME are the scientific and common name, respectively, LC is the length at capture (in cm), LM is the median length at maturity (in cm), WLEN\_A is the alpha coefficient of the allometric growth equation in g/mm, and WLEN\_B is the beta coefficient of the allometric growth equation.
1. Rename the file to taxonomic\_data.csv
1. Place the csv file directly into the [public/data/taxonomic_data](public/data/taxonomic_data) subdirectory of this Rails application.

## Development Setup

### Vagrant

A [Vagrant](https://www.vagrantup.com) virtual machine (VM) is provided for local development. It runs the same Ansible provisioning as the production virtual machine, plus some additional commands that make it useful for development.

First, [install Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant). Then from within a terminal, run:

```bash
vagrant up
```

> [!NOTE]
> This command will take a while the first time it runs. Go for coffee or otherwise do something else for a while! It will not take nearly as long once it is setup for the first time.

If anything fails to provision on the first run, it might be a temporary issue (e.g., Internet failure). You can safely run this command as many times as it takes to complete successfully:

```bash
vagrant provision
```

Once `vagrant up` or `vagrant provision` completes, you can get a shell on the VM with:

```bash
vagrant ssh
```

To setup the application, within a `vagrant ssh` session, run:

```bash
bin/setup
```

Once `bin/setup` is running, the application will be available at <http://localhost:3000>

To start a Rails console, within a new `vagrant ssh` session, run:

```bash
bin/rails console
```

All typical `rake`, `rails`, `bundle`, etc commands can run this way.

For example, to run the test suite:

```bash
bin/rails test
```

To power off the machine without destroying it, within a terminal run:

```bash
vagrant halt
```

To power it back up again, run:

```bash
vagrant up --provision
```

### master.key

Rails uses the [config/master.key file](https://guides.rubyonrails.org/security.html#environmental-security) to encrypt credentials, including the session key base.

This file is intentionally _not_ committed to source control, but is required when first deploying the application to a new server or when adding encrypted credentials.

The current `master.key` file can be found in the "NCRMP Web Applications" Google Drive folder, and should be copied to the `config/` directory. Capistrano will automatically upload the `master.key` file when deploying the application for the first time.

### Testing

See [Rails Guides: Testing Rails Applications](https://guides.rubyonrails.org/testing.html).

To run the test suite, connect to the Vagrant VM (`vagrant ssh`) and run:

```bash
bin/rails test
```

To run the system tests (`tests/system`) which use a headless Chrome web browser to mimic real user interactions, run:

```bash
bin/rails test:system
```

### Code Formatting

[Rubocop](https://github.com/rubocop/rubocop) and [Prettier](https://prettier.io/) are used to maintain a consistent code format.

Most formatting errors can be automatically corrected by the tools themselves.

To run Rubocop and Prettier _and_ autocorrect any issues if possible, connect to the Vagrant VM (`vagrant ssh`) and run:

```bash
bin/lint --autocorrect
```

## Deployment

[Capistrano](https://capistranorb.com/) is used to deploy the code to servers over SSH.

[Create an SSH key](https://cloud.google.com/compute/docs/connect/create-ssh-keys#windows-10-or-later) if you have not already done so.

Next, add the key to an agent running locally. Open a terminal (Git Bash on Windows) and run:

```bash
eval "$(ssh-agent)"; ssh-add
```

Within this same terminal, login to the Vagrant VM:

```bash
vagrant ssh
```

Verify the key is available:

```bash
# long, random public key should print
ssh-add -L
```

If deploying to Google Cloud, also login to `gcloud`:

```bash
gcloud auth login
```

Finally:

```bash
bin/cap production deploy

# Or to deploy to Google Cloud:
bin/cap production_cloud deploy
```

You will be prompted for a branch name, which defaults to the current branch. If that is what you want to deploy, simply hit &lt;enter&gt;.

## Production Setup

### Machine Build

This repository builds and snapshots an Ubuntu-based virtual machine that is setup to host the application. It uses the same [Ansible playbook](./server/playbook.yml) as Vagrant (eliding some development tasks).

To build the virtual machine, install [Packer](https://www.packer.io).

Then from a terminal, run:

``` bash
packer build -force server
```

The VM will be snapshot into the `./server/output` directory. The VM will be left powered off in VirtualBox, but it can be powered back on for experimentation or use in development.

### Ansible

To run Ansible to provision an existing virtual machine (either one created `packer` above or a trusted Ubuntu cloud image), open a terminal (Git Bash on Windows) and run:

```bash
eval "$(ssh-agent)"; ssh-add
```

Within this same terminal, login to the Vagrant machine:

```bash
vagrant ssh
```

Direct Ansible to connect to the servers in the [inventory](./server/production.yml) and run the [playbook](./server/playbook.yml):

```bash
ansible-playbook --inventory server/production.yml --extra-vars ansible_user=USERNAME server/playbook.yml
```

Replace `USERNAME` with your username on the server. For example:

```bash
ansible-playbook --inventory server/production.yml --extra-vars ansible_user=jeremiaheb server/playbook.yml
```

To run the Ansible without actually changing anything, add the `--check` flag. To run the Ansible with more details about what did (or would) change, add the `--verbose` flag.

#### Cloud Instances

To run the Ansible playbook on cloud instances, within a `vagrant ssh` session, first run:

```bash
gcloud auth login
```

Click on the link provided, login with your Google account and paste the verification code into the terminal when prompted.

With the authentication setup, direct Ansible to connect to the servers in the [cloud inventory](./server/production_cloud.yml) and run the [playbook](./server/playbook.yml):

```bash
ansible-playbook --inventory server/production_cloud.yml server/playbook.yml
```

To run the Ansible without actually changing anything, add the `--check` flag. To run the Ansible with more details about what did (or would) change, add the `--verbose` flag.