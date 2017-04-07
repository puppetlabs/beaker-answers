# worker - History
## Tags
* [LATEST - 7 Apr, 2017 (297e2195)](#LATEST)
* [0.15.0 - 22 Mar, 2017 (9df229c3)](#0.15.0)
* [0.14.0 - 19 Jan, 2017 (290c75b2)](#0.14.0)
* [0.13.0 - 9 Nov, 2016 (729ddd0b)](#0.13.0)
* [0.12.0 - 28 Oct, 2016 (b18d96b7)](#0.12.0)
* [0.11.0 - 22 Aug, 2016 (39591691)](#0.11.0)
* [0.10.0 - 15 Aug, 2016 (30507062)](#0.10.0)
* [0.9.0 - 1 Aug, 2016 (551ce473)](#0.9.0)
* [0.8.0 - 28 Jun, 2016 (d56e6ba8)](#0.8.0)
* [0.7.0 - 21 Jun, 2016 (993cf93a)](#0.7.0)
* [0.6.0 - 15 Jun, 2016 (a0800e46)](#0.6.0)
* [0.5.2 - 6 Jun, 2016 (bb16b018)](#0.5.2)
* [0.5.1 - 26 May, 2016 (c74a3fec)](#0.5.1)
* [0.5.0 - 26 May, 2016 (c802e883)](#0.5.0)
* [0.4.3 - 10 May, 2016 (5ffdb5f2)](#0.4.3)
* [0.4.2 - 28 Apr, 2016 (79ccd5de)](#0.4.2)
* [0.4.1 - 28 Apr, 2016 (d9d14510)](#0.4.1)
* [0.4.0 - 12 Feb, 2016 (96d0d7cf)](#0.4.0)
* [0.3.2 - 10 Nov, 2015 (f699c033)](#0.3.2)
* [0.3.1 - 2 Nov, 2015 (e5922067)](#0.3.1)
* [0.3.0 - 22 Oct, 2015 (0c56067d)](#0.3.0)
* [0.2.2 - 1 Sep, 2015 (6c5d8035)](#0.2.2)
* [0.2.1 - 31 Aug, 2015 (5aa509e2)](#0.2.1)
* [0.2.0 - 31 Aug, 2015 (6447f9bc)](#0.2.0)
* [0.1.0 - 26 Aug, 2015 (ef47972d)](#0.1.0)

## Details
### <a name = "LATEST">LATEST - 7 Apr, 2017 (297e2195)

* (GEM) update beaker-answers version to 0.16.0 (297e2195)

* Merge pull request #34 from demophoon/task/master/pe-20023-hoyt-pipeline (964be80f)


```
Merge pull request #34 from demophoon/task/master/pe-20023-hoyt-pipeline

(PE-20023) Update beaker answers for Hoyt
```
* (PE-20023) Add specs to hoyt answer generation (97050662)

* (PE-20023) Update beaker answers for Hoyt (25cc1a80)

### <a name = "0.15.0">0.15.0 - 22 Mar, 2017 (9df229c3)

* (HISTORY) update beaker-answers history for gem release 0.15.0 (9df229c3)

* (GEM) update beaker-answers version to 0.15.0 (9b17618d)

* Merge pull request #32 from demophoon/fix/master/pe-19948-windows-platform-fix (16a8f697)


```
Merge pull request #32 from demophoon/fix/master/pe-19948-windows-platform-fix

(PE-19948) Fix pe_repo platform class for windows
```
* (PE-19948) Update spec tests to catch windows platform regressions (221464d0)


```
(PE-19948) Update spec tests to catch windows platform regressions

This commit modifies the split configuration for generating pe.conf so
that it includes a windows agent.
```
* (PE-19948) Fix pe_repo platform class for windows (a878195d)


```
(PE-19948) Fix pe_repo platform class for windows

Before this commit the pe_repo platform class that would be generated
for all windows platforms would be incorrect as there is only a single
windows puppet agent. When this method would generate the list of
platform classes windows would be incorrect.

This commit ensures that when windows is a platform on a host we return
one of the two possible windows pe_repo platform classes.
```
### <a name = "0.14.0">0.14.0 - 19 Jan, 2017 (290c75b2)

* (HISTORY) update beaker-answers history for gem release 0.14.0 (290c75b2)

* (GEM) update beaker-answers version to 0.14.0 (2aaa08e1)

* Merge pull request #31 from jpartlow/issue/master/pe-19203-revert-meep-classification (f4d3c6ee)


```
Merge pull request #31 from jpartlow/issue/master/pe-19203-revert-meep-classification

(PE-19203,PE-16706) Revert meep classification from Flanders
```
* (PE-19203) Only generate 1.0 pe.conf in 20171 (49a7230b)


```
(PE-19203) Only generate 1.0 pe.conf in 20171

...and move pe.conf generation based on meep_schema_version flag into
2017.2 which is the first version where we'll be testing with variable
pe-modules packages.
```
* (PE-16706) Add a 2017.2 version (8eed8fb7)

* (PE-19203,PE-17621) Generate a meep 2.0 format based on version flag (29e2dff3)


```
(PE-19203,PE-17621) Generate a meep 2.0 format based on version flag

Previously there was a hard version break set on PE 2017.1 which would
produce a 2.0 format pe.conf, but since we've had to back out meep
classification in Flanders, this needs to change.

Added a PeConf object to generate 1.0 and 2.0 format files based on a
meep_schema_version flag. It defaults to the original 1.0 format. It
will be up to beaker-pe to submit this flag in the beaker options based
on its use_meep_for_classification?() test.

There is one change to the 1.0 hiera_host_config implementation in that
it no longer uses answer_for to set the master, db, console settings. I
don't think this matters because there are no defaults for these
settings, and beaker answer overrides are merged afterwards in
generate_hiera_config() regardless.
```
* Merge pull request #29 from kevpl/docs_README_fill (760e80c9)


```
Merge pull request #29 from kevpl/docs_README_fill

(MAINT) fill README with Rubydocs & release info
```
* (MAINT) fill README with Rubydocs & release info (45a853ec)


```
(MAINT) fill README with Rubydocs & release info

[skip ci]
```
### <a name = "0.13.0">0.13.0 - 9 Nov, 2016 (729ddd0b)

* (HISTORY) update beaker-answers history for gem release 0.13.0 (729ddd0b)

* (GEM) update beaker-answers version to 0.13.0 (f415b5e1)

* Merge pull request #28 from jpartlow/issue/2017.1.x/pe-17621-beaker-answers-generates-meep-node-roles (9becfcb3)


```
Merge pull request #28 from jpartlow/issue/2017.1.x/pe-17621-beaker-answers-generates-meep-node-roles

(PE-17621) Beaker answers generates meep node roles
```
* (PE-17621) Validate both old and new formats (138e7780)


```
(PE-17621) Validate both old and new formats

in the corresponding PE version tests.
```
* (PE-17621) Generate node_roles in 2017.1+ pe_conf (ea795b85)


```
(PE-17621) Generate node_roles in 2017.1+ pe_conf

MEEP 2.0 introduces a node_roles hash in pe.conf for classification.
This supercedes using the puppet_enterprise host parameters as a de
facto classification.  The Version20171 class maps existing beaker role
aliases to the new role strings used for classification in pe.conf.

So, from a MEEP 1.0 version pe.conf such as:

  {
    "puppet_enterprise::puppet_master_host": "master.net"
    "puppet_enterprise::puppetdb_host": "puppetdb.net"
    "puppet_enterprise::console_host": "console.net"
  }

You now have a 2.0 version that looks like:

  {
    "node_roles": {
      "pe_role::split::primary_master": ["master.net"]
      "pe_role::split::puppetdb": ["puppetdb.net"]
      "pe_role::split::console": ["console.net"]
    }
  }

See the pe_manager and pe_infrastructure modules for more details.
```
* (PE-17621) Move shared examples into a separate file (30e27482)


```
(PE-17621) Move shared examples into a separate file

...included by default in spec_helper.rb. Without this, running the
version20163_spec.rb by itself fails.
```
### <a name = "0.12.0">0.12.0 - 28 Oct, 2016 (b18d96b7)

* (HISTORY) update beaker-answers history for gem release 0.12.0 (b18d96b7)

* (GEM) update beaker-answers version to 0.12.0 (4e1716ad)

* Merge pull request #27 from demophoon/task/master/pe-18147-flanders-answers (ae6f6d69)


```
Merge pull request #27 from demophoon/task/master/pe-18147-flanders-answers

(PE-18147) Add Flanders answers to beaker-answers.
```
* (PE-18147) Add Flanders answers to beaker-answers. (6831dc9c)

### <a name = "0.11.0">0.11.0 - 22 Aug, 2016 (39591691)

* (HISTORY) update beaker-answers history for gem release 0.11.0 (39591691)

* (GEM) update beaker-answers version to 0.11.0 (5ba11820)

* Merge pull request #26 from demophoon/ಠ_ಠ/master/pe-17078-recreate-everett-pipelines (74c2cffc)


```
Merge pull request #26 from demophoon/ಠ_ಠ/master/pe-17078-recreate-everett-pipelines

(PE-17078) Create Everett Pipelines, Part II
```
* (PE-17078) Create Everett Pipelines, Part II (21d81654)


```
(PE-17078) Create Everett Pipelines, Part II

Groundhog Day
```
### <a name = "0.10.0">0.10.0 - 15 Aug, 2016 (30507062)

* (HISTORY) update beaker-answers history for gem release 0.10.0 (30507062)

* (GEM) update beaker-answers version to 0.10.0 (82c266b0)

* Merge pull request #25 from demophoon/task/master/pe-17078-create-everett-pipeline (b74b6343)


```
Merge pull request #25 from demophoon/task/master/pe-17078-create-everett-pipeline

(PE-17078) Add answers file for Everett
```
* (PE-17078) Add answers file for Everett (9bff1e9e)

### <a name = "0.9.0">0.9.0 - 1 Aug, 2016 (551ce473)

* (HISTORY) update beaker-answers history for gem release 0.9.0 (551ce473)

* (GEM) update beaker-answers version to 0.9.0 (1da88528)

* Merge pull request #24 from highb/fix/master/PE-16772_remove_app_orch_from_20163x (fbadab45)


```
Merge pull request #24 from highb/fix/master/PE-16772_remove_app_orch_from_20163x

(PE-16772) Remove app_orch from 20163x answers
```
* (PE-16772) Remove app_orch from 20163x answers (3a7c2164)


```
(PE-16772) Remove app_orch from 20163x answers

`puppet_enterprise::use_application_services` is deprecated in 2016.3.x,
so we should no longer specify it.
```
### <a name = "0.8.0">0.8.0 - 28 Jun, 2016 (d56e6ba8)

* (HISTORY) update beaker-answers history for gem release 0.8.0 (d56e6ba8)

* (GEM) update beaker-answers version to 0.8.0 (e29fe388)

* Merge pull request #23 from demophoon/fix/master/pe-16065-38-upgrade-puppetdb-hostname (16271feb)


```
Merge pull request #23 from demophoon/fix/master/pe-16065-38-upgrade-puppetdb-hostname

(PE-16065) Do not fall back to ip address when setting puppetdb hostname
```
* (PE-16065) Do not fall back to ip address when setting puppetdb hostname (effd8f21)


```
(PE-16065) Do not fall back to ip address when setting puppetdb hostname

Before this commit the puppetdb hostname answer would fallback to being
an ip address which would cause the installer to do incorrect things as
we depend on those answers to be hostnames for certificate generation
and configuration bootstrap purposes.

This commit changes the q_puppetdb_hostname answer to be the hostname of
the puppetdb node instead of its ip address which is returned by the
reachable_name method on the host object.
```
### <a name = "0.7.0">0.7.0 - 21 Jun, 2016 (993cf93a)

* (HISTORY) update beaker-answers history for gem release 0.7.0 (993cf93a)

* (GEM) update beaker-answers version to 0.7.0 (006c1921)

* Merge pull request #22 from sathlan/bug/ENTERPRISE-910 (b6ab97cd)


```
Merge pull request #22 from sathlan/bug/ENTERPRISE-910

(ENTERPRISE-910) Unpin hocon
```
* (ENTERPRISE-910) Unpin hocon (566aab6a)


```
(ENTERPRISE-910) Unpin hocon

hocon < 1 is not compatible with infraspec 2.59.1.  This push it to ~1.0
to match beaker declaration and have infraspec working again.
```
### <a name = "0.6.0">0.6.0 - 15 Jun, 2016 (a0800e46)

* (HISTORY) update beaker-answers history for gem release 0.6.0 (a0800e46)

* (GEM) update beaker-answers version to 0.6.0 (7ffb00c1)

* Merge pull request #21 from demophoon/task/master/pe-14555-meep-cutover (45c36f80)


```
Merge pull request #21 from demophoon/task/master/pe-14555-meep-cutover

(PE-14555) Remove bash answers for 2016.2.0
```
* (PE-14555) Remove bash answers for 2016.2.0 (7d0c9b35)


```
(PE-14555) Remove bash answers for 2016.2.0

Prior to this commit we allowed generating either hiera or bash answers
for 2016.2.0.

This commit removes the bash answers, because future builds of 2016.2.0
will not accept them.
```
### <a name = "0.5.2">0.5.2 - 6 Jun, 2016 (bb16b018)

* (HISTORY) update beaker-answers history for gem release 0.5.2 (bb16b018)

* (GEM) update beaker-answers version to 0.5.2 (8f6a39db)

* Merge pull request #19 from ericwilliamson/task/master/PE-16028-update-for-mono (97409f9c)


```
Merge pull request #19 from ericwilliamson/task/master/PE-16028-update-for-mono

(PE-16028) Update required answers for 2016.2
```
* (PE-16028) Update required answers for 2016.2 (ba130df3)


```
(PE-16028) Update required answers for 2016.2

Previous to this commit, answer generation for 2016.2 would generate a
list of parameters on the puppet_enterprise for both mono and split. Due
to changes introduced in Puppet 4.4, the puppet_enterprsie module no
longer needs all host parameters in a monolithic install case.
This commit updates the generation to match what the module has changed
to use. For a monolithic install, the only required answers are now the
console admin password, and puppet_master_host. for split installs with
PE postgres, just master, console and puppetdb host.
```
### <a name = "0.5.1">0.5.1 - 26 May, 2016 (c74a3fec)

* (HISTORY) update beaker-answers history for gem release 0.5.1 (c74a3fec)

* (GEM) update beaker-answers version to 0.5.1 (31f5b82c)

* Merge pull request #18 from tvpartytonight/BKR-825 (61372ae3)


```
Merge pull request #18 from tvpartytonight/BKR-825

(BKR-825) Add BKR answers for 2016.3
```
* (BKR-825) Add BKR answers for 2016.3 (ec519b04)

### <a name = "0.5.0">0.5.0 - 26 May, 2016 (c802e883)

* (HISTORY) update beaker-answers history for gem release 0.5.0 (c802e883)

* (GEM) update beaker-answers version to 0.5.0 (3045251c)

* Merge pull request #16 from highb/feature/master/pe-14996_add_hiera_answers (e724b683)


```
Merge pull request #16 from highb/feature/master/pe-14996_add_hiera_answers

(PE-14996) Add hiera type answer/config generation
```
* (PE-14996) Ensure flatten_keys_to_joined_string generates strings (bdbd3c2a)


```
(PE-14996) Ensure flatten_keys_to_joined_string generates strings

Prior to this commit I didn't ensure that keys being given in hashes
to `flatten_keys_to_joined_string` were being converted to strings.
This would result in keys that were passed in as symbols acting as a
duplicate key to the string equivalent, which were then written out
by the json/hocon parsers because it seems they do not have a uniqueness
constraint on keys in hashes.
This commit changes `flatten_keys_to_joined_string` to always convert
the keys to strings, which should prevent this sort of duplicate key
issue.
```
* (PE-15259) Only include legacy database user defaults if prompted (6748295e)


```
(PE-15259) Only include legacy database user defaults if prompted

If beaker-pe initializes BeakerAnswers with an
:include_legacy_database_defaults, then add custom database users from
BeakerAnswers::DEFAULT_ANSWERS.  This is only necessary if we are
upgrading from a pre-meep Beaker install of PE where BeakerAnswers
changed the default user names.

Setting the old legacy database password defaults is never required.

To override any of these settings, they should be added directly to the
:answers hash in the host.cfg file.
```
* (maint) Include Gemfile.local (af435a64)


```
(maint) Include Gemfile.local

Allows addition gems (such as a debugger) to be included for development
without accidentally commiting them.
```
* (PE-14996) Verify answers for default, cert auth and upgrade cases (fd1f8014)


```
(PE-14996) Verify answers for default, cert auth and upgrade cases

Fixes a spec failure that occurred from
c4556d8e455617c84ce3faf805a34fbee25bac92 given that database name/user
were no longer present by default.  Also changes the specs to explicitly
define hashes of expected values so we don't miss any changes
(use_application_services wasn't being tested, for example), and hard
codes expected constants so that we don't have false positives from both
expectations and results coming indirectly from internal code references and
accidentally matching.
```
* (PE-14996) Change upgrade answers spec to be literal strings (f996c1b5)


```
(PE-14996) Change upgrade answers spec to be literal strings

Even though we reverted the DEFAULT_ANSWERS change to no longer have
quotes within the answer values, the spec tests were still passing, even
though they would generate erroneous answers for the
puppetdb_database_password. This change makes it so that the tests are
testing for literal strings, as opposed to just ensuring the calculation
for the answer happens.
```
* (PE-14996) Guard addition of database_name, database_user by upgrade (c4556d8e)


```
(PE-14996) Guard addition of database_name, database_user by upgrade

BeakerAnswers historically sets database user/name to non default
values.  Typically a user will not do this, and it complicates our
default workflow and subsequent upgrades.  For meep, with this commit,
I'm ignoring the database name/user settings if we're not upgrading.
The reason they are needed on upgrade (currently only from pre-meep
versions), is that a legacy install laid down by Beaker will have these
database settings, and we have to have them in pe.conf when upgrading,
or database access fails.

When upgrading from a meep install (2016.2.1+), a pe.conf should not be
created, and beaker-pe should just call the installer-shim with no
pe.conf file. https://tickets.puppetlabs.com/browse/PE-15351
```
* (PE-14996) Generate hiera host references from vm.hostname (f005f3f9)


```
(PE-14996) Generate hiera host references from vm.hostname

...instead of name.  The later is simple the YAML key for the host from
the Beaker hosts.cfg file, while the former, in the case of vmpooler
hosts, is the actual hostname from the generated vm.  It is this
hostname that is required for a working pe.conf.
```
* (PE-14996) Treat q_puppetdb_database_password default same as others (40b5f9a8)


```
(PE-14996) Treat q_puppetdb_database_password default same as others

181305f6ba6116d05c8163eb2a18243df30098d0 changed beaker-answers so that
the puppetdb default was referenced by its answer
q_puppetdb_database_password, rather than the key q_puppetdb_password,
which is not used in the legacy answer file.  Due to how answer_for()
works, where an existing value looked up from DEFAULTS prevents the
passed default override from being used, this caused the generated
answer for puppetdb to added without quotes. To fix this, quotes were
added to the default.  This worked, but it ran counter to how the later
database answers for classifier, rbac, activity and orchestrator
database passwords were handled.  These had defaults without quotes, and
then explicitly quoted the derived answers generated for the
answers_hash.

When we began using answers for generating a hiera config for meep, this
caused problems with the puppetdb password because the quotes in the
puppetdb default ended up in the json value, causing an error in
Postgres.

To fix this, and to unify q_puppetdb_database_password's handling with
that of the other db passwords, this commit removes the quoting in the
defaults, and adds it to the generation of the final
q_puppetdb_database_password answer.  It also modified a spec that was
testing the generation of this answer to take into account that the
quotes are added by the answer generation process.
```
* (PE-14996) Fix test for legacy answers in hiera_config to handle symbols (1e8d51f8)


```
(PE-14996) Fix test for legacy answers in hiera_config to handle symbols

Beaker configs in this format:

:answers:
  :q_puppet_enterpriseconsole_auth_password: puppetlabs
  :q_puppet_enterpriseconsole_auth_user_email: admin@puppetlabs.net
CONFIG:
  log_level: debug
HOSTS:
  master.vm:
    platform: el-7-x86_64
...

where legacy answers are provided to be slurped into Beaker options and
passed on to BeakerAnswers, were failing when BeakerAnswers was
attempting to produce a 2016.2.x hiera config for meep.  This was just
because the test was assuming strings for keys instead of symbols.  The
patch converts to string before testing and adds a spec.
```
* (PE-14996) Prefer let() to instance variables (d8eec98d)


```
(PE-14996) Prefer let() to instance variables

Makes use of rspec's let method instead of instance variables for
consistency.  Also removes extraneous 'should' from spec names.
```
* (PE-14996) Update q_puppetdb_password to q_puppetdb_database_password (040601c1)


```
(PE-14996) Update q_puppetdb_password to q_puppetdb_database_password

PR #15 changed the name of the puppetdb database password key in the
default hash. This commit will update the hiera default hash (which
reads values from the original defaults hash in order to reduce
duplication) to use the correct key from the old default hash.
```
* (PE-14996) Remove duplicate default key (8a22b338)


```
(PE-14996) Remove duplicate default key

There were two entries for `puppetdb_database_name` in the defaults
array. This shouldn't cause any issues, but also doesn't do anything
so I'm cleaning it up.
```
* Merge pull request #15 from tvpartytonight/BKR-763 (50589d17)


```
Merge pull request #15 from tvpartytonight/BKR-763

(BKR-763) Add upgrade answers for PE 3.8.x
```
* (PE-14996) Provide a format agnostic method for configuration string (9209aa3b)


```
(PE-14996) Provide a format agnostic method for configuration string

With the changes in installer configuration format, Version201620 now
has an answer_hiera method.  However the component using beaker-answers
shouldn't have to care about which output method it calls to get a
configuration.  Ultimately it should just expect the correct
configuration for a given PE version.  To assist with this, this commit
adds an installer_configuration_string(host) method which will return
either an answer file string or a hiera pe.conf string depending on the
:format setting.

Because no version prior to 2016.2.0 can work with a hiera pe.conf, I've
moved the implementation into Version201620 and left an erroring stub in
Answers.
```
* (PE-14996) Use :format in options instead of @type as param (0cf01296)


```
(PE-14996) Use :format in options instead of @type as param

Prior to this commit I was adding a type param to the init/create
methods of `Answers` in order to specify which answers file type
to generate. Using the word type, which is already used to specify
`:install` vs `:upgrade`, and creating a whole new param were
somewhat counter-intuitive and confusing.

This commit removes the type param, and instead reads the `:format`
key from the `options` hash upon initialization, and if it cannot find
a value at that key, it will default to `:bash`. I went back to using
`:format` in order to reduce the chance of us later being confused
by the `:type` option and decided to use the options hash because that
is how we have typically interacted with the `Answers` library in the
past. This should hopefully be a more intuitive and less error prone
way of interacting with the library. Fingers crossed.
```
* (PE-14996) Use case for determining answer type (3b9838f3)


```
(PE-14996) Use case for determining answer type

Prior to this commit we were using a series of if statements
when checking if we support the answer `type` provided.
This commit changes those checks to use a case statement in order
to clean up the logic. Additionally, more exceptions will be raised
if methods are called with an unknown `type`.
```
* (PE-14996) Move hocon/json include to base BeakerAnswers lib (60ae45b0)


```
(PE-14996) Move hocon/json include to base BeakerAnswers lib

Prior to this commit we were requiring the json/hocon libs only
in the `Answers` class.
This commit moves those requires to the base `BeakerAnswers`, so
we can re-use those libraries elsewhere without needing to require
them.
```
* (PE-14996) Add specs for #answers_hiera and #answers_string (6a546add)


```
(PE-14996) Add specs for #answers_hiera and #answers_string

Prior to this commit we were not spec testing `answers_hiera` or
`answers_string`.

This commit adds specs for both to the 20162 answers class, as well
as resolving an issue found in code review/spec testing with
the `answer_hiera` method.
```
* (PE-14996) Further refactor default config generation (37c76194)


```
(PE-14996) Further refactor default config generation

Prior to this commit there was a large amount of duplicate code
used for getting the `answer_for` for each key.

This commit refactors that duplicate code out into a method on
the Answers class that takes an array of desired defaults and
returns an array with either the default from the Answers class
or the user-provider override.

Additionally, instead of them hiera answers, we should be calling
them hiera config in order to be consistent with how we are documenting
them and what they really are; persistent configuration that will be
saved on the system.
```
* (PE-14996) Abstract bash vs hiera answer generation logic (86ea430b)


```
(PE-14996) Abstract bash vs hiera answer generation logic

Prior to this commit the bash and hiera answer generation logic were
all crammed into the `generate_answers` method on 20162.
This commit abstracts the bash and hiera answer generation logic into
two separate methods: `generate_bash_answers` and
`generate_hiera_answers`. This should make the answers generation a
little easier to follow.
```
* (PE-14996) Update format variable to type (ffcb41ec)


```
(PE-14996) Update format variable to type

Prior to this commit I forgot to change all the instances of the
variable I originally named `format` to `type`.
This commit fixes one of the instances I missed and I grepped the
project to ensure there were no others.
```
* (PE-14996) Add DB user/name to default hiera configs (5627a94a)


```
(PE-14996) Add DB user/name to default hiera configs

Prior to this commit we were not specifying the old default
DB user/names in the hiera configs, which could result in tests
that depend on those names to fail. Additionally, it is a good
idea to verify that specifying a non-default database name still
works.
This commit specifies puppetdb, classifier, activity, rbac and
orchestrator database names by default for the 2016.2 hiera
config/answer files. console/console_auth are omitted because
those databases are deprecated in 2016.2.

Also fixed a typo where `q_database_name` was specified in the
defaults hash instead of `q_classifier_database_name` and fixed
the only reference to that (from 3.4).
```
* (PE-14996) Prevent q_ answer overrides in hiera (8e9f4202)


```
(PE-14996) Prevent q_ answer overrides in hiera

Prior to this commit if a user was still providing `q_` style
answer overrides, we would still add them to the hash.
This commit changes that behavior to raise an exception if a `q_`
answer is provided when we are generating hiera style answers.
```
* (PE-14996) Allow overrides of 2016.2 hiera answers (3bee87d2)


```
(PE-14996) Allow overrides of 2016.2 hiera answers

Prior to this commit there was not method for overriding the
default answers given for the new 2016.2 hiera answer format.
This commit adds a method of overriding those answers via providing
a hash to `options[:answers]` containing all the hiera values that
you wish to override or add.
```
* (PE-14996) Add initial work for 2016.2 hiera answers (2638e57a)


```
(PE-14996) Add initial work for 2016.2 hiera answers

Initial commit based off @ericwilliamson prototype code for
generating hiera answers for 2016.2 meep/idempotent installs.

Added initial spec tests to verify hash generation is adding the
correct values.
```
* (BKR-763) Add upgrade answers for PE 3.8.x (181305f6)


```
(BKR-763) Add upgrade answers for PE 3.8.x

This PR specifically targets answers for upgrading to PE 3.8.x. It adds
a new subclassed branch directly from `Answers` and looks for the
`options[:type][:upgrade]` option from beaker. All other upgrade types
will continue to create full answer sets.
```
### <a name = "0.4.3">0.4.3 - 10 May, 2016 (5ffdb5f2)

* (HISTORY) update beaker-answers history for gem release 0.4.3 (5ffdb5f2)

* (GEM) update beaker-answers version to 0.4.3 (92edeb28)

* Merge pull request #14 from ericwilliamson/task/master/legacy-ssl-auth-support (bef1af14)


```
Merge pull request #14 from ericwilliamson/task/master/legacy-ssl-auth-support

(PE-14877) Pass in orchestrator db to console
```
* (PE-14877) Pass in orchestrator db to console (f1d09078)


```
(PE-14877) Pass in orchestrator db to console

To allow SSL cert based auth in the new installer while maintaining the legacy
bash script, the console node now needs to know about the orchestrator database user
and name if they are specified to be non default
```
### <a name = "0.4.2">0.4.2 - 28 Apr, 2016 (79ccd5de)

* (HISTORY) update beaker-answers history for gem release 0.4.2 (79ccd5de)

* (GEM) update beaker-answers version to 0.4.2 (331f9d3e)

* Merge pull request #13 from tvpartytonight/BKR-763 (0d363027)


```
Merge pull request #13 from tvpartytonight/BKR-763

Revert "(BKR-763) Supply only necessary answers on upgrade"
```
* Revert "(BKR-763) Supply only necessary answers on upgrade" (8647174a)


```
Revert "(BKR-763) Supply only necessary answers on upgrade"

This reverts commit 5b1e9782de49e80fa3d02e0854626589791e6d26.
```
### <a name = "0.4.1">0.4.1 - 28 Apr, 2016 (d9d14510)

* (HISTORY) update beaker-answers history for gem release 0.4.1 (d9d14510)

* (GEM) update beaker-answers version to 0.4.1 (32ef620e)

* Merge pull request #11 from tvpartytonight/BKR-763 (554f0405)


```
Merge pull request #11 from tvpartytonight/BKR-763

(BKR-763) Supply only necessary answers on upgrade
```
* (BKR-763) Supply only necessary answers on upgrade (5b1e9782)


```
(BKR-763) Supply only necessary answers on upgrade

Previous to this commit, answer files were generated in full during
upgrade scenarios; this does not match the user workflow or what is
documented for upgrades, so we should only supply answers needed. The
answers `create` method now checks the `:type` in options and creates a
separate branch of `Answers` named `Upgrade`.

This change only affects PE 3.8 and higher; all lower versions will
continue to produce an entire answers file.
```
### <a name = "0.4.0">0.4.0 - 12 Feb, 2016 (96d0d7cf)

* (HISTORY) update beaker-answers history for gem release 0.4.0 (96d0d7cf)

* (GEM) update beaker-answers version to 0.4.0 (3577bbf2)

* Merge pull request #9 from kevpl/bkr700_20162_base (f33b9fae)


```
Merge pull request #9 from kevpl/bkr700_20162_base

(BKR-700) added base answers for 2016.2
```
* (BKR-700) added base answers for 2016.2 (50d0bb30)

### <a name = "0.3.2">0.3.2 - 10 Nov, 2015 (f699c033)

* (HISTORY) update beaker-answers history for gem release 0.3.2 (f699c033)

* (GEM) update beaker-answers version to 0.3.2 (fbcdbd73)

* Merge pull request #8 from highb/maint/app_services_on_console (6d3ad2b2)


```
Merge pull request #8 from highb/maint/app_services_on_console

(PE-12849) Add q_use_application_services to console
```
* (PE-12849) Update specs, remove unnecessary string (85945826)


```
(PE-12849) Update specs, remove unnecessary string

Prior to this commit there were no specs to test the
`q_use_application_services` answer on 2015.3.
This commit adds specs for that answer, as well as
de-quoting the answer.
```
* (PE-12849) Add q_use_application_services to console (44fa342b)


```
(PE-12849) Add q_use_application_services to console

Both the master and console must be given the
`q_use_application_services` answer, since the console
needs to know that it needs classify the orchestrator.
```
### <a name = "0.3.1">0.3.1 - 2 Nov, 2015 (e5922067)

* (HISTORY) update beaker-answers history for gem release 0.3.1 (e5922067)

* (GEM) update beaker-answers version to 0.3.1 (367ecd87)

* Merge pull request #7 from demophoon/answer/master/app-services (14a247c2)


```
Merge pull request #7 from demophoon/answer/master/app-services

(maint) Add q_use_application_services question
```
* (maint) Add q_use_application_services question (91210f8b)


```
(maint) Add q_use_application_services question

Currently in integration CI all installs are not setting the
q_use_application_services answer. When that answer is set to nothing
the pe-classification script does not enable application services.
```
### <a name = "0.3.0">0.3.0 - 22 Oct, 2015 (0c56067d)

* (HISTORY) update beaker-answers history for gem release 0.3.0 (0c56067d)

* (GEM) update beaker-answers version to 0.3.0 (5abaf7e5)

* Merge pull request #6 from objectverbobject/BKR-591/add_support_for_2016.1 (fa50896a)


```
Merge pull request #6 from objectverbobject/BKR-591/add_support_for_2016.1

(BKR-549) Add answers for 2016.1
```
* (BKR-549) Add answers for 2016.1 (6211780b)


```
(BKR-549) Add answers for 2016.1

This is just to get the initial pipelines up and running; there are no
answers new to 2016.1 yet, so it will just inherit the_answers generated
by Version20153.
```
### <a name = "0.2.2">0.2.2 - 1 Sep, 2015 (6c5d8035)

* (HISTORY) update beaker-answers history for gem release 0.2.2 (6c5d8035)

* (GEM) update beaker-answers version to 0.2.2 (33430738)

* Merge pull request #5 from nicklewis/master-requires-database-host (17ff153b)


```
Merge pull request #5 from nicklewis/master-requires-database-host

(APPMGMT-882) Set q_database_host answer on master
```
* (APPMGMT-882) Set q_database_host answer on master (fcd44f68)


```
(APPMGMT-882) Set q_database_host answer on master

The master now needs to find the database host in order to setup the
orchestrator.
```
### <a name = "0.2.1">0.2.1 - 31 Aug, 2015 (5aa509e2)

* (HISTORY) update beaker-answers history for gem release 0.2.1 (5aa509e2)

* (GEM) update beaker-answers version to 0.2.1 (42b63e85)

* Merge pull request #4 from nicklewis/APPMGMT-881-orchestrator-answers (5a69e505)


```
Merge pull request #4 from nicklewis/APPMGMT-881-orchestrator-answers

Properly quote q_orchestrator_database_password answer
```
* Properly quote q_orchestrator_database_password answer (26e76b03)


```
Properly quote q_orchestrator_database_password answer

Because bash
```
### <a name = "0.2.0">0.2.0 - 31 Aug, 2015 (6447f9bc)

* (HISTORY) update beaker-answers history for gem release 0.2.0 (6447f9bc)

* (GEM) update beaker-answers version to 0.2.0 (9448d177)

* Merge pull request #3 from nicklewis/APPMGMT-881-orchestrator-answers (40b8bed9)


```
Merge pull request #3 from nicklewis/APPMGMT-881-orchestrator-answers

(APPMGMT-882) Add orchestrator answers for 2015.3
```
* (APPMGMT-882) Add orchestrator answers for 2015.3 (a0e09a31)


```
(APPMGMT-882) Add orchestrator answers for 2015.3

This also updates Version40 answers to only support 2015.2, not 2015.3.
```
### <a name = "0.1.0">0.1.0 - 26 Aug, 2015 (ef47972d)

* Initial release.
