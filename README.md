# RVC Rails Backend

## Dependencies
1. Postgresql-9.4 (http://www.postgresql.org).
2. Ruby-2.2.X (http://www.ruby-lang.org).
3. Rails-4.2.X (http://www.rubyonrails.org)

## Setting up the database
You must have Postgresql-9.4 installed, and have the PG gem installed.
Run ```Bundle install``` in your command line to install the PG gem.

The database configuration does not have a username and password set (see config/database.yml).
Depending on how you have configured Postgresql, this may cause problems in creating a
database. In order to create and update the database it is suggested that you
create a user with login and createdb privileges, then set the PGUSER and PGPASSWORD
environmental variables to that username and password. You can add the following
to your .bashrc or .bash\_profiles file if you want:
```
export PGUSER=<your username>
export PGPASSWORD=<your password>
```
If you are using Ubuntu, you might want to look at
<a href="https://help.ubuntu.com/community/PostgreSQL">this help article</a> to
install Postgres and get it set up with md5 authentication.

## Adding Data to the Database

### Adding Sample (AR) Data
1. Create a csv (comma seperated values) file of analysis ready data (AR2.0).
use the analysisready package (http://github.com/harryganz/analysisready) if necessary.
Each file should contain sample data for all species in a given year and region.
**DO NOT** include more than one year or region in an individual AR2.0 file.
2. Compress each file into a zip file. **DO NOT** include more than one csv
in a zip file.
3. Rename the csv and zip files to match the following convention:
&lt;region\_abbreviation&gt;&lt;year&gt;.&lt;file\_extension&gt;. The region abbreviations are:
fk - Florida Keys, dt - Dry Tortugas, sefcri - Southeast Florida Coral Reef
Initiative. For example, sample data from the Florida Keys in 2012 in zip format
will be names "fk2012.zip". Sample data from 2004 in the Dry Tortugas in csv
format will be names "dt2004.csv". **NOTE**: Each region/year should have two files:
a csv file, and a zip file.
4. Place the csv and zip files directly into the sample\_data subdirectory of the
public directory of this Rails application.

### Adding Stratum (NTOT) Data
1. Create a csv file with columns named: "YEAR","REGION", "STRAT", "PROT", "NTOT" (number of possible primary sampling units), and "GRID\_SIZE" (side length of a primary sample unit,
in meters). **DO NOT** include more than one year and region in a single ntot file.
2. Rename the file according to the following convention:
ntot\_&lt;region\_abbreviation&gt;&lt;year&gt;.csv.
3. Place the csv file(s) directly into the stratum\_data directory of the public
folder of this Rails application.

### Adding Taxonomic Data
1. Create a csv file with columns named: "SPECIES\_CD","SCINAME","COMNAME","LC",
"LM","WLEN\_A","WLEN\_B". Where SPECIES\_CD is the first three letters of the
generic name and first four letters of the specific name, SCINAME and COMNAME are
the scientific and common name, respectively, LC is the length at capture (in cm),
LM is the median length at maturity (in cm), WLEN\_A is the alpha coefficient of
the allometric growth equation in g/mm, and WLEN\_B is the beta coefficient of the
allometric growth equation.
2. Rename the file to taxonomic\_data.csv
3. Save the file to the taxonomic\_data subdirectory of the public folder of this
Rails application.
