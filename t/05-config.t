#! /usr/bin/perl
# config file tester.

#########################

use strict;
use warnings;

use lib q(t);
use Testhelper;

my @tests;
push @tests, {
    'doc' => 'Single language, no pot no po',
    'po4a.conf' => 'cfg/single-nopotpo/single.conf',
    'closed_path' => 'cfg/*/', # Do not use or modify the other tests
    'expected_files' => 'single.fr.po  single.pot',

  }, {
    'doc' => 'Single language, no po',
    'po4a.conf' => 'cfg/single-nopo/single.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => 'single.fr.po  single.pot',

  }, {
    'doc' => 'Single language, no po, --no-update',
    'po4a.conf' => 'cfg/single-nopo/single.conf',
    'options' => ' --no-update',
    'closed_path' => 'cfg/*/',
    'expected_outfile' => 'cfg/single-nopo/_output-noupdate',
    'expected_files'   => '',

  }, {
    'doc' => 'Single language, with translation to create',
    'po4a.conf' => 'cfg/single/single.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => 'single.fr.po  single.pot single.man.fr.1',

  }, {
    'doc' => 'Single language, translation uptodate',
    'po4a.conf' => 'cfg/single-uptodate/single-uptodate.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => 'single-uptodate.fr.po  single-uptodate.pot single-uptodate.man.fr.1',

  }, {
    'doc' => 'Single language, translation already fuzzy',
    'po4a.conf' => 'cfg/single-fuzzy/po4a.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => 'single-fuzzy.fr.po single-fuzzy.pot',

  }, {
    'doc' => 'Single language, translation fuzzied during the update',
    'po4a.conf' => 'cfg/single-fuzzied/po4a.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => 'single-fuzzied.fr.po single-fuzzied.pot',
	
  }, {
    'doc' => 'Single language, translation that would be fuzzied during the update, but with --no-update command-line option',
    'po4a.conf' => 'cfg/single-fuzzied-noup/po4a.conf',
    'options' => '--no-update',
    'closed_path' => 'cfg/*/',
    'expected_files' => '',

  }, {
    'todo' => 'BUG: po files are not updated when the master file changes',

    'doc' => 'Single language, with a new string appearing in the master doc',
    'po4a.conf' => 'cfg/single-newstr/po4a.conf',
    'closed_path' => 'cfg/*/',
    'expected_files' => '',

  };


# TODO: single:  fuzzied / fuzzied-noup / partial
# TODO: split: nopotpo / nopo / nopo-noupdate / notrans / uptodate / fuzzy / fuzzied / fuzzied-noupdate
# TODO: multi: nopotpo / nopo / nopo-noupdate / notrans / uptodate / fuzzy / fuzzied / fuzzied-noupdate
# TODO: language-specific option overriding generic option
# TODO: command line option overriding generic option
# TODO: command line option overriding language-specific option

