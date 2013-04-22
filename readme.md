#Monitoring System

##Introduction
The monitoring systems comprises several elements:

* a database (an instance of (https://github.com/jean-marc/objrdf)[libobjrdf]) that stores all the system information (sites, sets, equipment, contacts,..) and the monitoring (logs and reports) 
* a VPN server that accepts connection from remote kiosks, it notifies the database when a kiosk comes on-line and when it leaves, it also provides a list of currently on-line kiosks
* a web server, it is mainly used for access control (basic authentification), all authorized requests are proxied to the database built-in web server

There are 2 users dedicated to the monitoring tasks:

* monitor: runs monitoring jobs on remote hosts and sends the result to the database, it logs in as unicef_admin on the remote machines using public key authentication (older systems do not have the 'unicef_admin' user, it can be added with ```useradd -n -s /bin/bash -G admin,dialout unicef_admin```, alternatively .ssh/config can be modified to use a different user depending on IP address)
* objrdf: runs the database and web server on non-privileged port (1080)


##Database

###Identifying resources

Natural name for equipment is the serial number (with some restrictions imposed by the RDF standard, eg.: can not start with a digit), 
###Modifying the schema
Should the database schema be modified (add a new field to a class, add a new class,...), the C++ source code will have to be edited and the server rebuilt. 
For the sake of illustration let us add a new property 'district' to the 'Site' class, used to represent a (potential) site for kiosk installation.
The modification to the code is minor (commit bfef7f500b9fd0ccdeec2e29662999135e2fae82):
```cpp
PERSISTENT_CLASS(District,std::tuple<>);
PROPERTY(district,District::allocator::pointer);
DERIVED_PERSISTENT_CLASS(Site,geo::Point,std::tuple<name,district,organization,array<report>>);
```
The new property is a pointer to an instance of the class 'District'.
Since the binary representation (stored in db/*) will probably change, the database will have to be dumped prior to the code modification and reloaded by the new built.
The procedure is:
```
./monitor_server > dump.rdf
mv db stow
make
mkdir db
./monitor_server dump.rdf
```
The orginal database is stowed away in 'db/' in case something goes wrong (if the build fails for instance)
Now we can create all the instances of 'District', it can be done manually through the web interface or programmatically, eg. a simple awk script fed a space separated list of districts:
```
BEGIN{printf "<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' xmlns='http://monitor.unicefuganda.org/#' >"}
{printf "<District rdf:ID='" $2 "'/>"}
END{printf "</rdf:RDF>"}
```
It is loaded in the database:
```
awk -f district.awk uganda_districts > districts.rdf
./monitor_server districts.rdf
```









