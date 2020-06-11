Create an application that will be a package manager for the language R.

R language packages can be found here: http://cran.r-project.org/src/contrib/
The application should represent the package list from the file http://cran.r-project.org/src/contrib/PACKAGES

Features:
- download file PACKAGES and parse it (you can use ready-gem)
- create a model representing packages
- save package information in the database (description, title, authors, version, maintainers, license, publication date)

Detailed data on specific packages can be found in DESCRIPTION files inside * .tar.gz packages

Requirements:
- standard Rails application
- database (mysql / postgres / sqlite - to choose)
- rake task for refreshing package data
- tests
- controllers, views and UI are not required (models and data support only)
