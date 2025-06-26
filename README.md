# RVC Rails Backend

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

## Development

[Vagrant](https://developer.hashicorp.com/vagrant) is used to ensure a consistent development environment using virtual machines.

After installing Vagrant, open a terminal (Git Bash on Windows) and run:

```bash
vagrant up --provision
```

This command will take a while the first time it is run. Subsequent runs will be quicker.

After it completes, login to the virtual machine:

```bash
vagrant ssh
```

To setup the Rails application, run:

```bash
bin/setup
```

The development server will start and be available at <http://localhost:3000/>.

To stop the development server and shut down the virtual machine, press &lt;Ctrl C&gt; and run:

```bash
vagrant halt
```

### Test Suite

Login to the virtual machine, if not already:

```bash
vagrant ssh
```

To run the entire test suite, run:

```bash
bin/rails test
```

To run a particular test file, run (for example):

```bash
bin/rails test test/controllers/samples_controller_test.rb
```

### Common Issues and Solutions

#### `vagrant up` fails

If it looks like a temporary error (e.g., Internet or Wifi blipped), simply run the command again with the `--provision` flag until it succeeds:

```bash
vagrant up --provision
```

#### "Could not find ... in locally installed gems"

New versions of gem dependencies need to be downloaded and installed. Run:

```bash
bundle install
```

And then retry the command.

#### Vagrant VM

It is always possible to rebuild the virtual machine from scratch if all else fails.

Open a terminal (Git Bash on Windows) and run:

```bash
vagrant destroy
```

Followed by:

```bash
vagrant up --provision
```

## Deployment

[Capistrano](https://capistranorb.com/) is used to deploy the code to servers over SSH.

[Create an SSH key](https://cloud.google.com/compute/docs/connect/create-ssh-keys#windows-10-or-later) if you have not already done so.

Next, add the key to an agent running locally. Open a terminal (Git Bash on Windows) and run:

```bash
eval $(ssh-agent); ssh-add
```

Within this same terminal, login to the virtual machine:

```bash
vagrant ssh
```

Verify the key is available within the virtual machine:

```bash
# long, random public key should print
ssh-add -L
```

With the key available to be used by Capistrano, run:

```
bin/cap production deploy
```

You will be prompted for a branch name, which defaults to the current branch. If that is what you want to deploy, simply hit &lt;enter&gt;.