# default - History
## Tags
* [LATEST - 10 May, 2016 (92edeb28)](#LATEST)
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
### <a name = "LATEST">LATEST - 10 May, 2016 (92edeb28)

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
