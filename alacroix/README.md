# DFTB+

## Build

Le script de build se charge de télécharger le code de DFTB+ et de l'installer avec CMake. Pour lancer le build, exécuter :

```sbatch build_dftb.sh```

Les binaires seront installé dans ```$HOME/opt/dftbplus```

## Run

Pour exécuter le code, il faudra télécharger les données d'input sur le site de l'ISC26 (https://hpcadvisorycouncil.atlassian.net/wiki/spaces/HPCWORKS/pages/3759866661/Getting+Started+with+DFTB+for+ISC26+SCC+Virtual+Part) et déziper l'archive dans ```$HOME/opt/slakos```. 

Changer le nom du fichier ```dftb_in.hsd.no_elsi``` en ```dftb_in.hsd``` et ajouter dans ledit fichier le code suivant pour permettre la parallélisation hybride : 

```
Parallel {
  UseOmpThreads = Yes
}
```

Pour lancer les calculs, exécuter :

```sbatch run_dftb.sh```