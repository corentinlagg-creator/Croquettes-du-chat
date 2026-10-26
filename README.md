# Croquettes du Chat — mise en place (GitHub Pages + Supabase)

Durée : 20 à 30 minutes, une seule fois. Tout est gratuit.

## 1. Créer la base Supabase

1. Crée un compte sur https://supabase.com, puis **New project**.
   Choisis une région européenne (Paris ou Frankfurt) et note le mot de passe de la base.
2. Une fois le projet prêt : **SQL Editor** > **New query**, colle tout le contenu de `schema.sql`, puis **Run**.
   Ça crée la table `journal`, les règles de sécurité (chacun ne voit que ses lignes) et une vue `journal_plat`.

## 2. Activer la connexion par code

Le site te connecte avec un code à 6 chiffres reçu par e-mail (plus fiable sur téléphone qu’un lien magique).

1. **Authentication** > **Emails** (ou *Email Templates*).
2. Dans le modèle **Magic Link**, ajoute dans le corps du message :
   `Ton code : {{ .Token }}`
3. Fais la même chose dans le modèle **Confirm signup** (utilisé lors de ta toute première connexion).
4. Enregistre.

## 3. Récupérer les clés

**Project Settings** > **API** (ou *API Keys*) : copie l’**URL du projet** et la clé **anon** (ou *publishable*).
Ouvre `index.html` et remplace les deux valeurs en haut du fichier :

```js
window.SUPABASE_URL = "https://xxxx.supabase.co";
window.SUPABASE_ANON_KEY = "eyJ...";
```

Cette clé est faite pour être publique : ce sont les règles de sécurité de l’étape 1 qui protègent les données.
N’utilise jamais la clé *service_role* / *secret* dans ce fichier.

## 4. Mettre le site en ligne avec GitHub Pages

1. Crée un compte sur https://github.com, puis **New repository** (par ex. `journal-sante`), visibilité **Public**
   (GitHub Pages gratuit exige un dépôt public ; seul le code est visible, jamais tes données).
2. **Add file** > **Upload files** : dépose `index.html` (tu peux ajouter `schema.sql` et ce README), puis **Commit**.
3. **Settings** > **Pages** > *Build and deployment* : Source **Deploy from a branch**, branche **main**, dossier **/ (root)**, **Save**.
4. Après une minute, ton site est disponible à `https://TON-PSEUDO.github.io/journal-sante/`.

## 5. Relier Supabase au site

**Authentication** > **URL Configuration** : mets l’adresse GitHub Pages dans **Site URL** et ajoute-la aussi dans **Redirect URLs**.

## 6. Première connexion puis verrouillage

1. Ouvre le site, saisis ton e-mail, reçois le code, valide. Fais pareil sur ton ordi.
2. Sur le téléphone, ajoute la page à l’écran d’accueil (Safari : Partager > Sur l’écran d’accueil ; Chrome : menu > Ajouter à l’écran d’accueil).
3. **Important** : une fois tes appareils connectés, va dans **Authentication** > **Sign In / Providers** (ou *Settings*)
   et désactive **Allow new users to sign up**. Plus personne d’autre ne pourra créer de compte sur ton journal.

La session reste ouverte : tu n’auras plus à te reconnecter, sauf si tu cliques sur « Se déconnecter » ou vides les données du navigateur.

## Bon à savoir

- **Mise en veille** : sur l’offre gratuite, Supabase met en pause un projet sans activité pendant 7 jours. Avec une saisie quotidienne, ça n’arrive pas ; sinon, un clic sur *Restore* dans le tableau de bord suffit, sans perte de données.
- **Export** : les boutons Excel et CSV en bas de la page génèrent le fichier d’analyse (onglets Journal, Activites, Aliments, Symptomes, Lisez-moi).
- **SQL direct** : dans Supabase, la vue `journal_plat` donne une table lisible ; l’export CSV du *Table Editor* fonctionne aussi.
- **Modifier la page** : édite `index.html` directement sur GitHub (icône crayon), le site se met à jour en une minute.
- **Sauvegarde** : un export Excel de temps en temps garde une copie hors ligne de tes données.
