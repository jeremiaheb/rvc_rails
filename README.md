# RVC Rails Backend

## Adding Data

### Adding Sample (AR) Data

1. Create a csv (comma seperated values) file of analysis ready data (AR2.0). Use the [analysisready package](https://github.com/jeremiaheb/analysisready) if necessary. Each file should contain sample data for all species in a given year and region. **DO NOT** include more than one year or region in an individual AR2.0 file.
1. Compress each file into a zip file. **DO NOT** include more than one csv in a zip file.
1. Rename the csv and zip files to match the following convention: &lt;region\_abbreviation&gt;&lt;year&gt;.&lt;file\_extension&gt;. The region abbreviations are: fk - Florida Keys, dt - Dry Tortugas, sefcri - Southeast Florida Coral Reef Initiative. For example, sample data from the Florida Keys in 2012 in zip format will be names "fk2012.zip". Sample data from 2004 in the Dry Tortugas in csv format will be names "dt2004.csv". **NOTE**: Each region/year should have two files: a csv file, and a zip file.
1. Place the csv and zip files directly into the <public/data/sample_data> subdirectory of this Rails application.
1. Add the new year/region domain to the list in <app/controllers/samples_controller.rb>.

### Adding Stratum (NTOT) Data

1. Create a csv file with columns named: "YEAR","REGION", "STRAT", "PROT", "NTOT" (number of possible primary sampling units), and "GRID\_SIZE" (side length of a primary sample unit, in meters). **DO NOT** include more than one year and region in a single ntot file.
1. Rename the file according to the following convention: ntot\_&lt;region\_abbreviation&gt;&lt;year&gt;.csv.
1. Place the csv file directly into the <public/data/stratum_data> subdirectory of this Rails application.
1. Add the new year/region domain to the list in <app/controllers/stratum_controller.rb>.

### Adding Taxonomic Data

1. Create a csv file with columns named: "SPECIES\_CD","SCINAME","COMNAME","LC", "LM","WLEN\_A","WLEN\_B". Where SPECIES\_CD is the first three letters of the generic name and first four letters of the specific name, SCINAME and COMNAME are the scientific and common name, respectively, LC is the length at capture (in cm), LM is the median length at maturity (in cm), WLEN\_A is the alpha coefficient of the allometric growth equation in g/mm, and WLEN\_B is the beta coefficient of the allometric growth equation.
1. Rename the file to taxonomic\_data.csv
1. Place the csv file directly into the <public/data/taxonomic_data> subdirectory of this Rails application.

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

The development server will start and be available at <http://localhost:3000/rvc_analysis20>.