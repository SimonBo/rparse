Stwórz aplikację, która będzie package managerem dla języka R.

Pakiety dla języka R znajdują się tutaj: http://cran.r-project.org/src/contrib/
Aplikacja powinna reprezentować listę pakietów z pliku http://cran.r-project.org/src/contrib/PACKAGES

Zadania:
- pobierz plik PACKAGES i sparsuj go (możesz użyć gotowego gema)
- stwórz model reprezentujący pakiety
- zapisz w bazie informacje o pakietach (description, title, authors, version, maintainers, license, publication date)

Szczegółowe dane o konkretnych pakietach znajdują w plikach DESCRIPTION wewnątrz paczek *.tar.gz 

Wymagania:
- standardowa aplikacja Rails
- baza danych (mysql/postgres/sqlite - do wyboru)
- rake task do odświeżania danych o pakietach
- testy
- kontrolery, widoki i UI nie są wymagane (wystarczą same modele i obsługa danych)
