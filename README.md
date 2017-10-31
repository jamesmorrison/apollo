# Apollo

Apollo is designed to quickly and effortlessly run any PHP / HTML application locally - specifically Apollo was designed for WordPress development.

# Features

* Nginx (1.10.0)
* PHP 7.0 (7.0.22)
* MySQL (5.7)
* [Mailcatcher](#mailcatcher)
* [WP CLI ](https://wp-cli.org/)

# Installation

The installation guide can be found here: [Apollo Installation Guide](https://github.com/jamesmorrison/apollo/wiki/Installation)

Optionally, you can setup Dnsmasq to forward traffic to Apollo, this can be found here: [Setting up Dnsmasq](https://github.com/jamesmorrison/apollo/wiki/Setting-up-Dnsmasq)

# Usage

Once the installation is complete, you'll see a `sites` folder has been created in the `apollo` directory. Within this `sites` directory, you'll see 2 folders: `000-default` and `000-template`.

`000-default`

This directory contains a simple HTML file; this is the "fallback" used if you attempt to navigate to a URL on Apollo that hasn't been configured correctly. Assuming you haven't changed the primary IP, going to http://10.10.10.10 will show you this file.

`000-template`

You should see a copy of WordPress core here, including a `wp-config.php` file that is setup to work with Apollo. All you need to do with the `wp-config.php` file is change the `DB_NAME` and optionally, enable the multisite section if required.

## Creating a new site

To create a site, duplicate the `000-template` folder and rename to the domain you'd like to access the site with e.g. `site.dev` 

Requests passed to Apollo will look for a corresponding folder - i.e. if you create a folder called `site.dev` you would load this folder using http://site.dev; a request to http://bob.dev will look for a folder called `bob.dev` etc.

## Multisite support

Sub-domain WordPress multisite setups are fully supported out the box; requests to sub-domains are mapped to the parent folder. e.g. assuming you've created your `site.dev` folder; a request to http://sub.site.dev will load content from the `site.dev` folder.

Sub directory setups are also fully supported, including specific rewrite rules in the default Nginx configuration to handle rewrites for `wp-*` files to look in the parent folder. e.g. a request to http://site.dev/sub/wp-includes/file.css will load from http://site.dev/wp-includes/file.css if the file does not exist.

## Hosts

You will need to update your hosts file for each site you add, or (more conveniently) use [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) to automate this - e.g. point all `.dev` domains to Apollo.

A guide to setting up Dnsmasq for Aoollo can be found here: [Dnsmasq For Apollo](https://github.com/jamesmorrison/apollo/wiki/Installation)

## Other Notes

### Restarting system services

Every time you run `vagrant up`, 3 system services are restarted through inline scripts. These are **Nginx**, **MySQL** and **PHP-FPM**. If you find that a process has stopped working, you can restart these by running `vagrant up`, **even when the box is running**.

### Mailcatcher

[Mailcatcher](https://mailcatcher.me/) (as the name suggests) "catches" all email sent through Apollo. You can access this through port 1080 on any URL configured to point to Apollo (maybe just use http://10.10.10.10:1080 for simplicity).

This is automatic and starts every time Apollo is booted through `vagrant up`.

### HTTPS

Apollo has full support for HTTPS, however the certificate is not signed by a valid root certificate. This means that all sites you host locally will show as a security exception in your browser. Simply accepting this security exception will allow you to use https with your local sites with no issues.

### Multiple TLD's

Apollo supports all single level top level domains (TLD's) out the box (e.g. `.dev` / `.test` / `.local` etc.), as long as the DNS resolves to the Vagrant box. See the above guide for setting up Dnsmasq - change `.dev` to your custom extension as required.

Only the .co.uk multi-level TLD is supported out the box, however others can be added upon request - please raise an issue [here](https://github.com/jamesmorrison/apollo/issues/new)

### Multiple local instances of Apollo

As Apollo can support any TLD, it's possible to have multiple Apollo instances running on your system simultaneously.

If you wish to have multiple instances running, you'll need to change the IP in the VagrantFile for the second (or subsequent) instance.

As long as the correct domain resolves to the correct IP, the Apollo instances will work seamlessly together.