my @ignored_tests;
push @ignored_tests, {
    'doc' => 'single config file - with a provided translation',
    'run' => 'cp t-05-config/test00.fr.po tmp/test00.fr.po && '.
             'chmod u+w tmp/test00.fr.po && '.
             "PATH/po4a".' t-05-config/test00.conf > tmp/err 2>&1',
    'tests' => [
	"diff -u t-05-config/test01.err tmp/err",
	"diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test00.pot tmp/test00.pot",
	"diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test00.fr.po tmp/test00.fr.po",
	"diff -u t-05-config/test00_man.fr.1 tmp/test00_man.fr.1"
    ]
  }, {
    'doc'       => 'template languages',
    'po4a.conf' => 't-05-config/test02.conf',
    'tests' => [
	"diff -u t-05-config/test02.err tmp/err",
	"diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	"diff -u -I\'^#\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po-empty tmp/test02.fr.po",
	"diff -u -I\'^#\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po-empty tmp/test02.es.po",
	"diff -u -I\'^#\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po-empty tmp/test02.it.po",
	"diff -u -I\'^#\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po-empty tmp/test02.de.po",
	"test ! -e tmp/test02_man.fr.1",
	"test ! -e tmp/test02_man.es.1",
	"test ! -e tmp/test02_man.it.1",
	"test ! -e tmp/test02_man.de.1"
    ]
  }, {
      'doc' => 'template languages - with translations',
      'run' => 'cp t-05-config/test02.??.po tmp/ && '.
               'chmod u+w tmp/test02.??.po && '.
	       'PATH/po4a t-05-config/test02.conf > tmp/err',
      'tests' => [
	  "diff -u t-05-config/test03.err tmp/err",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "test ! -e tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "test ! -e tmp/test02_man.de.1"
      ]
  }, {
      'doc' => 'template languages - command line arguments',
      'run' => 'cp t-05-config/test02.??.po tmp/ && '.
 	       'chmod u+w tmp/test02.??.po && '.
 	       'PATH -v -k 0 t-05-config/test02.conf >tmp/err',
      'tests' => [
	  "sed -e 's,^\.* done\.,. done.,' -e 's,^tmp/test02\\.[^:]*\.po: ,,' tmp/err | diff -u t-05-config/test04.err - ",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "diff -u t-05-config/test02_man.es.1 tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "diff -u t-05-config/test02_man.de.1 tmp/test02_man.de.1",
      ]
  }, {
      'doc'  => 'command line arguments + options (-k 0 is specified in the file opt)', 
      'run'  => 'cp t-05-config/test02.??.po tmp/ && '.
                'chmod u+w tmp/test02.??.po && '.
	        'PATH/po4a -v t-05-config/test03.conf',
      'tests' => [
	  "sed -e 's,^\.* done\.,. done.,' -e 's,^tmp/test02\\.[^:]*\.po: ,,' tmp/err | diff -u t-05-config/test04.err - ",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "diff -u t-05-config/test02_man.es.1 tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "diff -u t-05-config/test02_man.de.1 tmp/test02_man.de.1"
      ]
  }, {

      'doc'  => 'module alias (-k 0 -v is specified for the alias) + options ',
      'run'  => 'cp t-05-config/test02.??.po tmp/ && '.
 	        'chmod u+w tmp/test02.??.po && '.
 	        'PATH/po4a t-05-config/test04.conf > tmp/err',
      'tests' => [
	  "diff -u t-05-config/test06.err tmp/err",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "diff -u t-05-config/test02_man.es.1 tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "diff -u t-05-config/test02_man.de.1 tmp/test02_man.de.1"
      ]
  }, {
      'doc'  => 'module alias + options per language',
      'run'  => 'cp t-05-config/test02.??.po tmp/ && '.
                'chmod u+w tmp/test02.??.po && '.
                'PATH/po4a t-05-config/test05.conf',
      'tests' => [
	  "diff -u t-05-config/test07.err tmp/err",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "diff -u t-05-config/test02_man.es.1 tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "test ! -e tmp/test02_man.de.1"
      ]
  }, {
      'doc'  => 'template languages in po4a_paths',
      'run'  => 'cp t-05-config/test02.??.po tmp/ && '.
                'chmod u+w tmp/test02.??.po && '.
                'PATH/po4a -f t-05-config/test08.conf > tmp/err 2>&1',
      'tests' => [
	  "diff -u t-05-config/test03.err tmp/err",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' -IContent-Type: t-05-config/test02.pot tmp/test02.pot",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.fr.po tmp/test02.fr.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.es.po tmp/test02.es.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.it.po tmp/test02.it.po",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test02.de.po tmp/test02.de.po",
	  "diff -u t-05-config/test02_man.fr.1 tmp/test02_man.fr.1",
	  "test ! -e tmp/test02_man.es.1",
	  "diff -u t-05-config/test02_man.it.1 tmp/test02_man.it.1",
	  "test ! -e tmp/test02_man.de.1"
      ]
  }, {
      'doc' => 'Check that no-update actually does not update the po file',
      'run' => 'cp t-05-config/test00.fr.po tmp '.
               '&& printf "\n#. Fake entry\nmsgid \"This entry will disappear if pofile is updated\"\nmsgstr \"\"\n" >> tmp/test00.fr.po '.
               '&& touch -d "2 hours ago" tmp/test00.fr.po '.
               '&& PATH/po4a --no-update t-05-config/test00.conf >> tmp/test09.err 2>&1',
      'tests' => [
          "diff -u t-05-config/test09.err tmp/test09.err",
	  "diff -u -I\'^#:\' -I'^\"POT-Creation-Date:' -I'^\"PO-Revision-Date:' t-05-config/test09.fr tmp/test00.fr.po",
	  "test tmp/test00.fr.po -ot tmp/test09.err"
      ]
  }, {
      'doc' => 'Detect broken po files',
      'run' => 'cp t-05-config/test50.* tmp/ '.
	       '&& PATH/po4a -f t-05-config/test50.conf > tmp/test50.err 2>&1',
      'tests' => [
	  'diff -u t-05-config/test50.err tmp/test50.err',
	  'test ! -e tmp/test50.en.1'
      ]
	  
  };

run_all_tests(@tests);

0;
