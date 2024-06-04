<p align="center"><a href="https://formewp.github.io" target="_blank"><img src="https://formewp.github.io/logo.svg" width="400"></a></p>

# Forme Base

A Forme framework base server project boilerplate for local development and server deployment.

[Click here for Documentation](https://formewp.github.io)

## Description

This is pretty similar in scope to Bedrock, but it has a slightly different philosophy.

The main aims are:

1. Provide an easy to use boilerplate for use with Forme WordPress projects.
2. Put WordPress into a `public` web root directory, but otherwise leave the standard WP folder structure exactly as it is.
3. Use composer to manage WordPress plugins, WordPress themes and general PHP libraries, but NOT WordPress itself beyond the initial installation.
4. Not a mono repo. It's meant as a starting point for the _root_ part of your WordPress project. Your custom themes and plugins themselves should live in their own separate git repos and eventually be made available for composer via a Packagist or Satis repository.
5. Leverage npm workspaces to enable us to build assets across all themes and plugins.

You can use this for your local development environment or for deployments.

## Requirements

- A Unix machine/VM - Mac or Ubuntu - Windows is not supported. It might work a bit, but who knows.
- php 8.1 or higher
- composer 2
- wp cli for the automated configuration and installation
- wget and/or curl for the automated installation if you don't have wp cli
- node v18 (preferably via nvm)

## Getting Started

You can run `composer create-project forme/base project-name` to create a new project on your local machine. This will:

1. Install the latest version of WordPress into the `public` folder (requires wp cli, curl or wget)
2. Add the wp-packagist composer repository
3. Install the wikimedia merge plugin so that we can pull in plugin and theme dependencies into the main vendor folder
4. Add the correct installer paths for plugins and themes if pulled in via composer
5. Install ACF (not the pro version)
6. Install the Symfony var-dumper component
7. Install Whoops error Pages
8. Install WP debug bar
9. Initialise `wp-config.php`, including prompting for your DB credentials, adding the `FORME_PRIVATE_ROOT` const, setting `WP_ENV` to `development` and requiring autoload. (requires wp cli)
10. Create a blank `.env` file
11. Include `package.json` including basic workspaces configuration

You will then want to:

- Edit `.env` if need be
- Composer require any existing plugins or themes you need, or symlink local work into `wp-content` and `composer update`
- `git init` and then keep this in version control during development
- set up your wordpress site as usual in your browser or via `wp-cli`

You might need to delete `composer.lock` before installing any plugins or themes which depend on the merge plugin feature for the first time.

## Deployment

On a server you typically need to:

- `git clone` your repo to a new directory
- cd into the directory and run `composer setup-wordpress`
- Run `composer install` and any other local scripts you need
- Update `WP_ENV` in `public/wp-config.php` to something other than `development`
- Run `composer init-dotenv` and fill that in
- Make `public` the web root, or symlink `public` to your existing web root path

## Scripts

The following custom scripts are available via composer.

- `composer install-wordpress` - Install the latest version of WordPress into the `public` folder.
- `composer configure-wordpress` - Initialise `wp-config.php`, including adding the `FORME_PRIVATE_ROOT` const, setting `WP_ENV` to `development`
- `composer require-autoload` - Add require autoload in `wp-config.php`
- `composer init-dotenv` - Copy `.env.example` to `.env`
- `composer setup-wordpress` - Run all four of the above scripts

On `create-project` the `post-root-package-install` hook runs `setup-wordpress` and `init-dotenv` (i.e. all of the above)

On install and update, the `post-install-cmd` and `post-update-cmd` hooks run `npm i --omit=dev && npm run build -ws`. You may want to disable this on your local machine, especially if you're not symlinking your development themes and plugins, as it will run on every composer update.

## Workspaces

[npm Workspaces](https://docs.npmjs.com/cli/v10/using-npm/workspaces) allow us to install node packages and run asset builds from the server root across all plugins and themes, or more specifically, those whose directory name end with `-plugin` and `-theme` respectively (as is default for Forme), and that have a `package.json` with any necessary npm commands defined. The main `node_modules` directory should be in the root repo directory.

One thing to bear in mind is that this all runs naively, so if you have some third party plugin or theme installed whose directory name ends in `-plugin` or `-theme` that contains `npm` scripts, they _will_ run, which you might not want. Have a look at `package.json` if you need to change the configuration.

`npm install --omit=dev` will run across all matching themes and plugins.

`npm run build -ws` will run `build` in all matching themes and plugins.

These commands should run automatically on composer update/install, but you can also run them directly.

## Valet Driver

If you use Valet for local development, we've got a driver for that. You should `cp` this into your local valet configuration if you haven't already:

```sh
cp utils/FormeServerValetDriver.php ~/.config/valet/Drivers/FormeServerValetDriver.php
```

## Inlined Composer

If you have an existing vanilla WordPress installation for whatever reason, and you just want to set things up so you can use the Forme framework, or even just to use composer to manage your WordPress project dependencies, you can copy `utils/composer.json` into your project root folder. Again, this is one up from the public web root.

You might need to edit the file if your web root is not called `public`, just run a find and replace.

This version of the `composer.json` file includes the same scripts as the root version but inlined rather than relying on any external files. It is mainly included for convenience -  it means you can copy just this single file into another project without worrying about any of the other directories and files in here, and still have access to the commands listed above.

It's generated by `scripts/inline_composer.sh` - have a look in there if you're working on or forking this repo and need to add other shell scripts to inline.
