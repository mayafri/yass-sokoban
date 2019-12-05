# Yass-Sokoban

Un petit jeu de Sokoban pour DOS, programmé en assembleur x86.

Le jeu possède une vingtaine de niveaux récupérés depuis les sources de [XSokoban](http://www.cs.cornell.edu/andru/xsokoban.html), un jeu de Sokoban pour UNIX publié dans le domaine public.

- [Télécharger l'exécutable (fichier .COM)](https://github.com/hyakosm/yass-sokoban/raw/master/MAIN.COM)

![Illustration du jeu](https://hyakosm.net/images_portfolio/sokodos.jpg)

## Configuration minimale

- Système MS-DOS ou compatible (PC-DOS, FreeDOS...)
- Processeur Intel 286 ou supérieur
- Carte graphique VGA ou MCGA (mode 13h - 256 couleurs en 320x200)

## Utilisation

- `F1` : recommencer le niveau
- `F2` : niveau précédent
- `F3` : niveau suivant
- `Échap` : quitter

## Compilation

Nécessite le compilateur NASM.

```nasm main.asm -o main.com```
