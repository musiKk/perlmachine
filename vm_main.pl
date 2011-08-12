#!/usr/bin/env perl

use warnings;
use strict;

use Java::VM;
use Java::VM::Classpath;

my $classpath = Java::VM::Classpath->new;
$classpath->add_entry( '.' );

my $vm = Java::VM->new( class_name => 'Testclass', classpath => $classpath );
$vm->start;
